// Path: lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/math_models.dart';
import '../data/mock_data.dart';

// Helper class to standardize data (Adapter Pattern)
class QuizItem {
  final String question;      // What displays on the front
  final String answer;        // What displays on the back
  final bool isQuestionLatex; // Is the question text or a formula?
  final String? hintRuleId;   // ID for the hint (optional)

  QuizItem({
    required this.question,
    required this.answer,
    this.isQuestionLatex = true,
    this.hintRuleId,
  });
}

class QuizScreen extends StatefulWidget {
  final Topic topic;
  final bool isPracticeMode; // false = Memorize Rules, true = Numerical Problems

  const QuizScreen({
    super.key,
    required this.topic,
    required this.isPracticeMode,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizItem> _items = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // PREPARE DATA BASED ON MODE (Adapter Logic)
    if (widget.isPracticeMode) {
      // Load Numerical Questions
      final rawQuestions = MathRepository.questions
          .where((q) => q.topic == widget.topic)
          .toList();
      
      _items = rawQuestions.map((q) => QuizItem(
        question: q.questionTex,
        answer: q.answerTex,
        isQuestionLatex: true,
        hintRuleId: q.ruleId, // Connect hint
      )).toList();

    } else {
      // Load Rules for Memorization
      final rawRules = MathRepository.rules
          .where((r) => r.topic == widget.topic)
          .toList();

      _items = rawRules.map((r) => QuizItem(
        question: r.name,       // Front: "Chain Rule"
        answer: r.texFormula,   // Back: Formula
        isQuestionLatex: false, // Front is text, not math
        hintRuleId: null,       // No hint needed for rules
      )).toList();
    }
    
    // Shuffle for randomness
    _items.shuffle();
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _items.length - 1) {
        _currentIndex++;
        _showAnswer = false;
      } else {
        // End of quiz
        Navigator.pop(context); // Go back
      }
    });
  }

  // Function to show the Hint Bottom Sheet
  void _showHint(String ruleId) {
    // Find the rule from the repository
    final rule = MathRepository.rules.firstWhere(
      (r) => r.id == ruleId, 
      orElse: () => MathRule(id: '', name: 'Error', texFormula: '', topic: Topic.derivative)
    );

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hint: ${rule.name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            const SizedBox(height: 20),
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
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("No questions found for this topic!")),
      );
    }

    final currentItem = _items[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPracticeMode ? "Practice Problems" : "Memorize Rules"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            Text(
              "Question ${_currentIndex + 1} / ${_items.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // --- FLASHCARD AREA ---
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // QUESTION (FRONT)
                      const Text("QUESTION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 20),
                      currentItem.isQuestionLatex
                          ? Math.tex(currentItem.question, textStyle: const TextStyle(fontSize: 24))
                          : Text(currentItem.question, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      
                      const Divider(height: 40),

                      // ANSWER (BACK) - Hidden initially
                      if (_showAnswer) ...[
                        const Text("ANSWER", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                        const SizedBox(height: 20),
                        Math.tex(currentItem.answer, textStyle: const TextStyle(fontSize: 24, color: Colors.green)),
                      ] else ...[
                        const Text("?", style: TextStyle(fontSize: 50, color: Colors.black12)),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- BUTTONS ---
            
            // HINT BUTTON (Only if Practice Mode and Answer is not shown yet)
            if (widget.isPracticeMode && !_showAnswer && currentItem.hintRuleId != null)
              TextButton.icon(
                onPressed: () => _showHint(currentItem.hintRuleId!),
                icon: const Icon(Icons.lightbulb_outline, color: Colors.orange),
                label: const Text("Need a Hint?", style: TextStyle(color: Colors.orange)),
              ),

            const SizedBox(height: 10),

            // SHOW ANSWER / NEXT BUTTON
            ElevatedButton(
              onPressed: _showAnswer ? _nextCard : () => setState(() => _showAnswer = true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: _showAnswer ? Colors.blue : Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              child: Text(
                _showAnswer ? (_currentIndex == _items.length - 1 ? "Finish" : "Next Question") : "Show Answer",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}