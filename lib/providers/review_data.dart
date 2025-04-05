import 'package:flutter/material.dart';
import '../models/GameReview.dart';

class ReviewData extends ChangeNotifier {
  final List<GameReview> _reviews = [];

  List<GameReview> get reviews => List.unmodifiable(_reviews);

  void addReview(GameReview review) {
    _reviews.insert(0, review); // insert at the top of the list
    notifyListeners();
  }

  List<GameReview> getReviewsForGame(String gameId) {
    return _reviews.where((review) => review.gameId == gameId).toList();
  }
}
