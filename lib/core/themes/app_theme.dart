import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: ThemeConstants.lightPrimary,
      secondary: ThemeConstants.lightSecondary,
      background: ThemeConstants.lightBackground,
      surface: ThemeConstants.lightSurface,
      error: ThemeConstants.lightError,
      onPrimary: ThemeConstants.lightOnPrimary,
      onBackground: ThemeConstants.lightOnBackground,
      onSurface: ThemeConstants.lightOnSurface,
    ),
    scaffoldBackgroundColor: ThemeConstants.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeConstants.lightPrimary,
      foregroundColor: ThemeConstants.lightOnPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: ThemeConstants.lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radius_md),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.lightPrimary,
      foregroundColor: ThemeConstants.lightOnPrimary,
    ),
    textTheme: const TextTheme(
      headlineLarge: ThemeConstants.headlineLarge,
      headlineMedium: ThemeConstants.headlineMedium,
      titleLarge: ThemeConstants.titleLarge,
      bodyLarge: ThemeConstants.bodyLarge,
      bodyMedium: ThemeConstants.bodyMedium,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: ThemeConstants.darkPrimary,
      secondary: ThemeConstants.darkSecondary,
      background: ThemeConstants.darkBackground,
      surface: ThemeConstants.darkSurface,
      error: ThemeConstants.darkError,
      onPrimary: ThemeConstants.darkOnPrimary,
      onBackground: ThemeConstants.darkOnBackground,
      onSurface: ThemeConstants.darkOnSurface,
    ),
    scaffoldBackgroundColor: ThemeConstants.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeConstants.darkPrimary,
      foregroundColor: ThemeConstants.darkOnPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: ThemeConstants.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radius_md),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.darkPrimary,
      foregroundColor: ThemeConstants.darkOnPrimary,
    ),
    textTheme: const TextTheme(
      headlineLarge: ThemeConstants.headlineLarge,
      headlineMedium: ThemeConstants.headlineMedium,
      titleLarge: ThemeConstants.titleLarge,
      bodyLarge: ThemeConstants.bodyLarge,
      bodyMedium: ThemeConstants.bodyMedium,
    ),
  );
}
