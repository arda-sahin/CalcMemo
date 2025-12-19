import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'quiz_screen.dart';

class ReviewSelectionScreen extends StatelessWidget {
  const ReviewSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review & Improve"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Focus on your weak points",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // BUTTON 1: FAVORITES
            MenuCard(
              title: "Review Favorites",
              icon: Icons.star_rate_rounded,
              color: Colors.amber[700]!,
              onTap: () {
                // Navigate to QuizScreen in FAVORITES mode
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizScreen(
                      source: QuizSource.favorites,
                      // topic is not needed here
                    ),
                  ),
                );
              },
            ),

            // BUTTON 2: MISTAKES (Placeholder)
            MenuCard(
              title: "Fix Mistakes",
              icon: Icons.build_circle_rounded,
              color: Colors.redAccent,
              onTap: () {
                // Placeholder action for now
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mistakes feature is coming soon!"),
                    duration: Duration(seconds: 2),
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