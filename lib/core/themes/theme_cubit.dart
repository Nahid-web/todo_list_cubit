import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

/// Theme states
enum ThemeState { light, dark }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light) {
    _loadTheme();
  }

  final Box _settingsBox = Hive.box(AppConstants.settingsBox);

  /// Load saved theme preference from Hive
  Future<void> _loadTheme() async {
    final isDark = _settingsBox.get(AppConstants.themeKey, defaultValue: false);
    emit(isDark ? ThemeState.dark : ThemeState.light);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newState =
        state == ThemeState.light ? ThemeState.dark : ThemeState.light;
    await _settingsBox.put(AppConstants.themeKey, newState == ThemeState.dark);
    emit(newState);
  }

  /// Set specific theme
  Future<void> setTheme(ThemeState themeState) async {
    await _settingsBox.put(
        AppConstants.themeKey, themeState == ThemeState.dark);
    emit(themeState);
  }

  /// Check if current theme is dark
  bool get isDark => state == ThemeState.dark;
}
