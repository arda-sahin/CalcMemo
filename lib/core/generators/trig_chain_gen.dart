import 'dart:math';
import 'question_generator.dart';
import '../../screens/quiz_screen.dart';
import '../math_utils.dart'; // clean number formatting

class TrigChainGenerator implements QuestionGenerator {
  final Random _random = Random();

  @override
  String get ruleId => 'chain_rule'; // Bağlı olduğu ana kural

  @override
  QuizItem generate() {
    // AMAÇ: d/dx [ a * func(bx) ] sorusu üretmek.

    // 1. Fonksiyonu Seç (0: sin, 1: cos, 2: tan)
    int funcType = _random.nextInt(3);

    // 2. Katsayıları Belirle (a ve b)
    // a: Dış katsayı (-5 ile 5 arası, 0 hariç)
    int a = 0;
    while (a == 0) {
      a = _random.nextInt(11) - 5;
    }

    // b: İç katsayı (2 ile 5 arası - Zincir kuralı olması için 1 olmamalı)
    int b = _random.nextInt(4) + 2;

    // 3. Soruyu İnşa Et
    // Örn: d/dx (3sin(2x))
    String funcName = "";
    String derivName = "";
    String sign = ""; // Türevden gelen işaret (örn: cos -> -sin)

    switch (funcType) {
      case 0: // sin -> cos
        funcName = "\\sin";
        derivName = "\\cos";
        sign = ""; // Pozitif
        break;
      case 1: // cos -> -sin
        funcName = "\\cos";
        derivName = "\\sin";
        sign = "-"; // Negatif
        break;
      case 2: // tan -> sec^2
        funcName = "\\tan";
        derivName = "\\sec^2";
        sign = ""; // Pozitif
        break;
    }

    // Sorunun yazımı: a * func(bx)
    // a=1 ise yazma, -1 ise sadece - koy (MathUtils bu mantığı tam karşılamayabilir, basit manuel kontrol yapalım)
    String strA = a == 1 ? "" : (a == -1 ? "-" : "$a");

    String questionTex = "\\frac{d}{dx}($strA $funcName($b x))";

    // 4. Cevabı Hesapla
    // Kural: d/dx [a*sin(bx)] = a * b * cos(bx)
    int newCoeff = a * b;

    // Eğer cos türeviyse (-sin), işareti katsayıya yedir
    if (funcType == 1) {
      // cos
      newCoeff = -newCoeff;
    }

    String answerTex = "${newCoeff}$derivName($b x)";

    return QuizItem(
      id: questionTex,
      question: questionTex,
      answer: answerTex,
      isQuestionLatex: true,
      hintRuleId: ruleId,
    );
  }
}
