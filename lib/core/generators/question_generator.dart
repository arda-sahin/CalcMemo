import '../../../screens/quiz_screen.dart';

/// Tüm soru üreticiler bu sınıfı miras alacak (Inheritance)
abstract class QuestionGenerator {
  /// Bu üreticinin hangi konuya ait olduğu (İpucu ID'si)
  String get ruleId;

  /// Yeni bir soru üretir
  QuizItem generate();
}