import { useEffect, useRef, useState } from "react";
import { Animated, Easing, Text, View } from "react-native";
import { C, font } from "../constants";
import { getMarketIndices } from "../market-store";
import type { MarketIndex } from "../api";

export function MarketTicker() {
  const [indices, setIndices] = useState<MarketIndex[]>([]);
  const translateX = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    getMarketIndices()
      .then(setIndices)
      .catch(() => setIndices([]));
  }, []);

  useEffect(() => {
    if (indices.length === 0) return;
    const animation = Animated.loop(
      Animated.timing(translateX, {
        toValue: -1400,
        duration: 22000,
        easing: Easing.linear,
        useNativeDriver: true,
      }),
    );
    animation.start();
    return () => animation.stop();
  }, [translateX, indices]);

  if (indices.length === 0) {
    return (
      <View
        style={{
          height: 38,
          overflow: "hidden",
          borderBottomWidth: 1,
          borderBottomColor: C.border,
          backgroundColor: "rgba(5,8,18,0.96)",
          justifyContent: "center",
          paddingHorizontal: 16,
        }}
      >
        <Text style={{ color: C.text2, fontSize: 12, fontFamily: font.mono }}>
          Loading market data…
        </Text>
      </View>
    );
  }

  const row = [...indices, ...indices, ...indices, ...indices];

  return (
    <View
      style={{
        height: 38,
        overflow: "hidden",
        borderBottomWidth: 1,
        borderBottomColor: C.border,
        backgroundColor: "rgba(5,8,18,0.96)",
      }}
    >
      <Animated.View
        style={{ flexDirection: "row", alignItems: "center", height: 38, transform: [{ translateX }] }}
      >
        {row.map((ticker, index) => (
          <View
            key={`${ticker.name}-${index}`}
            style={{ height: 38, flexDirection: "row", alignItems: "center", gap: 6, paddingRight: 28 }}
          >
            <Text selectable style={{ color: C.text1, fontSize: 12, fontFamily: font.medium }}>
              {ticker.name}
            </Text>
            <Text selectable style={{ color: C.text0, fontSize: 13, fontFamily: font.mono }}>
              {ticker.price}
            </Text>
            <Text selectable style={{ color: ticker.up ? C.green : C.red, fontSize: 12, fontFamily: font.mono }}>
              {ticker.change}
            </Text>
          </View>
        ))}
      </Animated.View>
    </View>
  );
}
