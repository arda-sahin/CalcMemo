import 'package:flutter/material.dart';
import '../core/theme_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut temanın koyu olup olmadığını kontrol et
    final isDarkMode = ThemeManager().themeModeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Görsel bir başlık
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

          // Tema Değiştirme Anahtarı (Switch)
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

          // Gelecekte ekleyeceğimiz özellikler için yer tutucular (Disabled)
          const ListTile(
            leading: Icon(Icons.vibration, color: Colors.grey),
            title: Text("Haptic Feedback"),
            subtitle: Text("Coming soon..."),
            enabled: false,
          ),
          const ListTile(
            leading: Icon(Icons.volume_up, color: Colors.grey),
            title: Text("Sound Effects"),
            subtitle: Text("Coming soon..."),
            enabled: false,
          ),

          const SizedBox(height: 40),
          const Center(
            child: Text(
              "CalcMemo v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
