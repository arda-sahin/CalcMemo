import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  // Singleton Pattern
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  // Notifier to listen for changes in the favorites list
  final ValueNotifier<List<String>> favoritesNotifier = ValueNotifier([]);

  // Initialize and load favorites from storage
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    favoritesNotifier.value = prefs.getStringList('favorites') ?? [];
  }

  // Check if an item is favorited
  bool isFavorite(String id) {
    return favoritesNotifier.value.contains(id);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    // Create a new list to ensure the notifier updates listeners
    final List<String> currentFavs = List.from(favoritesNotifier.value);

    if (currentFavs.contains(id)) {
      currentFavs.remove(id);
    } else {
      currentFavs.add(id);
    }

    favoritesNotifier.value = currentFavs;
    await prefs.setStringList('favorites', currentFavs);
  }
}
