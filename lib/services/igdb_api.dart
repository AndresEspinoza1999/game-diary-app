import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class IGDBApi {
  static const String _clientId = '2m7orimg8di9a54dbgc8koeczlz9w1';
  static const String _accessToken = 'l6eaboaz7zg9j1pjney33hei86mkja';
  static const String _baseUrl = 'https://api.igdb.com/v4';

  final Map<String, String> _headers = {
    'Client-ID': _clientId,
    'Authorization': 'Bearer $_accessToken',
    'Content-Type': 'text/plain',
  };

  /// Fetches the oldest game result by release date for the search query
  Future<Game?> fetchGame(String query) async {
    final url = Uri.parse('$_baseUrl/games');

    final response = await http.post(
      url,
      headers: _headers,
      body: '''
        search "$query";
        fields id, name, summary, platforms.name, first_release_date, cover;
        limit 10;
      ''',
    );

    if (response.statusCode == 200) {
      final List<dynamic> games = json.decode(response.body);
      if (games.isEmpty) return null;

      // Sort by oldest release date
      games.sort((a, b) => (a['first_release_date'] ?? 0).compareTo(b['first_release_date'] ?? 0));
      final game = games.first;

      // Get cover URL
      final coverId = game['cover'];
      final coverUrl = await getCoverById(coverId);

      return Game.fromJson(game, coverUrl: coverUrl);
    } else {
      print('❌ Failed to fetch games: ${response.statusCode}');
      return null;
    }
  }
Future<List<Map<String, dynamic>>> getAllGameVariants(String query) async {
  final url = Uri.parse('$_baseUrl/games');

  final response = await http.post(
    url,
    headers: _headers,
    body: '''
      search "$query";
      fields id, name, summary, platforms.name, first_release_date, cover;
      limit 5;
    ''',
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    print('❌ Failed to fetch game variants: ${response.statusCode}');
    return [];
  }
}

  /// Fetches cover image URL for a cover ID
  Future<String?> getCoverById(int? coverId) async {
    if (coverId == null) return null;

    final url = Uri.parse('$_baseUrl/covers');

    final response = await http.post(
      url,
      headers: _headers,
      body: '''
        where id = $coverId;
        fields image_id;
      ''',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data.first['image_id'] != null) {
        final imageId = data.first['image_id'];
        return 'https://images.igdb.com/igdb/image/upload/t_cover_big/$imageId.jpg';
      }
    }

    print('❌ Failed to fetch cover: ${response.statusCode}');
    return null;
  }
}
