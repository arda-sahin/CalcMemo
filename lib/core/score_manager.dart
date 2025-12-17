// Path: lib/core/score_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  // --- SINGLETON PATTERN ---
  // Uygulamanın her yerinden aynı veriye ulaşmak için tek bir kopya oluşturuyoruz.
  static final ScoreManager _instance = ScoreManager._internal();
  factory ScoreManager() => _instance;
  ScoreManager._internal();

  // --- VARIABLES ---
  SharedPreferences? _prefs;
  
  int _totalScore = 0;
  int _currentCombo = 0; // Arka arkaya kaç doğru bilindi? (Streak)

  // --- GETTERS ---
  int get totalScore => _totalScore;
  int get currentCombo => _currentCombo;

  // --- INITIALIZATION ---
  // Uygulama açılınca bu fonksiyonu çağırıp eski puanları yükleyeceğiz.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _totalScore = _prefs?.getInt('total_score') ?? 0;
    // Combo'yu kaydetmiyoruz, her açılışta sıfırlanır (Oyun mantığı)
  }

  // --- GAME LOGIC ---
  
  // Cevap verildiğinde çağrılacak fonksiyon
  // returns: O sorudan kazanılan (veya kaybedilen) puan
  int updateScore({required bool isCorrect, required bool usedHint}) {
    int pointsChanged = 0;

    if (isCorrect) {
      _currentCombo++; // Seriyi artır

      // 1. Base Points
      int basePoints = 10;
      
      // 2. Hint Penalty (Eğer ipucu kullanıldıysa yarısı)
      if (usedHint) {
        basePoints = 5; 
      }

      // 3. Combo Multiplier Logic
      double multiplier = 1.0;
      if (_currentCombo >= 3 && _currentCombo < 5) {
        multiplier = 1.5; // 3-5 arası x1.5
      } else if (_currentCombo >= 5) {
        multiplier = 2.0; // 5 ve üzeri x2
      }

      // Calculate final points
      pointsChanged = (basePoints * multiplier).round();
      _totalScore += pointsChanged;

    } else {
      // Yanlış cevap
      _currentCombo = 0; // Seriyi sıfırla!
      pointsChanged = -5; // Ceza
      
      _totalScore += pointsChanged; 
      // Not: Puan eksiye düşebilir, kontrol koymadık.
    }

    // Değişikliği hafızaya kaydet
    _saveToDisk();
    
    return pointsChanged;
  }

  void _saveToDisk() {
    _prefs?.setInt('total_score', _totalScore);
  }
  
  // Puanı sıfırlamak istersen (Test amaçlı)
  Future<void> resetScore() async {
    _totalScore = 0;
    _currentCombo = 0;
    await _prefs?.remove('total_score');
  }
}