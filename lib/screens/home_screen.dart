// Path: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import '../models/math_models.dart';
import 'topic_selection_screen.dart';
import 'rules_list_screen.dart';
import 'practice_type_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'CalcMemo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Master Calculus',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Button 1: Browse Rules Flow
            MenuCard(
              title: 'Browse Rules',
              icon: Icons.menu_book_rounded,
              color: Colors.blueAccent,
              onTap: () {
                // Navigate to Topic Selection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicSelectionScreen(
                      title: 'Select Topic for Rules',
                      onTopicSelected: (ctx, selectedTopic) {
                        // After topic is selected, go to Rules List
                        Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                RulesListScreen(topic: selectedTopic),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // Button 2: Practice Mode
            MenuCard(
              title: 'Practice Mode',
              icon: Icons.quiz_rounded,
              color: Colors.deepPurpleAccent,
              onTap: () {
                // 1. Select Topic First
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicSelectionScreen(
                      title: 'Select Topic to Practice',
                      onTopicSelected: (ctx, selectedTopic) {
                        // 2. Select Type (Rule vs Numerical)
                        Navigator.push(
                          ctx,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                PracticeTypeScreen(topic: selectedTopic),
                          ),
                        );
                      },
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
