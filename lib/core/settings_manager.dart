import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  // Singleton Pattern
  static final SettingsManager _instance = SettingsManager._internal();
  factory SettingsManager() => _instance;
  SettingsManager._internal();

  // Titreşim ayarını dinleyen değişken (Varsayılan: Açık/True)
  final ValueNotifier<bool> vibrationNotifier = ValueNotifier(true);

  // Hafızadan ayarı yükle
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // Daha önce kaydedilmiş mi bak, yoksa varsayılan true olsun
    vibrationNotifier.value = prefs.getBool('vibration_enabled') ?? true;
  }

  // Ayarı değiştir ve kaydet
  Future<void> toggleVibration(bool isEnabled) async {
    vibrationNotifier.value = isEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', isEnabled);
  }
}
