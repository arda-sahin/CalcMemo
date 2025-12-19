import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import '../models/math_models.dart';
import '../core/score_manager.dart';
import 'topic_selection_screen.dart';
import 'rules_list_screen.dart';
import 'practice_type_screen.dart';
import 'settings_screen.dart';
import 'review_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _refreshScore() {
    setState(() {
      // Puanları güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mevcut temanın renklerini alıyoruz
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Arka plan rengini artık main.dart'taki temadan alacak (elle vermiyoruz)
      appBar: AppBar(
        title: const Text(
          'CalcMemo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
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
                // Kart rengini temadan alıyoruz
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    // Koyu modda gölge çok sırıtmaması için rengi ayarlıyoruz
                    color: isDark ? Colors.black38 : Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
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
                  // Araya dikey çizgi (Rengi temadan gelsin)
                  Container(width: 1, height: 40, color: theme.dividerColor),
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
                            "${ScoreManager().currentCombo}",
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
                              ).then((_) => _refreshScore());
                            },
                          ),
                        ),
                      ).then((_) => _refreshScore());
                    },
                  ),
                  MenuCard(
                    title: 'Review',
                    icon: Icons.refresh_rounded, // Tekrar ikonu
                    color: Colors.green, // Farklı bir renk
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewSelectionScreen(),
                        ),
                      ).then((_) => _refreshScore());
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
