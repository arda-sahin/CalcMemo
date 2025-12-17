// Path: lib/core/data_manager.dart

import 'dart:convert'; // JSON işlemleri için
import 'package:flutter/services.dart'; // Dosya okuma (rootBundle) için
import '../models/math_models.dart';
import '../screens/quiz_screen.dart'; // QuizItem sınıfı için

class DataManager {
  // --- SINGLETON ---
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  // --- VARIABLES ---
  List<MathRule> _rules = [];
  List<PracticeQuestion> _questions = [];

  // --- GETTERS ---
  List<MathRule> get rules => _rules;

  // --- INITIALIZATION ---
  Future<void> loadData() async {
    // 1. JSON dosyasını string olarak oku
    final String response = await rootBundle.loadString('assets/calculus_data.json');
    
    // 2. String'i Map'e çevir (Decode)
    final data = await json.decode(response);

    // 3. Kuralları Listeye Çevir
    _rules = (data['rules'] as List)
        .map((json) => MathRule.fromJson(json))
        .toList();

    // 4. Soruları Listeye Çevir
    _questions = (data['questions'] as List)
        .map((json) => PracticeQuestion.fromJson(json))
        .toList();
        
    print("Data Loaded: ${_rules.length} rules, ${_questions.length} questions.");
  }

  // --- ALGORITHM: WEIGHTED RANDOM SELECTION ---
  // Sık çıkan konuları daha çok sormak için "Ağırlıklı Havuz" mantığı
  List<QuizItem> getWeightedQuizItems(Topic topic, bool isPracticeMode) {
    List<QuizItem> pool = [];

    if (isPracticeMode) {
      // --- SAYISAL SORU MODU ---
      // Sadece seçili konudaki soruları al
      final topicQuestions = _questions.where((q) => q.topic == topic).toList();

      for (var question in topicQuestions) {
        // Sorunun bağlı olduğu kuralı bul
        final rule = _rules.firstWhere((r) => r.id == question.ruleId, 
            orElse: () => MathRule(id: '', name: '', texFormula: '', topic: topic, importance: 1));

        // Önem derecesine göre havuza ekle (Importance: 1, 2, 3)
        // Önemli kuralın sorusu havuza 3 kere atılır, böylece gelme şansı artar.
        for (int i = 0; i < rule.importance; i++) {
          pool.add(QuizItem(
            question: question.questionTex,
            answer: question.answerTex,
            isQuestionLatex: true,
            hintRuleId: question.ruleId,
          ));
        }
      }

    } else {
      // --- KURAL EZBERLEME MODU ---
      final topicRules = _rules.where((r) => r.topic == topic).toList();

      for (var rule in topicRules) {
        // Önemli kuralı havuza 3 kere at
        for (int i = 0; i < rule.importance; i++) {
          pool.add(QuizItem(
            question: rule.name,
            answer: rule.texFormula,
            isQuestionLatex: false,
            hintRuleId: null,
          ));
        }
      }
    }

    // Havuzu karıştır
    pool.shuffle();
    return pool;
  }
  
  // Rule ID'den kuralı bulmak için yardımcı fonksiyon (İpucu için)
  MathRule? getRuleById(String id) {
    try {
      return _rules.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}