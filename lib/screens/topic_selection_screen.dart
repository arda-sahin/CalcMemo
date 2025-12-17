// Path: lib/screens/topic_selection_screen.dart

import 'package:flutter/material.dart';
import '../models/math_models.dart';
import '../widgets/menu_card.dart';

class TopicSelectionScreen extends StatelessWidget {
  final String title;
  final Function(BuildContext, Topic) onTopicSelected;

  const TopicSelectionScreen({
    super.key,
    required this.title,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MenuCard(
              title: Topic.derivative.displayName, // "Derivative"
              icon: Icons.trending_up, // Graph up icon
              color: Colors.orangeAccent,
              onTap: () => onTopicSelected(context, Topic.derivative),
            ),
            MenuCard(
              title: Topic.integral.displayName, // "Integral"
              icon: Icons.functions, // Math function icon
              color: Colors.teal,
              onTap: () => onTopicSelected(context, Topic.integral),
            ),
          ],
        ),
      ),
    );
  }
}