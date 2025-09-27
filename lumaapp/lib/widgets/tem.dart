// theme_manager.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// یک Enum برای تم‌ها
enum AppTheme { light, dark }

class ThemeManager extends ChangeNotifier {
  // تم پیش‌فرض
  AppTheme _currentTheme = AppTheme.dark;

  ThemeData get currentThemeData => _currentTheme == AppTheme.dark
      ? ThemeData.dark() // تم تیره پیش‌فرض فلاتر
      : ThemeData.light(); // تم روشن پیش‌فرض فلاتر

  AppTheme get currentTheme => _currentTheme;

  // متد بارگذاری تم از حافظه محلی
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? true; // پیش‌فرض: تیره
    _currentTheme = isDark ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }

  List<Color> get backgroundGradientColors {
    if (_currentTheme == AppTheme.dark) {
      // گرادیانت برای تم تیره (همان گرادیانت اصلی شما)
      return [
        const Color(0xFF000AAB), // آبی تیره
        Colors.black,            // مشکی
      ];
    } else {
      // گرادیانت برای تم روشن (یک تم روشن‌تر و ملایم‌تر)
      return [
        Color(0xFF3F5FFF),  // آبی خیلی روشن برای بالا
        Colors.white,              // سفید برای پایین
      ];
    }
  }

  void toggleTheme() async {
    _currentTheme = _currentTheme == AppTheme.dark ? AppTheme.light : AppTheme.dark;

    // ذخیره در SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _currentTheme == AppTheme.dark);

    notifyListeners(); // اطلاع‌رسانی به UI برای رفرش
  }
}