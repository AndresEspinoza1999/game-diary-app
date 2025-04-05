class GameReview {
  final int gameId;
  final String gameName;
  final String? coverUrl;
  final int overallRating;
  final String quickReview;
  final String? worthFullPrice;
  final Map<String, double>? sectionScores;
  final Map<String, String>? sectionNotes;
  final List<String>? labels; // ✅ FIXED

  GameReview({
    required this.gameId,
    required this.gameName,
    required this.coverUrl,
    required this.overallRating,
    required this.quickReview,
    this.worthFullPrice,
    this.sectionScores,
    this.sectionNotes,
    this.labels, // ✅ FIXED
  });
}
