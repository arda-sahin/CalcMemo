// Path: lib/screens/practice_type_screen.dart

import 'package:flutter/material.dart';
import '../models/math_models.dart';
import '../widgets/menu_card.dart';
import 'quiz_screen.dart';

class PracticeTypeScreen extends StatelessWidget {
  final Topic topic;

  const PracticeTypeScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practice: ${topic.displayName}")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Choose your training style",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Option 1: Flashcards (Ezber)
            MenuCard(
              title: "Memorize Rules",
              icon: Icons.style, // Cards icon
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      topic: topic, 
                      isPracticeMode: false, // Rule Memorization
                    ),
                  ),
                );
              },
            ),

            // Option 2: Numerical Problems (Sayısal)
            MenuCard(
              title: "Solve Problems",
              icon: Icons.calculate, // Calculator icon
              color: Colors.deepOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      topic: topic, 
                      isPracticeMode: true, // Numerical + Hint
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}