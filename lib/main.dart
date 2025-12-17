import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'core/score_manager.dart';
import 'core/data_manager.dart';
import 'core/theme_manager.dart';
import 'core/settings_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScoreManager().init();
  await DataManager().loadData();
  await ThemeManager().init();
  SettingsManager().init();

  runApp(const CalcMemoApp());
}

class CalcMemoApp extends StatelessWidget {
  const CalcMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager().themeModeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'CalcMemo',
          debugShowCheckedModeBanner: false,

          themeMode: currentMode,

          // --- AÇIK TEMA (LIGHT) ---
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            scaffoldBackgroundColor: Colors.grey[100],
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // DÜZELTME: CardTheme -> CardThemeData olarak güncellendi
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          // --- KOYU TEMA (DARK) ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // DÜZELTME: CardTheme -> CardThemeData olarak güncellendi
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
            // GERİ GELDİ: Switch (Anahtar) Rengi Özelleştirme
            switchTheme: SwitchThemeData(
              // Not: Yeni Flutter sürümlerinde MaterialStateProperty -> WidgetStateProperty oldu
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.deepPurpleAccent;
                }
                return null;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.deepPurpleAccent.withOpacity(0.5);
                }
                return null;
              }),
            ),
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}
