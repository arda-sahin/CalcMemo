// Path: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import '../models/math_models.dart';
import '../core/score_manager.dart'; // Import Manager
import 'topic_selection_screen.dart';
import 'rules_list_screen.dart';
import 'practice_type_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Quizden dönünce puanları güncellemek için ekranı yenile
  void _refreshScore() {
    setState(() {
      // ScoreManager singleton olduğu için veriler zaten güncel,
      // sadece UI'ı (build metodunu) tetikliyoruz.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'CalcMemo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- SCORE DASHBOARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Total XP",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "${ScoreManager().totalScore}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ), // Ayırıcı çizgi
                  Column(
                    children: [
                      const Text(
                        "Daily Streak",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 20,
                          ),
                          Text(
                            "${ScoreManager().currentCombo}", // Şimdilik Combo'yu gösteriyoruz
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Master Calculus',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // --- MENUS ---
            Expanded(
              child: ListView(
                children: [
                  MenuCard(
                    title: 'Browse Rules',
                    icon: Icons.menu_book_rounded,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicSelectionScreen(
                            title: 'Select Topic for Rules',
                            onTopicSelected: (ctx, selectedTopic) {
                              Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      RulesListScreen(topic: selectedTopic),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  MenuCard(
                    title: 'Practice Mode',
                    icon: Icons.quiz_rounded,
                    color: Colors.deepPurpleAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicSelectionScreen(
                            title: 'Select Topic to Practice',
                            onTopicSelected: (ctx, selectedTopic) {
                              Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      PracticeTypeScreen(topic: selectedTopic),
                                ),
                              ).then(
                                (_) => _refreshScore(),
                              ); // Dönünce Puanı Güncelle!
                            },
                          ),
                        ),
                      ).then(
                        (_) => _refreshScore(),
                      ); // Topic Selection'dan geri gelirse de güncelle
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
