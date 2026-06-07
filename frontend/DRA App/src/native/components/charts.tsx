import { Text, View } from "react-native";
import Svg, { Circle, Path, Polyline } from "react-native-svg";
import { C, font } from "../constants";

export function LineChart({
  perfData,
  benchmarkData,
}: {
  perfData: number[];
  benchmarkData: number[];
}) {
  const width = 320;
  const height = 150;

  if (perfData.length < 2 || benchmarkData.length < 2) {
    return (
      <Svg width="100%" height={190} viewBox={`0 0 ${width} ${height + 40}`}>
        <Polyline
          points={`0,${height / 2} ${width},${height / 2}`}
          fill="none"
          stroke={C.border}
          strokeWidth={2}
          strokeDasharray="6 6"
        />
      </Svg>
    );
  }

  const allValues = [...perfData, ...benchmarkData];
  const min = Math.min(...allValues) * 0.99;
  const max = Math.max(...allValues) * 1.01;

  if (min === max) {
    return (
      <Svg width="100%" height={190} viewBox={`0 0 ${width} ${height + 40}`}>
        <Polyline
          points={`0,${height / 2} ${width},${height / 2}`}
          fill="none"
          stroke={C.border}
          strokeWidth={2}
          strokeDasharray="6 6"
        />
      </Svg>
    );
  }

  const points = (data: number[]) =>
    data
      .map((value, index) => {
        const x = (index / (data.length - 1)) * width;
        const y = height - ((value - min) / (max - min)) * height;
        return `${x},${y}`;
      })
      .join(" ");

  const areaPath = `M0,${height} L${points(perfData).replaceAll(" ", " L")} L${width},${height} Z`;

  return (
    <Svg width="100%" height={190} viewBox={`0 0 ${width} ${height + 40}`}>
      <Path d={areaPath} fill="rgba(49,230,255,0.13)" />
      <Polyline
        points={points(benchmarkData)}
        fill="none"
        stroke={C.text2}
        strokeWidth={2}
        strokeDasharray="6 6"
      />
      <Polyline
        points={points(perfData)}
        fill="none"
        stroke={C.cyan}
        strokeWidth={4}
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      {perfData.map((value, index) => {
        const x = (index / (perfData.length - 1)) * width;
        const y = height - ((value - min) / (max - min)) * height;
        return <Circle key={index} cx={x} cy={y} r={4} fill={C.cyan} />;
      })}
    </Svg>
  );
}

export function Legend({ color, label }: { color: string; label: string }) {
  return (
    <View style={{ flexDirection: "row", alignItems: "center", gap: 6 }}>
      <View style={{ width: 18, height: 3, borderRadius: 2, backgroundColor: color }} />
      <Text selectable style={{ color: C.text2, fontFamily: font.regular, fontSize: 11 }}>
        {label}
      </Text>
    </View>
  );
}
