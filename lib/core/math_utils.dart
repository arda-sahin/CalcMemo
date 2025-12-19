class MathUtils {
  
  /// Formats a term (ax^n) into a clean LaTeX string.
  /// Examples:
  /// (1, 1) -> "x"
  /// (-1, 2) -> "-x^2"
  /// (3, 0) -> "3"
  /// (0, 5) -> "" (Returns empty string)
  static String formatTerm(int coeff, int exponent, {bool isFirstTerm = true}) {
    if (coeff == 0) return ""; 

    String sCoeff = "";
    String sVar = "";
    String sign = "";

    // 1. Sign Check
    if (coeff < 0) {
      sign = "-";
    } else if (!isFirstTerm) {
      sign = "+"; 
    }
    // (Note: No sign if positive and isFirstTerm)

    // 2. Coefficient Check (Absolute value)
    int absCoeff = coeff.abs();
    // If coeff is 1 and there is a variable, we don't write "1"
    if (absCoeff != 1 || exponent == 0) {
      sCoeff = absCoeff.toString();
    }

    // 3. Exponent Check
    if (exponent == 0) {
      sVar = ""; // x^0 = 1, so no variable
    } else if (exponent == 1) {
      sVar = "x";
    } else {
      sVar = "x^{$exponent}";
    }

    return "$sign$sCoeff$sVar";
  }
}