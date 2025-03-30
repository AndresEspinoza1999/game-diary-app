import 'package:flutter/material.dart';
import '../services/rawg_api.dart';

class SearchGamesTestScreen extends StatefulWidget {
  const SearchGamesTestScreen({Key? key}) : super(key: key);

  @override
  State<SearchGamesTestScreen> createState() => _SearchGamesTestScreenState();
}

class _SearchGamesTestScreenState extends State<SearchGamesTestScreen> {
  final RawgApiService _api = RawgApiService();
  List<Map<String, dynamic>> _games = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() async {
    final games = await _api.searchGames("zelda");
    setState(() {
      _games = games;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Game Covers")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _games.length,
              itemBuilder: (context, index) {
                final game = _games[index];
                return GameCard(
                  title: game['title'],
                  platform: game['platform'],
                  status: 'Discovered',
                  imageUrl: game['image'],
                  username: 'rawg',
                );
              },
            ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String platform;
  final String status;
  final String username;
  final String imageUrl;

  const GameCard({
    Key? key,
    required this.title,
    required this.platform,
    required this.status,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image from API
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(platform, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 12, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "by $username",
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
