import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  // Singleton Pattern
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  // ValueNotifier: Değişiklikleri dinleyen mekanizma
  // Varsayılan olarak sistem temasını (System) kullanıyoruz
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

  // Hafızaya erişim
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // Daha önce kaydedilmiş mi kontrol et
    if (prefs.containsKey('is_dark_mode')) {
      final isDark = prefs.getBool('is_dark_mode') ?? false;
      themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  // Temayı değiştirme fonksiyonu
  Future<void> toggleTheme(bool isDark) async {
    themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
  }
}