// Path: lib/data/mock_data.dart

import '../models/math_models.dart';

class MathRepository {
  
  // --- RULES LIST ---
  static final List<MathRule> rules = [
    // DERIVATIVE RULES
    MathRule(
      id: 'power_rule_diff',
      name: 'Power Rule',
      texFormula: r"\frac{d}{dx}x^n = nx^{n-1}",
      topic: Topic.derivative,
    ),
    MathRule(
      id: 'chain_rule',
      name: 'Chain Rule',
      texFormula: r"\frac{d}{dx}f(g(x)) = f'(g(x))g'(x)",
      topic: Topic.derivative,
    ),
    MathRule(
      id: 'sin_rule',
      name: 'Derivative of Sine',
      texFormula: r"\frac{d}{dx}\sin(x) = \cos(x)",
      topic: Topic.derivative,
    ),
    MathRule(
      id: 'product_rule',
      name: 'Product Rule',
      texFormula: r"\frac{d}{dx}(uv) = u'v + uv'",
      topic: Topic.derivative,
    ),
    MathRule(
      id: 'quotient_rule',
      name: 'Quotient Rule',
      texFormula: r"\frac{d}{dx}\left(\frac{u}{v}\right) = \frac{u'v - uv'}{v^2}",
      topic: Topic.derivative,
    ),

    // INTEGRAL RULES
    MathRule(
      id: 'power_rule_int',
      name: 'Power Rule (Integration)',
      texFormula: r"\int x^n dx = \frac{x^{n+1}}{n+1} + C",
      topic: Topic.integral,
    ),
     MathRule(
      id: 'ln_rule',
      name: 'Integral of 1/x',
      texFormula: r"\int \frac{1}{x} dx = \ln|x| + C",
      topic: Topic.integral,
    ),
  ];

  // --- PRACTICE QUESTIONS ---
  static final List<PracticeQuestion> questions = [
    PracticeQuestion(
      questionTex: r"\frac{d}{dx}(x^3)",
      answerTex: r"3x^2",
      ruleId: 'power_rule_diff',
      topic: Topic.derivative,
    ),
    PracticeQuestion(
      questionTex: r"\frac{d}{dx}\sin(x^2)",
      answerTex: r"2x\cos(x^2)",
      ruleId: 'chain_rule',
      topic: Topic.derivative,
    ),
    PracticeQuestion(
      questionTex: r"\frac{d}{dx}(x^2 \sin(x))",
      answerTex: r"2x\sin(x) + x^2\cos(x)",
      ruleId: 'product_rule',
      topic: Topic.derivative,
    ),
    PracticeQuestion(
      questionTex: r"\int x^4 dx",
      answerTex: r"\frac{x^5}{5} + C",
      ruleId: 'power_rule_int',
      topic: Topic.integral,
    ),
  ];
}