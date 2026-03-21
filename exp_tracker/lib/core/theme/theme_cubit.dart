import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that manages the app's theme mode (Light / Dark / System).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Toggle between light and dark mode explicitly.
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }

  /// Set the theme mode directly.
  void setThemeMode(ThemeMode mode) {
    emit(mode);
  }

  /// Check if dark mode is active for a given context.
  /// Accounts for ThemeMode.system by checking the platform brightness.
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}
