import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/math_models.dart';
import '../core/data_manager.dart';
import '../core/score_manager.dart';
import 'scratchpad_screen.dart';
import 'package:flutter/services.dart';
import '../core/settings_manager.dart';

// Helper class (Adapter)
class QuizItem {
  final String question;
  final String answer;
  final bool isQuestionLatex;
  final String? hintRuleId;

  QuizItem({
    required this.question,
    required this.answer,
    this.isQuestionLatex = true,
    this.hintRuleId,
  });
}

class QuizScreen extends StatefulWidget {
  final Topic topic;
  final bool isPracticeMode;

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

  // Track hint usage for current question
  bool _usedHint = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Veriyi DataManager'dan çekiyoruz
    _items = DataManager().getWeightedQuizItems(
      widget.topic,
      widget.isPracticeMode,
    );

    if (_items.isEmpty) {
      print("Warning: No items found for topic ${widget.topic}");
    }
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _items.length - 1) {
        _currentIndex++;
        _showAnswer = false;
        _usedHint = false; // Reset hint usage for new card
      } else {
        Navigator.pop(context); // End of quiz
      }
    });
  }

  // --- SCORE HANDLING LOGIC ---
  void _handleAnswer(bool isCorrect) {
    // 1. Calculate and update score
    final points = ScoreManager().updateScore(
      isCorrect: isCorrect,
      usedHint: _usedHint,
    );

    // --- YENİ: HAPTIC FEEDBACK (Titreşim) ---
    // Eğer ayarlarda titreşim açık ise çalıştır
    if (SettingsManager().vibrationNotifier.value) {
      if (isCorrect) {
        // Doğru cevap: Hafif, tatmin edici bir titreşim
        HapticFeedback.mediumImpact();
      } else {
        // Yanlış cevap: Daha ağır, uyarıcı bir titreşim
        HapticFeedback.heavyImpact();
      }
    }
    // ---------------------------------------

    // 2. Show Feedback (SnackBar)
    String message = isCorrect ? "Correct!" : "Wrong!";
    Color color = isCorrect ? Colors.green : Colors.red;

    if (isCorrect && ScoreManager().currentCombo > 2) {
      message +=
          " (Combo x${ScoreManager().currentCombo > 4 ? '2.0' : '1.5'}!)";
    }

    message += " ${points >= 0 ? '+' : ''}$points XP";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        duration: const Duration(milliseconds: 800),
      ),
    );

    // 3. Move to next card
    _nextCard();
  }

  void _showHint(String ruleId) {
    setState(() {
      _usedHint = true;
    });

    final rule = DataManager().getRuleById(ruleId);

    if (rule == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          children: [
            Text(
              "Hint: ${rule.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
        body: const Center(child: Text("No questions found!")),
      );
    }

    final currentItem = _items[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isPracticeMode ? "Practice Problems" : "Memorize Rules",
        ),
        centerTitle: true,
        actions: [
          // Show current score in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                "XP: ${ScoreManager().totalScore}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),

      // --- YENİ EKLENEN KISIM: KARALAMA DEFTERİ BUTONU ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit), // Kalem ikonu
        onPressed: () {
          // Scratchpad ekranını aç
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true, // Tam ekran dialog efekti
              builder: (context) => ScratchpadScreen(
                questionTex: currentItem.question, // Mevcut soruyu gönderiyoruz
              ),
            ),
          );
        },
      ),

      // ----------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Question ${_currentIndex + 1} / ${_items.length}",
              style: const TextStyle(color: Colors.grey),
            ),

            // --- COMBO INDICATOR (FIRE) ---
            if (ScoreManager().currentCombo >= 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    Text(
                      " Streak: ${ScoreManager().currentCombo}",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // --- FLASHCARD ---
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "QUESTION",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      currentItem.isQuestionLatex
                          ? Math.tex(
                              currentItem.question,
                              textStyle: const TextStyle(fontSize: 24),
                            )
                          : Text(
                              currentItem.question,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                      const Divider(height: 40),

                      if (_showAnswer) ...[
                        const Text(
                          "ANSWER",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Math.tex(
                          currentItem.answer,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          "?",
                          style: TextStyle(fontSize: 50, color: Colors.black12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- BUTTONS ---
            if (!_showAnswer) ...[
              // State 1: Question Visible
              if (widget.isPracticeMode && currentItem.hintRuleId != null)
                TextButton.icon(
                  onPressed: () => _showHint(currentItem.hintRuleId!),
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                  ),
                  label: const Text(
                    "Need a Hint? (-50% XP)",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),

              ElevatedButton(
                onPressed: () => setState(() => _showAnswer = true),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Show Answer",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ] else ...[
              // State 2: Answer Revealed (Self Evaluation)
              const Text(
                "Did you get it right?",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAnswer(false), // WRONG
                      icon: const Icon(Icons.close),
                      label: const Text("Missed it"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAnswer(true), // CORRECT
                      icon: const Icon(Icons.check),
                      label: const Text("I knew it!"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
