import 'package:flutter/material.dart';

class ThemeConstants {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2196F3);
  static const Color lightSecondary = Color(0xFF64B5F6);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightError = Color(0xFFE57373);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF212121);
  static const Color lightOnSurface = Color(0xFF424242);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF1976D2);
  static const Color darkSecondary = Color(0xFF42A5F5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFEEEEEE);
  static const Color darkOnSurface = Color(0xFFE0E0E0);

  // Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  // Padding and Margin
  static const double spacing_xs = 4.0;
  static const double spacing_sm = 8.0;
  static const double spacing_md = 16.0;
  static const double spacing_lg = 24.0;
  static const double spacing_xl = 32.0;

  // Border Radius
  static const double radius_sm = 4.0;
  static const double radius_md = 8.0;
  static const double radius_lg = 12.0;
  static const double radius_xl = 16.0;

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
}
