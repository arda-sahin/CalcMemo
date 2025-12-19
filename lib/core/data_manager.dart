import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/math_models.dart';
import '../screens/quiz_screen.dart';
import 'generators/question_generator.dart';
import 'generators/power_rule_gen.dart';
import 'generators/integral_power_gen.dart';
import 'generators/trig_chain_gen.dart';
import 'generators/product_rule_gen.dart';
import 'generators/quotient_rule_gen.dart';

class DataManager {
  // Singleton
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  List<MathRule> _rules = [];
  List<PracticeQuestion> _questions = [];

  // --- GENERATORS REGISTRY ---
  // Hangi kural ID'sinin hangi fabrikası var, burada listeliyoruz.
  final Map<String, QuestionGenerator> _generators = {
    'power_rule_diff': PowerRuleGenerator(),
    'power_rule_int': IntegralPowerGenerator(),
    'chain_rule': TrigChainGenerator(),
    'product_rule': ProductRuleGenerator(),
    'quotient_rule': QuotientRuleGenerator(),
  };

  List<MathRule> get rules => _rules;

  Future<void> loadData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/calculus_data.json',
      );
      final data = await json.decode(response);

      _rules = (data['rules'] as List)
          .map((json) => MathRule.fromJson(json))
          .toList();

      _questions = (data['questions'] as List)
          .map((json) => PracticeQuestion.fromJson(json))
          .toList();

      print(
        "Data Loaded: ${_rules.length} rules, ${_questions.length} questions.",
      );
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  List<QuizItem> getWeightedQuizItems(Topic topic, bool isPracticeMode) {
    List<QuizItem> pool = [];

    if (isPracticeMode) {
      // 1. STATİK SORULARI EKLE (JSON'dan gelenler)
      // (Mevcut soru havuzunu koruyoruz)
      final topicQuestions = _questions.where((q) => q.topic == topic).toList();

      for (var question in topicQuestions) {
        final rule = _rules.firstWhere(
          (r) => r.id == question.ruleId,
          orElse: () => MathRule(
            id: '',
            name: '',
            texFormula: '',
            topic: topic,
            importance: 1,
          ),
        );

        for (int i = 0; i < rule.importance; i++) {
          pool.add(
            QuizItem(
              id: question.questionTex,
              question: question.questionTex,
              answer: question.answerTex,
              isQuestionLatex: true,
              hintRuleId: question.ruleId,
            ),
          );
        }
      }

      // 2. DİNAMİK SORULARI EKLE (Jeneratörlerden gelenler)
      // Konuya ait tüm kuralları gez
      final topicRules = _rules.where((r) => r.topic == topic).toList();

      for (var rule in topicRules) {
        // Bu kuralın bir jeneratörü var mı?
        if (_generators.containsKey(rule.id)) {
          final generator = _generators[rule.id]!;

          // Kuralın önem derecesine göre X adet rastgele soru üret
          // Önem 3 ise 5 tane, Önem 1 ise 2 tane gibi.
          int generateCount = rule.importance * 2;

          for (int i = 0; i < generateCount; i++) {
            // Fabrikayı çalıştır!
            pool.add(generator.generate());
          }
        }
      }
    } else {
      // Rule Memorization Mode (Değişmedi)
      final topicRules = _rules.where((r) => r.topic == topic).toList();

      for (var rule in topicRules) {
        for (int i = 0; i < rule.importance; i++) {
          pool.add(
            QuizItem(
              id: rule.id,
              question: rule.name,
              answer: rule.texFormula,
              isQuestionLatex: false,
              hintRuleId: null,
            ),
          );
        }
      }
    }

    pool.shuffle();
    return pool;
  }

  MathRule? getRuleById(String id) {
    try {
      return _rules.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
