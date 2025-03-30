class Game {
  final String name;
  final String summary;
  final String? coverUrl;
  final List<String> platforms;

  Game({
    required this.name,
    required this.summary,
    required this.coverUrl,
    required this.platforms,
  });

  factory Game.fromJson(Map<String, dynamic> json, {String? coverUrl}) {
    return Game(
      name: json['name'] ?? 'Unknown',
      summary: json['summary'] ?? '',
      coverUrl: coverUrl,
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((p) => p['name'].toString())
              .toList() ??
          [],
    );
  }
}
