import 'package:flutter/material.dart';
import '../core/theme_manager.dart'; // Tema Yöneticisi
import '../core/settings_manager.dart'; // Ayarlar Yöneticisi

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // --- BÖLÜM 1: GÖRÜNÜM (APPEARANCE) ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Appearance",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          // Dark Mode Anahtarı
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeManager().themeModeNotifier,
            builder: (context, currentMode, child) {
              return SwitchListTile(
                title: const Text("Dark Mode"),
                subtitle: const Text("Easier on the eyes at night"),
                secondary: Icon(
                  currentMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.deepPurpleAccent,
                ),
                value: currentMode == ThemeMode.dark,
                onChanged: (val) {
                  ThemeManager().toggleTheme(val);
                },
              );
            },
          ),

          const Divider(),

          // --- BÖLÜM 2: GERİ BİLDİRİM (FEEDBACK) ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Feedback",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          // Titreşim (Haptic Feedback) Anahtarı
          ValueListenableBuilder<bool>(
            valueListenable: SettingsManager().vibrationNotifier,
            builder: (context, isVibrationOn, child) {
              return SwitchListTile(
                title: const Text("Haptic Feedback"),
                subtitle: const Text("Vibrate on correct/wrong answers"),
                secondary: Icon(
                  isVibrationOn ? Icons.vibration : Icons.smartphone,
                  color: Colors.deepPurpleAccent,
                ),
                value: isVibrationOn,
                onChanged: (val) {
                  SettingsManager().toggleVibration(val);
                },
              );
            },
          ),

          // Ses Efektleri (Şimdilik Pasif)
          const ListTile(
            leading: Icon(Icons.volume_up, color: Colors.grey),
            title: Text("Sound Effects"),
            subtitle: Text("Coming soon..."),
            enabled: false, // Tıklanmaz
          ),

          const SizedBox(height: 40),

          // Versiyon Bilgisi
          const Center(
            child: Text(
              "CalcMemo v1.1.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
