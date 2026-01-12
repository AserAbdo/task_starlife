import 'package:flutter/material.dart';

/// App color palette extracted from Star Life branding
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryGold = Color(0xFFE5A624);
  static const Color primaryGoldLight = Color(0xFFF5C842);
  static const Color primaryGoldDark = Color(0xFFB8841C);

  // Background Gradient Colors
  static const Color gradientStart = Color(0xFF2D1B4E); // Deep purple
  static const Color gradientMiddle = Color(0xFF4A3A7A); // Purple
  static const Color gradientEnd = Color(0xFF5B6B9A); // Blue-purple

  // Secondary Colors
  static const Color deepPurple = Color(0xFF1A0F30);
  static const Color purple = Color(0xFF6B5B95);
  static const Color lightPurple = Color(0xFF8E7CC3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  // Pre-defined opacity variants
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);

  static const Color gold20 = Color(0x33E5A624);
  static const Color gold30 = Color(0x4DE5A624);
  static const Color gold40 = Color(0x66E5A624);

  static const Color grey30 = Color(0x4D9E9E9E);
  static const Color grey50 = Color(0x809E9E9E);

  static const Color deepPurple15 = Color(0x261A0F30);
  static const Color deepPurple20 = Color(0x331A0F30);

  static const Color black30 = Color(0x4D000000);

  // Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
    stops: [0.0, 0.5, 1.0],
  );

  // Button Gradient
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGoldLight, primaryGold, primaryGoldDark],
  );
}
