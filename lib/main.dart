// Path: lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'core/score_manager.dart';
import 'core/data_manager.dart';

void main() async {
  // Flutter motorunun hazır olduğundan emin ol
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Puanları Yükle
  await ScoreManager().init();
  
  // 2. JSON Verisini Yükle (Asenkron)
  await DataManager().loadData();

  runApp(const CalcMemoApp());
}

class CalcMemoApp extends StatelessWidget {
  const CalcMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcMemo',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto', // Default font
      ),
      home: const HomeScreen(),
    );
  }
}