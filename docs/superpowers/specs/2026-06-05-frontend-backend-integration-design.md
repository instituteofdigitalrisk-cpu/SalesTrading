# Frontend–Backend Integration Design
_Date: 2026-06-05_

## Overview

Wire the Expo web frontend ("DRA App") to the Flask REST backend, replace local-storage auth and portfolio stores with real API calls, and containerise all three services (MySQL, Flask, Expo web) in Docker Compose.

---

## Architecture

### API Client (`src/native/api.ts`)

A single module that owns all HTTP communication with the backend.

**Base URL**: `http://localhost:5000`  
The Expo web app is served to the browser from a Docker container. The browser makes API calls to the Flask backend via the exposed host port 5000.

**Token storage**: JWT returned from `/auth/register` or `/auth/login` is written to `localStorage` (web) with an `AsyncStorage` fallback for native. Every authenticated request includes `Authorization: Bearer <token>`.

**Structure**:
```
getToken() / setToken() / clearToken()   — token helpers
apiFetch(path, options)                  — base fetch with auth header + error normalisation

auth.register(data)          → POST /auth/register
auth.login(email, password)  → POST /auth/login

portfolio.getSummary(userId)    → GET /portfolio/summary/:id
portfolio.getHoldings(userId)   → GET /portfolio/holdings/:id
portfolio.getTrades(userId)     → GET /portfolio/trades/:id
portfolio.executeTrade(data)    → POST /portfolio/trade

market.getPrice(ticker)         → GET /market/price/:ticker

analytics.getLeaderboard(week?) → GET /analytics/leaderboard
analytics.getScores(userId)     → GET /analytics/scores/:id
```

### Auth Store (`src/native/auth-store.ts`)

| Current | After |
|---|---|
| `saveRegisteredUser()` writes to localStorage | Calls `api.auth.register()`, stores returned `user` + `token` locally |
| `signInUser()` reads from localStorage | Calls `api.auth.login()`, stores returned `user` + `token` locally |
| `getActiveUser()` reads localStorage | Unchanged — reads locally cached user object written at login/register |
| `clearActiveUser()` | Clears token via `api.clearToken()` + clears cached user |

### Portfolio Store (`src/native/portfolio-store.ts`)

| Current | After |
|---|---|
| `savePortfolioDraft()` writes to localStorage | Calls `api.portfolio.executeTrade()` |
| `getPortfolioDraft()` reads localStorage | Calls `api.portfolio.getSummary()` + `api.portfolio.getHoldings()` |

---

## Page Wiring

| Page | API calls |
|---|---|
| `registration-page.tsx` | `api.auth.register()` → store user + token → navigate to dashboard |
| `sign-in-page.tsx` | `api.auth.login()` → store user + token → navigate to dashboard |
| `dashboard.tsx` | `api.portfolio.getSummary(userId)` on mount |
| `portfolio-builder.tsx` | `api.market.getPrice(ticker)` for live price preview; `api.portfolio.executeTrade()` on submit |
| `leaderboard.tsx` | `api.analytics.getLeaderboard()` on mount |
| `scores.tsx` | `api.analytics.getScores(userId)` on mount |
| `market-ticker.tsx` | Hardcoded tickers in `constants.ts` retained — live prices deferred to future pass |

---

## Docker Setup

### Services

```
mysql     — MySQL 8.0, port 3306, schema initialised from migrations/schema.sql
backend   — Flask, port 5000, env_file ./backend/.env, DB_HOST overridden to "mysql"
frontend  — Expo web, port 8081, depends_on backend
```

### backend/Dockerfile

- Base: `python:3.11-slim`
- Install `requirements.txt`
- Entrypoint: wait for MySQL to accept connections, then `flask run --host 0.0.0.0 --port 5000`
- Waiting strategy: shell loop with `mysqladmin ping` before starting Flask

### frontend/Dockerfile

- Base: `node:20-slim`
- Install dependencies (`npm install`)
- Expose port 8081
- Command: `npx expo start --web --port 8081`
- Source mounted as volume for hot reload in dev

### CORS

Backend already initialised with `origins: "*"` — no changes needed.

### Environment

`backend/.env` keeps `DB_HOST=localhost` for local dev outside Docker.  
`docker-compose.yml` overrides `DB_HOST=mysql` via the `environment` block.

---

## Data Flow

```
Browser
  │  GET http://localhost:8081   (Expo web app)
  │
  ▼
frontend container (port 8081)
  │
  │  fetch("http://localhost:5000/auth/login", ...)   [JS runs in browser]
  ▼
backend container (port 5000)
  │
  │  SQLAlchemy queries
  ▼
mysql container (port 3306, internal network only)
```

---

## Out of Scope

- Live market ticker strip (hardcoded data retained for now)
- Native mobile (iOS/Android) — web only
- Production hardening (HTTPS, secrets management, non-root Docker users)
- TanStack Query / axios — plain `fetch` only
