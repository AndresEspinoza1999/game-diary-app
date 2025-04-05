import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';
import '../services/igdb_api.dart';
import 'review_form_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _controller = TextEditingController();
  final IGDBApi _igdbApi = IGDBApi();
  Timer? _debounce;

  List<Game> _results = [];
  bool _loading = false;
  bool _officialOnly = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _controller.text.trim();
      if (query.isNotEmpty) {
        _searchGames(query);
      } else {
        setState(() => _results = []);
      }
    });
  }

  void _searchGames(String query) async {
    setState(() {
      _loading = true;
      _results = [];
    });

    final rawGames = await _igdbApi.getAllGameVariants(
      query,
      officialOnly: _officialOnly,
    );

    final games = await Future.wait(
      rawGames.map((g) async {
        final coverUrl = await _igdbApi.getCoverById(g['cover']);
        final title = g['version_title'] ?? g['name'] ?? 'Unknown';
        return Game(
          id: g['id'],
          name: title,
          summary: g['summary'] ?? '',
          coverUrl: coverUrl,
          platforms:
              (g['platforms'] as List<dynamic>?)
                  ?.map((p) => p['name'].toString())
                  .toList() ??
              [],
        );
      }),
    );

    setState(() {
      _results = games;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search games.",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Checkbox(
                  value: _officialOnly,
                  onChanged: (val) {
                    setState(() => _officialOnly = val ?? true);
                    _searchGames(_controller.text.trim());
                  },
                ),
                const Text("Show only official titles"),
              ],
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child:
                _results.isEmpty
                    ? const Center(
                      child: Text("Search for a game to get started"),
                    )
                    : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final game = _results[index];
                        return GameListCard(game: game);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class GameListCard extends StatelessWidget {
  final Game game;

  const GameListCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReviewFormScreen(game: game)),
        );
      },
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    game.coverUrl != null
                        ? CachedNetworkImage(
                          imageUrl: game.coverUrl!,
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => const SizedBox(
                                width: 80,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => const SizedBox(
                                width: 80,
                                height: 100,
                                child: Icon(Icons.error),
                              ),
                        )
                        : Container(
                          width: 80,
                          height: 100,
                          color: Colors.deepPurple,
                          child: const Icon(
                            Icons.videogame_asset,
                            color: Colors.white,
                          ),
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.platforms.join(', '),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
