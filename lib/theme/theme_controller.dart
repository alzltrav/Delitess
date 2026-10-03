import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static const String _themeKey = 'is_dark_mode';
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  
  static Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  
  static Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isCurrentlyDark = themeMode.value == ThemeMode.dark;
    themeMode.value = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool(_themeKey, !isCurrentlyDark);
  }

  static bool get isDark => themeMode.value == ThemeMode.dark;
}