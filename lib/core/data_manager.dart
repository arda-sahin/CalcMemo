import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/math_models.dart';
import '../screens/quiz_screen.dart'; // Imports QuizItem class

class DataManager {
  // Singleton
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  List<MathRule> _rules = [];
  List<PracticeQuestion> _questions = [];

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
      // Numerical Questions
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
              id: question.questionTex, // Use question text as Unique ID
              question: question.questionTex,
              answer: question.answerTex,
              isQuestionLatex: true,
              hintRuleId: question.ruleId,
            ),
          );
        }
      }
    } else {
      // Rule Memorization
      final topicRules = _rules.where((r) => r.topic == topic).toList();

      for (var rule in topicRules) {
        for (int i = 0; i < rule.importance; i++) {
          pool.add(
            QuizItem(
              id: rule.id, // Use rule ID as Unique ID
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
