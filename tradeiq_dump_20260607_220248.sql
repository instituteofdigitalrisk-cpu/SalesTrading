-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: tradeiq
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `holdings`
--

DROP TABLE IF EXISTS `holdings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holdings` (
  `holding_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `stock_ticker` varchar(20) DEFAULT NULL,
  `stock_name` varchar(100) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `avg_buy_price` decimal(15,2) DEFAULT NULL,
  `current_price` decimal(15,2) DEFAULT NULL,
  `market_value` decimal(15,2) DEFAULT NULL,
  `profit_loss` decimal(15,2) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`holding_id`),
  KEY `fk_holdings_user` (`user_id`),
  CONSTRAINT `fk_holdings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holdings`
--

LOCK TABLES `holdings` WRITE;
/*!40000 ALTER TABLE `holdings` DISABLE KEYS */;
INSERT INTO `holdings` VALUES (1,'TIQ-55BB','AAPL','Apple Inc.',3,310.92,310.90,932.70,-0.06,'2026-06-05 17:00:01');
/*!40000 ALTER TABLE `holdings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `investment_thesis`
--

DROP TABLE IF EXISTS `investment_thesis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investment_thesis` (
  `thesis_id` int NOT NULL AUTO_INCREMENT,
  `trade_id` varchar(20) DEFAULT NULL,
  `user_id` varchar(20) DEFAULT NULL,
  `investment_style` varchar(50) DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT NULL,
  `confidence_score` int DEFAULT NULL,
  `reason_text` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`thesis_id`),
  KEY `fk_thesis_trade` (`trade_id`),
  KEY `fk_thesis_user` (`user_id`),
  CONSTRAINT `fk_thesis_trade` FOREIGN KEY (`trade_id`) REFERENCES `trade_log` (`trade_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_thesis_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investment_thesis`
--

LOCK TABLES `investment_thesis` WRITE;
/*!40000 ALTER TABLE `investment_thesis` DISABLE KEYS */;
/*!40000 ALTER TABLE `investment_thesis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leaderboard`
--

DROP TABLE IF EXISTS `leaderboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leaderboard` (
  `leaderboard_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `week_number` int DEFAULT NULL,
  `portfolio_score` decimal(5,2) DEFAULT NULL,
  `risk_score` decimal(5,2) DEFAULT NULL,
  `thesis_score` decimal(5,2) DEFAULT NULL,
  `execution_score` decimal(5,2) DEFAULT NULL,
  `strategy_score` decimal(5,2) DEFAULT NULL,
  `final_score` decimal(5,2) DEFAULT NULL,
  `rank_position` int DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`leaderboard_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `leaderboard_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leaderboard`
--

LOCK TABLES `leaderboard` WRITE;
/*!40000 ALTER TABLE `leaderboard` DISABLE KEYS */;
/*!40000 ALTER TABLE `leaderboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_setup`
--

DROP TABLE IF EXISTS `portfolio_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_setup` (
  `portfolio_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `total_capital` decimal(15,2) DEFAULT '10000.00',
  `cash_balance` decimal(15,2) DEFAULT '10000.00',
  `risk_appetite` varchar(20) DEFAULT NULL,
  `investment_horizon` varchar(50) DEFAULT NULL,
  `competition_round` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`portfolio_id`),
  KEY `fk_portfolio_user` (`user_id`),
  CONSTRAINT `fk_portfolio_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_setup`
--

LOCK TABLES `portfolio_setup` WRITE;
/*!40000 ALTER TABLE `portfolio_setup` DISABLE KEYS */;
INSERT INTO `portfolio_setup` VALUES (1,'TIQ-7DF1',10000.00,10000.00,NULL,NULL,NULL,'2026-06-04 18:01:17'),(2,'TIQ-1B32',10000.00,10000.00,NULL,NULL,NULL,'2026-06-05 16:52:52'),(3,'TIQ-99E1',10000.00,10000.00,NULL,NULL,NULL,'2026-06-05 16:55:54'),(4,'TIQ-55BB',10000.00,9067.23,NULL,NULL,NULL,'2026-06-05 16:57:29');
/*!40000 ALTER TABLE `portfolio_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) DEFAULT NULL,
  `week_number` int DEFAULT NULL,
  `report_path` varchar(255) DEFAULT NULL,
  `generated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `fk_report_user` (`user_id`),
  CONSTRAINT `fk_report_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_metrics`
--

DROP TABLE IF EXISTS `risk_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `risk_metrics` (
  `risk_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) DEFAULT NULL,
  `sharpe_ratio` decimal(10,4) DEFAULT NULL,
  `beta` decimal(10,4) DEFAULT NULL,
  `volatility` decimal(10,4) DEFAULT NULL,
  `max_drawdown` decimal(10,4) DEFAULT NULL,
  `var_value` decimal(10,4) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`risk_id`),
  KEY `fk_risk_user` (`user_id`),
  CONSTRAINT `fk_risk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_metrics`
--

LOCK TABLES `risk_metrics` WRITE;
/*!40000 ALTER TABLE `risk_metrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `risk_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thesis_scores`
--

DROP TABLE IF EXISTS `thesis_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `thesis_scores` (
  `score_id` int NOT NULL AUTO_INCREMENT,
  `thesis_id` int DEFAULT NULL,
  `clarity_score` decimal(5,2) DEFAULT NULL,
  `reasoning_score` decimal(5,2) DEFAULT NULL,
  `risk_awareness_score` decimal(5,2) DEFAULT NULL,
  `market_understanding_score` decimal(5,2) DEFAULT NULL,
  `total_score` decimal(5,2) DEFAULT NULL,
  `feedback` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`score_id`),
  KEY `fk_score_thesis` (`thesis_id`),
  CONSTRAINT `fk_score_thesis` FOREIGN KEY (`thesis_id`) REFERENCES `investment_thesis` (`thesis_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thesis_scores`
--

LOCK TABLES `thesis_scores` WRITE;
/*!40000 ALTER TABLE `thesis_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `thesis_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_log`
--

DROP TABLE IF EXISTS `trade_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trade_log` (
  `trade_id` varchar(20) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `trade_date` date DEFAULT NULL,
  `stock_ticker` varchar(20) DEFAULT NULL,
  `stock_name` varchar(100) DEFAULT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `allocation_percent` decimal(5,2) DEFAULT NULL,
  `amount_invested` decimal(15,2) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `buy_price` decimal(15,2) DEFAULT NULL,
  `current_sell_price` decimal(15,2) DEFAULT NULL,
  `trade_type` enum('BUY','SELL') DEFAULT NULL,
  `tag1` varchar(100) DEFAULT NULL,
  `tag2` varchar(100) DEFAULT NULL,
  `tag3` varchar(100) DEFAULT NULL,
  `thesis` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`trade_id`),
  KEY `fk_trade_user` (`user_id`),
  CONSTRAINT `fk_trade_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_log`
--

LOCK TABLES `trade_log` WRITE;
/*!40000 ALTER TABLE `trade_log` DISABLE KEYS */;
INSERT INTO `trade_log` VALUES ('TRD-20034B','TIQ-55BB','2026-06-05','AAPL','Apple Inc.','Technology',6.22,621.80,2,310.90,310.90,'SELL',NULL,NULL,NULL,NULL,'2026-06-05 17:00:00'),('TRD-479607','TIQ-55BB','2026-06-05','AAPL','Apple Inc.','Technology',15.55,1554.58,5,310.92,310.92,'BUY','Technology',NULL,NULL,'iPhone supercycle','2026-06-05 16:59:43');
/*!40000 ALTER TABLE `trade_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(20) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `university` varchar(150) DEFAULT NULL,
  `course` varchar(100) DEFAULT NULL,
  `year_of_study` int DEFAULT NULL,
  `participation_type` varchar(20) DEFAULT NULL,
  `team_name` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'student',
  `password_hash` varchar(64) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('TIQ-1B32','Smoke Test',NULL,NULL,'smoke@test.edu',NULL,NULL,NULL,NULL,'individual',NULL,'student','ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f','2026-06-05 16:52:52'),('TIQ-55BB','Test Analyst',NULL,NULL,'analyst2@uni.edu',NULL,'IIT Mumbai','MBA Finance',2,'individual',NULL,'student','937e8d5fbb48bd4949536cd65b8d35c426b80d2f830c5c308e2cdec422ae2244','2026-06-05 16:57:29'),('TIQ-7DF1','Siva',NULL,NULL,'siva@example.com',NULL,NULL,NULL,NULL,'individual',NULL,'student','fcf730b6d95236ecd3c9fc2d92d7b6b2bb061514961aec041d6c7a7192f592e4','2026-06-04 18:01:17'),('TIQ-99E1','Test Analyst',NULL,NULL,'analyst@uni.edu',NULL,'IIT Mumbai','MBA Finance',2,'individual',NULL,'student','937e8d5fbb48bd4949536cd65b8d35c426b80d2f830c5c308e2cdec422ae2244','2026-06-05 16:55:54');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weekly_scores`
--

DROP TABLE IF EXISTS `weekly_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weekly_scores` (
  `score_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(20) NOT NULL,
  `week_number` int NOT NULL,
  `portfolio_score` decimal(5,2) DEFAULT NULL,
  `risk_score` decimal(5,2) DEFAULT NULL,
  `thesis_score` decimal(5,2) DEFAULT NULL,
  `execution_score` decimal(5,2) DEFAULT NULL,
  `strategy_score` decimal(5,2) DEFAULT NULL,
  `final_score` decimal(5,2) DEFAULT NULL,
  `rank_position` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`score_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `weekly_scores_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weekly_scores`
--

LOCK TABLES `weekly_scores` WRITE;
/*!40000 ALTER TABLE `weekly_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `weekly_scores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-07 16:32:51
