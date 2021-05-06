part of 'plan_enums.dart';

enum WalkingSpeed { slow, calm, average, prompt, fast }

WalkingSpeed getWalkingSpeed(String key) {
  return WalkingSpeedExtension.names.keys.firstWhere(
    (keyE) => keyE.name == key,
    orElse: () => WalkingSpeed.average,
  );
}

extension WalkingSpeedExtension on WalkingSpeed {
  static const values = <WalkingSpeed, double>{
    WalkingSpeed.slow: 0.69,
    WalkingSpeed.calm: 0.97,
    WalkingSpeed.average: 1.2,
    WalkingSpeed.prompt: 1.67,
    WalkingSpeed.fast: 2.22,
  };
  static const names = <WalkingSpeed, String>{
    WalkingSpeed.slow: "slow",
    WalkingSpeed.calm: "calm",
    WalkingSpeed.average: "average",
    WalkingSpeed.prompt: "prompt",
    WalkingSpeed.fast: "fast",
  };
  double get value => values[this] ?? 1.2;
  String get name => names[this] ?? "slow";
}
