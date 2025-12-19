import 'dart:math';
import 'question_generator.dart';
import '../../screens/quiz_screen.dart';

// Helper class to hold a function and its derivative
class SimpleFunc {
  final String u; // The function f(x)
  final String du; // The derivative f'(x)
  final bool needsParens; // Does it need parentheses in multiplication?

  SimpleFunc(this.u, this.du, {this.needsParens = false});
}

class ProductRuleGenerator implements QuestionGenerator {
  final Random _random = Random();

  @override
  String get ruleId => 'product_rule'; // Product Rule ID

  @override
  QuizItem generate() {
    // We need two distinct functions: u and v
    // Let's create a pool of possible function types

    // 1. Pick u (First function)
    SimpleFunc term1 = _generateRandomTerm();

    // 2. Pick v (Second function)
    SimpleFunc term2 = _generateRandomTerm();

    // Avoid picking the exact same type if possible to make it interesting
    // (e.g. x^2 * x^3 is boring, x^2 * sin(x) is better)
    int attempts = 0;
    while (term1.u == term2.u && attempts < 5) {
      term2 = _generateRandomTerm();
      attempts++;
    }

    // 3. Build Question: d/dx (u * v)
    String questionTex =
        "\\frac{d}{dx}\\left(${term1.u} \\cdot ${term2.u}\\right)";

    // 4. Build Answer: u'v + uv'
    // Format: (u') * (v) + (u) * (v')

    String u_prime = term1.needsParens ? "(${term1.du})" : term1.du;
    String v_plain = term2.needsParens ? "(${term2.u})" : term2.u;

    String u_plain = term1.needsParens ? "(${term1.u})" : term1.u;
    String v_prime = term2.needsParens ? "(${term2.du})" : term2.du;

    String answerTex = "$u_prime $v_plain + $u_plain $v_prime";

    return QuizItem(
      id: questionTex,
      question: questionTex,
      answer: answerTex,
      isQuestionLatex: true,
      hintRuleId: ruleId,
    );
  }

  // Helper to generate random basic functions
  SimpleFunc _generateRandomTerm() {
    int type = _random.nextInt(5); // 0..4

    switch (type) {
      case 0: // Polynomial: x^n
        int n = _random.nextInt(5) + 2; // x^2 to x^6
        return SimpleFunc("x^$n", "$n x^{${n - 1}}");

      case 1: // Sine: sin(x)
        return SimpleFunc("\\sin(x)", "\\cos(x)");

      case 2: // Cosine: cos(x)
        return SimpleFunc(
          "\\cos(x)",
          "-\\sin(x)",
          needsParens: true,
        ); // -sin(x) needs parens

      case 3: // Exponential: e^x
        return SimpleFunc("e^x", "e^x");

      case 4: // Logarithm: ln(x)
        return SimpleFunc("\\ln(x)", "\\frac{1}{x}");

      default:
        return SimpleFunc("x", "1");
    }
  }
}
