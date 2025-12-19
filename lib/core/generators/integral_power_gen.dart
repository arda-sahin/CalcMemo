import 'dart:math';
import 'question_generator.dart';
import '../../screens/quiz_screen.dart';
import '../math_utils.dart';

class IntegralPowerGenerator implements QuestionGenerator {
  final Random _random = Random();

  @override
  String get ruleId => 'power_rule_int'; // İntegral Power Rule ID'si

  @override
  QuizItem generate() {
    // AMAÇ: \int (coeff)x^n dx sorusu üretmek.
    // PÜF NOKTA: Sonucun kesirli çıkmaması için "Reverse Engineering" (Tersine Mühendislik) yapacağız.
    
    // 1. Önce CEVAPTAKİ üssü belirle (n+1)
    // 2 ile 10 arası bir üs seçelim.
    int targetExponent = _random.nextInt(9) + 2; 
    
    // 2. Cevaptaki katsayıyı belirle (Basit olsun diye -5 ile 5 arası)
    int targetCoeff = 0;
    while (targetCoeff == 0) {
      targetCoeff = _random.nextInt(11) - 5;
    }

    // 3. SORUYU buna göre inşa et
    // Kural: \int a*x^n dx = (a/(n+1)) * x^(n+1)
    // Bizim sorudaki katsayımız (coeff) = targetCoeff * targetExponent olmalı ki,
    // integral alınca paydaya gelen targetExponent ile sadeleşsin.
    
    int questionExponent = targetExponent - 1;
    int questionCoeff = targetCoeff * targetExponent;

    // Soruyu Formatla: \int (coeff)x^n dx
    String term = MathUtils.formatTerm(questionCoeff, questionExponent);
    String questionTex = "\\int $term dx";

    // Cevabı Formatla: (targetCoeff)x^(targetExponent) + C
    String answerTerm = MathUtils.formatTerm(targetCoeff, targetExponent);
    String answerTex = "$answerTerm + C";

    return QuizItem(
      id: questionTex, 
      question: questionTex,
      answer: answerTex,
      isQuestionLatex: true,
      hintRuleId: ruleId, 
    );
  }
}