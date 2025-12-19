import 'dart:math';
import 'question_generator.dart';
import '../../screens/quiz_screen.dart';
import '../math_utils.dart';

class PowerRuleGenerator implements QuestionGenerator {
  final Random _random = Random();

  @override
  String get ruleId => 'power_rule_diff'; // Rule ID for the Hint system

  @override
  QuizItem generate() {
    // 1. Randomize Parameters (with Constraints)
    // Coefficient: between -9 and 9 (excluding 0)
    int coeff = 0;
    while (coeff == 0) {
      coeff = _random.nextInt(19) - 9;
    }

    // Exponent: between 2 and 9
    // (1 is too simple, 0 is constant)
    int exponent = _random.nextInt(8) + 2;

    // 2. Build Question LaTeX
    // Ex: d/dx (3x^5)
    String term = MathUtils.formatTerm(coeff, exponent);
    String questionTex = "\\frac{d}{dx}($term)";

    // 3. Calculate Answer (Algorithm)
    // Rule: d/dx (ax^n) = (a*n)x^(n-1)
    int newCoeff = coeff * exponent;
    int newExponent = exponent - 1;

    String answerTex = MathUtils.formatTerm(newCoeff, newExponent);

    // 4. Create and Return QuizItem
    // We use the question itself as the unique ID since it's randomly generated
    return QuizItem(
      id: questionTex,
      question: questionTex,
      answer: answerTex,
      isQuestionLatex: true,
      hintRuleId: ruleId,
    );
  }
}
