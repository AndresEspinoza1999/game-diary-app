import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class IGDBApi {
  static const String _baseUrl = 'https://api.igdb.com/v4';
  static const String _clientId = '2m7orimg8di9a54dbgc8koeczlz9w1';
  static const String _authToken = 'Bearer l6eaboaz7zg9j1pjney33hei86mkja'; // Replace with valid token

  Map<String, String> get _headers => {
        'Client-ID': _clientId,
        'Authorization': _authToken,
      };

  Future<List<Map<String, dynamic>>> getAllGameVariants(String query, {bool officialOnly = true}) async {
    final url = Uri.parse('$_baseUrl/games');

    final filter = officialOnly ? 'where category = (0, 8, 9);' : '';

    final response = await http.post(
      url,
      headers: _headers,
      body: '''
        search "$query";
        fields id, name, version_title, summary, platforms.name, first_release_date, cover, category;
        $filter
        limit 10;
      ''',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      debugPrint('❌ Failed to fetch game variants: ${response.statusCode}');
      return [];
    }
  }

  Future<String?> getCoverById(dynamic coverId) async {
    if (coverId == null) return null;

    final url = Uri.parse('$_baseUrl/covers');
    final response = await http.post(
      url,
      headers: _headers,
      body: '''
        fields image_id;
        where id = $coverId;
      ''',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data.first['image_id'] != null) {
        final imageId = data.first['image_id'];
        return 'https://images.igdb.com/igdb/image/upload/t_cover_big/$imageId.jpg';
      }
    }
    return null;
  }
}
