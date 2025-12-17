// Path: lib/models/math_models.dart

// Defining topics as an Enum
enum Topic { derivative, integral }

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

class MathRule {
  final String id;
  final String name;
  final String texFormula;
  final Topic topic;
  final int importance; // YENİ ALAN: 1 (Low), 2 (Medium), 3 (High)

  MathRule({
    required this.id,
    required this.name,
    required this.texFormula,
    required this.topic,
    this.importance = 2, // Varsayılan değer 2 olsun
  });

  // JSON'dan nesne oluşturmak için fabrika metodu (Factory Constructor)
  factory MathRule.fromJson(Map<String, dynamic> json) {
    return MathRule(
      id: json['id'],
      name: json['name'],
      texFormula: json['texFormula'],
      // Topic string'ini Enum'a çeviriyoruz:
      topic: json['topic'] == 'derivative' ? Topic.derivative : Topic.integral,
      importance: json['importance'] ?? 2,
    );
  }
}

class PracticeQuestion {
  final String questionTex;
  final String answerTex;
  final String ruleId;
  final Topic topic;

  PracticeQuestion({
    required this.questionTex,
    required this.answerTex,
    required this.ruleId,
    required this.topic,
  });

  // JSON Factory
  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      questionTex: json['questionTex'],
      answerTex: json['answerTex'],
      ruleId: json['ruleId'],
      topic: json['topic'] == 'derivative' ? Topic.derivative : Topic.integral,
    );
  }
}
