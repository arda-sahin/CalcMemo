import 'dart:math';
import 'question_generator.dart';
import '../../screens/quiz_screen.dart';

// Helper class for function terms
class SimpleFunc {
  final String u;      // Function f(x)
  final String du;     // Derivative f'(x)
  final bool needsParens; // Does it need parentheses?

  SimpleFunc(this.u, this.du, {this.needsParens = false});
}

class QuotientRuleGenerator implements QuestionGenerator {
  final Random _random = Random();

  @override
  String get ruleId => 'quotient_rule'; // Quotient Rule ID

  @override
  QuizItem generate() {
    // We need numerator (u) and denominator (v)
    
    // 1. Pick u (Numerator)
    SimpleFunc num = _generateRandomTerm();
    
    // 2. Pick v (Denominator)
    SimpleFunc den = _generateRandomTerm();

    // Ensure they are not the same type to keep it interesting
    int attempts = 0;
    while (num.u == den.u && attempts < 5) {
      den = _generateRandomTerm();
      attempts++;
    }

    // 3. Build Question: d/dx (u / v)
    String questionTex = "\\frac{d}{dx}\\left(\\frac{${num.u}}{${den.u}}\\right)";

    // 4. Build Answer: (u'v - uv') / v^2
    // We use parenthesis carefully to ensure mathematical correctness
    
    String u_prime = num.needsParens ? "(${num.du})" : num.du;
    String v_plain = den.needsParens ? "(${den.u})" : den.u;
    
    String u_plain = num.needsParens ? "(${num.u})" : num.u;
    String v_prime = den.needsParens ? "(${den.du})" : den.du;
    
    String v_squared = den.needsParens ? "(${den.u})^2" : "${den.u}^2";

    // Combine into fraction
    String answerTex = "\\frac{$u_prime $v_plain - $u_plain $v_prime}{$v_squared}";

    return QuizItem(
      id: questionTex,
      question: questionTex,
      answer: answerTex,
      isQuestionLatex: true,
      hintRuleId: ruleId,
    );
  }

  // Helper to generate random basic functions (Same logic as Product Rule)
  SimpleFunc _generateRandomTerm() {
    int type = _random.nextInt(5); // 0..4

    switch (type) {
      case 0: // Polynomial: x^n
        int n = _random.nextInt(5) + 2; // x^2 to x^6
        return SimpleFunc("x^$n", "$n x^{${n-1}}");
      
      case 1: // Sine: sin(x)
        return SimpleFunc("\\sin(x)", "\\cos(x)");
      
      case 2: // Cosine: cos(x)
        return SimpleFunc("\\cos(x)", "-\\sin(x)", needsParens: true);
      
      case 3: // Exponential: e^x
        return SimpleFunc("e^x", "e^x");
      
      case 4: // Logarithm: ln(x)
        return SimpleFunc("\\ln(x)", "\\frac{1}{x}");
        
      default:
        return SimpleFunc("x", "1");
    }
  }
}