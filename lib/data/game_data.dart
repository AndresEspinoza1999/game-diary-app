import 'package:flutter/material.dart';
import '../models/game.dart';

class GameData extends ChangeNotifier {
  final List<Game> _games = [];

  // Public getter for read-only access
  List<Game> get games => List.unmodifiable(_games);

  // Add a new game entry
  void addGame(Game game) {
    _games.insert(0, game); // Add to top of the list
    notifyListeners(); // Notify all listeners to rebuild
  }

  // Optional: Clear all games (for future reset)
  void clearGames() {
    _games.clear();
    notifyListeners();
  }
}
