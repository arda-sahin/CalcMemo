// Path: lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
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