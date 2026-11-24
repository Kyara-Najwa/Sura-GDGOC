import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BL {
  static const ink = Color(0xFF0F172A);
  static const inkMuted = Color(0xFF475569);

  static const sky600 = Color(0xFF0284C7);
  static const sky700 = Color(0xFF0369A1);
  static const purple600 = Color(0xFF9333EA);
  static const emerald600 = Color(0xFF059669);
  static const amber600 = Color(0xFFD97706);
  static const rose600 = Color(0xFFE11D48);

  static const gradBase = Color(0xFFF8FAFC);
  static const gradBlue = Color(0xFF8EC5E8);
  static const gradYellow = Color(0xFFEFF0A8);

  static const glass = Color(0xB3FFFFFF);
  static const glassBorder = Color(0xCCFFFFFF);

  static const oled = Color(0xFF030712);
  static const oledText = Color(0xFFF1F5F9);
}

BoxDecoration glassCard({double radius = 20}) => BoxDecoration(
      color: BL.glass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: BL.glassBorder),
      boxShadow: const [
        BoxShadow(
          color: Color(0x140F172A),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    );

ThemeData buildTheme() {
  const scheme = ColorScheme.light(
    primary: BL.sky600,
    onPrimary: Colors.white,
    secondary: BL.purple600,
    surface: Colors.white,
    onSurface: BL.ink,
    outline: Color(0x330F172A),
    error: BL.rose600,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: BL.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: BL.glass,
      indicatorColor: Color(0x4D0284C7),
      elevation: 0,
    ),
  );
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BL.gradBase),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(1.1, -0.9),
              radius: 0.95,
              colors: [BL.gradYellow, Color(0x00EFF0A8)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.9, -0.6),
              radius: 1.15,
              colors: [BL.gradBlue, Color(0x008EC5E8)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.45, 0.85],
              colors: [Color(0x00F8FAFC), Color(0x00F8FAFC), BL.gradBase],
            ),
          ),
        ),
        child,
      ],
    );
  }
}