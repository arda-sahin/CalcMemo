// Path: lib/screens/rules_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart'; // LaTeX rendering package
import '../models/math_models.dart';
import "../core/data_manager.dart";

class RulesListScreen extends StatelessWidget {
  final Topic topic;

  const RulesListScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    // 1. Filter the rules based on the selected topic
    final displayRules = DataManager().rules
        .where((r) => r.topic == topic)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('${topic.displayName} Rules')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: displayRules.length,
        itemBuilder: (context, index) {
          final rule = displayRules[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rule Name
                  Text(
                    rule.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Divider(height: 20),

                  // Rule Formula (LaTeX Render)
                  Center(
                    child: Math.tex(
                      rule.texFormula,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
