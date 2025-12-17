// Path: lib/models/math_models.dart

// Defining topics as an Enum
enum Topic {
  derivative,
  integral,
}

// Extension to get a clean display string for the UI
extension TopicExtension on Topic {
  String get displayName {
    switch (this) {
      case Topic.derivative:
        return 'Derivative';
      case Topic.integral:
        return 'Integral';
    }
  }
}

// Model for a Mathematical Rule
class MathRule {
  final String id;
  final String name;       // e.g., "Chain Rule"
  final String texFormula; // LaTeX format string
  final Topic topic;

  MathRule({
    required this.id,
    required this.name,
    required this.texFormula,
    required this.topic,
  });
}

// Model for a Practice Question (Flashcard style)
class PracticeQuestion {
  final String questionTex;
  final String answerTex;
  final String ruleId; // Links back to a MathRule for hints
  final Topic topic;

  PracticeQuestion({
    required this.questionTex,
    required this.answerTex,
    required this.ruleId,
    required this.topic,
  });
}