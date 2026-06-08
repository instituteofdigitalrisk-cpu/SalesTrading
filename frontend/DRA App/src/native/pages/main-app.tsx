import { BlurView } from "expo-blur";
import { Image } from "expo-image";
import { BarChart3, Bell, BookOpen, BriefcaseBusiness, LayoutDashboard, LogOut, Trophy, UserRound } from "lucide-react-native";
import { useEffect, useMemo, useRef, useState } from "react";
import { Modal, Pressable, ScrollView, Text, TouchableOpacity, useWindowDimensions, View } from "react-native";
import type { ScrollView as ScrollViewType } from "react-native";
import { SafeAreaView, useSafeAreaInsets } from "react-native-safe-area-context";
import { clearActiveUser } from "../auth-store";
import { clearMarketCache } from "../market-store";
import { analytics } from "../api";
import type { BackendWeeklyScore } from "../api";
import { brandLogo, C, font } from "../constants";
import type { IconType, MainTab, UserData } from "../types";
import { MarketTicker } from "../components/market-ticker";
import { GlassCard, Progress } from "../components/ui";
import { Courses } from "./courses";
import { Dashboard } from "./dashboard";
import { Leaderboard } from "./leaderboard";
import { PortfolioBuilder } from "./portfolio-builder";
import { Scores } from "./scores";

const navItems: { id: MainTab; label: string; Icon: IconType }[] = [
  { id: "dashboard", label: "Home", Icon: LayoutDashboard },
  { id: "portfolio", label: "Portfolio", Icon: BriefcaseBusiness },
  { id: "scores", label: "Scores", Icon: BarChart3 },
  { id: "leaderboard", label: "Ranks", Icon: Trophy },
  { id: "courses", label: "Courses", Icon: BookOpen },
];

export function MainApp({ userData, onLogout }: { userData: UserData | null; onLogout: () => void }) {
  const [activeTab, setActiveTab] = useState<MainTab>("dashboard");
  const [profileOpen, setProfileOpen] = useState(false);
  const [portfolioScore, setPortfolioScore] = useState<number | null>(null);
  const { width } = useWindowDimensions();
  const insets = useSafeAreaInsets();
  const isWide = width > 780;
  const userName = userData?.fullName || "Student Analyst";
  const studentId = userData?.studentId || "202600000000";
  const initials = useMemo(() => userName.split(" ").map((item) => item[0]).join("").slice(0, 2).toUpperCase(), [userName]);
  const bottomNavHeight = 92 + insets.bottom;
  const scrollRef = useRef<ScrollViewType>(null);

  useEffect(() => {
    if (!profileOpen) setPortfolioScore(null);
  }, [profileOpen]);

  useEffect(() => {
    if (!profileOpen || portfolioScore !== null) return;
    analytics
      .getScores(studentId)
      .then((data) => {
        if (data.scores.length === 0) {
          setPortfolioScore(0);
          return;
        }
        const latest = data.scores.reduce((max: BackendWeeklyScore, s: BackendWeeklyScore) =>
          s.week_number > max.week_number ? s : max
        );
        setPortfolioScore(Math.round(latest.final_score));
      })
      .catch(() => setPortfolioScore(0));
  }, [profileOpen, studentId, portfolioScore]);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: C.bg0 }} edges={["top", "left", "right"]}>
      <MarketTicker />
      <View style={{ zIndex: 2, paddingHorizontal: 18, paddingVertical: 12, borderBottomColor: C.border, borderBottomWidth: 1, flexDirection: "row", alignItems: "center", justifyContent: "space-between", backgroundColor: "rgba(5,8,18,0.98)" }}>
        <View style={{ flexDirection: "row", alignItems: "center", gap: 10, flex: 1 }}>
          <Image source={brandLogo} style={{ width: 38, height: 38, borderRadius: 12 }} />
          <View style={{ flex: 1 }}>
            <Text selectable style={{ color: C.text0, fontFamily: font.medium, fontSize: 13 }}>
              Digital Risk Academy
            </Text>
            <Text selectable style={{ color: C.text2, fontSize: 10, marginTop: 2 }}>
              {studentId} | IB Sales & Trading Challenge
            </Text>
          </View>
        </View>
        <View style={{ flexDirection: "row", alignItems: "center", gap: 9 }}>
          <Bell size={20} color={C.text1} />
          <TouchableOpacity onPress={() => setProfileOpen(true)} style={{ width: 38, height: 38, borderRadius: 19, backgroundColor: C.cyan, alignItems: "center", justifyContent: "center" }}>
            <Text selectable style={{ color: C.ink, fontFamily: font.medium, fontSize: 13 }}>
              {initials}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      <ScrollView
        ref={scrollRef}
        contentInsetAdjustmentBehavior="automatic"
        style={{ flex: 1 }}
        scrollIndicatorInsets={{ bottom: bottomNavHeight }}
        contentContainerStyle={{ padding: isWide ? 28 : 18, paddingBottom: bottomNavHeight + 56, maxWidth: 980, width: "100%", alignSelf: "center" }}
      >
        {activeTab === "dashboard" ? <Dashboard userName={userName} studentId={studentId} /> : null}
        {activeTab === "portfolio" ? <PortfolioBuilder userData={userData} onSubmitSuccess={() => setTimeout(() => scrollRef.current?.scrollTo({ y: 0, animated: true }), 150)} /> : null}
        {activeTab === "scores" ? <Scores studentId={studentId} /> : null}
        {activeTab === "leaderboard" ? <Leaderboard /> : null}
        {activeTab === "courses" ? <Courses /> : null}
      </ScrollView>

      <BlurView intensity={58} tint="dark" style={{ position: "absolute", left: 0, right: 0, bottom: 0, minHeight: bottomNavHeight, borderTopColor: C.border2, borderTopWidth: 1, zIndex: 5, backgroundColor: "rgba(5,8,18,0.96)" }}>
        <View style={{ flexDirection: "row", justifyContent: "space-around", paddingTop: 8, paddingBottom: insets.bottom + 12, paddingHorizontal: 6 }}>
          {navItems.map(({ id, label, Icon }) => {
            const active = activeTab === id;
            return (
              <TouchableOpacity
                key={id}
                onPress={() => setActiveTab(id)}
                style={{ alignItems: "center", gap: 4, minWidth: 62, paddingVertical: 7, borderRadius: 16, backgroundColor: active ? "rgba(49,230,255,0.14)" : "transparent" }}
              >
                <Icon size={22} color={active ? C.cyan : C.text2} strokeWidth={active ? 2.6 : 2} />
                <Text selectable style={{ color: active ? C.cyan : C.text2, fontFamily: font.medium, fontSize: 11 }}>
                  {label}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </BlurView>

      <Modal transparent animationType="fade" visible={profileOpen} onRequestClose={() => setProfileOpen(false)}>
        <Pressable onPress={() => setProfileOpen(false)} style={{ flex: 1, backgroundColor: "rgba(0,0,0,0.45)", justifyContent: "flex-start", alignItems: "flex-end", padding: 18, paddingTop: 84 }}>
          <GlassCard style={{ width: 300, padding: 16, gap: 13 }} accent={C.cyan}>
            <View style={{ flexDirection: "row", gap: 12, alignItems: "center" }}>
              <View style={{ width: 50, height: 50, borderRadius: 25, backgroundColor: C.cyan, alignItems: "center", justifyContent: "center" }}>
                <UserRound size={25} color={C.ink} />
              </View>
              <View style={{ flex: 1 }}>
                <Text selectable style={{ color: C.text0, fontFamily: font.medium, fontSize: 15 }}>
                  {userName}
                </Text>
                <Text selectable style={{ color: C.text2, fontSize: 12, marginTop: 2 }}>
                  User ID: {studentId}
                </Text>
              </View>
            </View>
            <Progress label="Portfolio score" value={portfolioScore ?? 0} color={C.cyan} />
            <Progress label="Learning completion" value={67} color={C.purple} />
            <Text selectable style={{ color: C.text2, fontSize: 12, lineHeight: 18 }}>
              University: {userData?.university || "Pending"} | IB Sales & Trading Risk Challenge
            </Text>
            <TouchableOpacity
              onPress={() => {
                setProfileOpen(false);
                setActiveTab("scores");
              }}
              style={{ flexDirection: "row", alignItems: "center", gap: 8, padding: 12, borderRadius: 12, backgroundColor: "rgba(49,230,255,0.10)", borderColor: "rgba(49,230,255,0.26)", borderWidth: 1 }}
            >
              <BarChart3 size={17} color={C.cyan} />
              <Text selectable style={{ color: C.cyan, fontFamily: font.medium, fontSize: 13 }}>
                Scores
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => {
                clearMarketCache();
                clearActiveUser();
                setProfileOpen(false);
                onLogout();
              }}
              style={{ flexDirection: "row", alignItems: "center", gap: 8, padding: 12, borderRadius: 12, backgroundColor: "rgba(255,95,126,0.10)", borderColor: "rgba(255,95,126,0.26)", borderWidth: 1 }}
            >
              <LogOut size={17} color={C.red} />
              <Text selectable style={{ color: C.red, fontFamily: font.medium, fontSize: 13 }}>
                Logout
              </Text>
            </TouchableOpacity>
          </GlassCard>
        </Pressable>
      </Modal>
    </SafeAreaView>
  );
}
