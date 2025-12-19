import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/math_models.dart';
import '../core/data_manager.dart'; 
import '../core/score_manager.dart'; 
import '../core/settings_manager.dart'; 
import '../core/favorites_manager.dart'; 
import 'package:flutter/services.dart'; 
import 'scratchpad_screen.dart'; 

// Enum to define where the questions come from
enum QuizSource {
  topic,      // Normal mode (Derivative/Integral)
  favorites,  // From favorites list
  mistakes    // From mistakes list (Future feature)
}

class QuizItem {
  final String id;
  final String question;
  final String answer;
  final bool isQuestionLatex;
  final String? hintRuleId;

  QuizItem({
    required this.id,
    required this.question,
    required this.answer,
    this.isQuestionLatex = true,
    this.hintRuleId,
  });
}

class QuizScreen extends StatefulWidget {
  final QuizSource source;      // NEW: Source of the quiz
  final Topic? topic;           // Nullable (only needed if source is topic)
  final bool isPracticeMode;    // Needed if source is topic

  const QuizScreen({
    super.key,
    required this.source,       // Required
    this.topic,                 // Optional
    this.isPracticeMode = true, // Default
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizItem> _items = [];
  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _usedHint = false; 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Decide based on source
    switch (widget.source) {
      case QuizSource.topic:
        if (widget.topic != null) {
          _items = DataManager().getWeightedQuizItems(widget.topic!, widget.isPracticeMode);
        }
        break;
        
      case QuizSource.favorites:
        _items = DataManager().getFavoriteQuizItems();
        break;
        
      case QuizSource.mistakes:
        // Future implementation
        _items = [];
        break;
    }
    
    if (_items.isEmpty) {
        print("Warning: No items found for this quiz.");
    }
  }

  void _nextCard() {
    setState(() {
      if (_currentIndex < _items.length - 1) {
        _currentIndex++;
        _showAnswer = false;
        _usedHint = false; 
      } else {
        Navigator.pop(context); 
      }
    });
  }

  void _handleAnswer(bool isCorrect) {
    // Note: If reviewing favorites, we might want to give less XP or no XP.
    // For now, let's keep it same but maybe we can change logic later.
    final points = ScoreManager().updateScore(
      isCorrect: isCorrect, 
      usedHint: _usedHint
    );

    if (SettingsManager().vibrationNotifier.value) {
      if (isCorrect) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.heavyImpact();
      }
    }

    String message = isCorrect ? "Correct!" : "Wrong!";
    Color color = isCorrect ? Colors.green : Colors.red;
    
    if (isCorrect && ScoreManager().currentCombo > 2) {
      message += " (Combo x${ScoreManager().currentCombo > 4 ? '2.0' : '1.5'}!)";
    }
    
    message += " ${points >= 0 ? '+' : ''}$points XP";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(milliseconds: 800),
      ),
    );

    _nextCard();
  }

  void _showHint(String ruleId) {
    if (!_showAnswer) {
      setState(() {
        _usedHint = true; 
      });
    }

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
              _showAnswer ? "Related Rule: ${rule.name}" : "Hint: ${rule.name}", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
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
    // EMPTY STATE HANDLING
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Review")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.folder_open, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                widget.source == QuizSource.favorites 
                  ? "No favorites added yet!" 
                  : "No items found.",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              )
            ],
          ),
        ),
      );
    }

    final currentItem = _items[_currentIndex];
    
    // Dynamic Title
    String title = "Quiz";
    if (widget.source == QuizSource.favorites) title = "Review Favorites";
    else if (widget.isPracticeMode) title = "Practice Problems";
    else title = "Memorize Rules";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Center(child: Text("XP: ${ScoreManager().totalScore}", style: const TextStyle(fontWeight: FontWeight.bold))),
            )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => ScratchpadScreen(
                questionTex: currentItem.question,
              ),
            ),
          );
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Question ${_currentIndex + 1} / ${_items.length}", style: const TextStyle(color: Colors.grey)),
            
            if (ScoreManager().currentCombo >= 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange),
                    Text(
                      " Streak: ${ScoreManager().currentCombo}",
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // --- FLASHCARD ---
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(child: Text("QUESTION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                          const SizedBox(height: 20),
                          Center(
                            child: currentItem.isQuestionLatex
                                ? Math.tex(currentItem.question, textStyle: const TextStyle(fontSize: 24))
                                : Text(currentItem.question, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ),
                          
                          const Divider(height: 40),

                          if (_showAnswer) ...[
                            const Center(child: Text("ANSWER", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green))),
                            const SizedBox(height: 20),
                            Center(
                              child: Math.tex(currentItem.answer, textStyle: const TextStyle(fontSize: 24, color: Colors.green)),
                            ),
                          ] else ...[
                            const Center(child: Text("?", style: TextStyle(fontSize: 50, color: Colors.black12))),
                          ]
                        ],
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: ValueListenableBuilder<List<String>>(
                        valueListenable: FavoritesManager().favoritesNotifier,
                        builder: (context, favorites, child) {
                          final isFav = favorites.contains(currentItem.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.grey[400],
                              size: 30,
                            ),
                            onPressed: () {
                              FavoritesManager().toggleFavorite(currentItem.id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- BUTTONS ---
            if (!_showAnswer) ...[
              if (widget.source != QuizSource.favorites && widget.isPracticeMode && currentItem.hintRuleId != null)
                 TextButton.icon(
                    onPressed: () => _showHint(currentItem.hintRuleId!),
                    icon: const Icon(Icons.lightbulb_outline, color: Colors.orange),
                    label: const Text("Need a Hint? (-50% XP)", style: TextStyle(color: Colors.orange)),
                  ),
              
              ElevatedButton(
                onPressed: () => setState(() => _showAnswer = true),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Show Answer", style: TextStyle(fontSize: 18)),
              ),
            ] else ...[
              if (currentItem.hintRuleId != null)
                 TextButton.icon(
                    onPressed: () => _showHint(currentItem.hintRuleId!),
                    icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
                    label: const Text("Show Rule Formula", style: TextStyle(color: Colors.blueGrey)),
                  ),

              const SizedBox(height: 10),
              
              const Text("Did you get it right?", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAnswer(false), 
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
                      onPressed: () => _handleAnswer(true), 
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
              )
            ],
          ],
        ),
      ),
    );
  }
}