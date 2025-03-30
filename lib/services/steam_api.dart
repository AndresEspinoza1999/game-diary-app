import 'dart:convert';
import 'package:http/http.dart' as http;

class SteamApi {
  final String _baseUrl = 'https://store.steampowered.com/api/appdetails';

  Future<String?> getHeaderImage(String appId) async {
    final response = await http.get(Uri.parse('$_baseUrl?appids=$appId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final appData = data[appId]?['data'];
      if (appData != null && appData['header_image'] != null) {
        return appData['header_image'];
      }
    }

    return null; // fallback if not found
  }

  Future<Map<String, dynamic>?> getAppDetails(String appId) async {
    final response = await http.get(Uri.parse('$_baseUrl?appids=$appId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[appId]?['data'];
    }

    return null;
  }
}
