import 'dart:convert';
import 'package:http/http.dart' as http;

class RawgApiService {
  static const String _apiKey = 'c347a0571f9d477fa488e1026df75748';
  static const String _baseUrl = 'https://api.rawg.io/api';

  Future<List<Map<String, dynamic>>> searchGames(String query) async {
    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&search=$query');

    final response = await http.get(url);
    if (response.statusCode != 200) throw Exception('Failed to load games');

    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    return results.map((game) {
      return {
        'title': game['name'],
       'platform': (game['platforms'] != null)
    ? (game['platforms'] as List)
        .map((p) => (p['platform'] as Map<String, dynamic>)['name'] as String)
        .join(' • ')
    : 'Unknown',

        'image': game['background_image'] ?? '',
      };
    }).toList();
  }
}
