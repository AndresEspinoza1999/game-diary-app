import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          bottom: const TabBar(
            indicatorColor: Colors.deepPurpleAccent,
            tabs: [
              Tab(text: "Games"),
              Tab(text: "Reviews"),
              Tab(text: "Friends"),
              Tab(text: "Lists"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GamesTab(),
            ReviewsTab(),
            FriendsTab(),
            ListsTab(),
          ],
        ),
      ),
    );
  }
}

class GamesTab extends StatelessWidget {
  const GamesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mockGames = [
      "Elden Ring",
      "Stardew Valley",
      "Hollow Knight",
      "Cyberpunk 2077",
      "Hades",
      "God of War"
    ];

    return CustomScrollView(
      slivers: [
        _buildGameSection("Handpicked for you", mockGames),
        _buildGameSection("Popular this week", mockGames),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Lists", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View all >", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildListCard("Top RPGs"),
                const SizedBox(width: 12),
                _buildListCard("Best Co-op Games"),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  SliverToBoxAdapter _buildGameSection(String title, List<String> games) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 240,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: games.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                return GameCard(
                  title: games[index],
                  platform: "PC",
                  status: "Completed",
                  username: "andreswee",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(String title) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.deepPurple[400],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String platform;
  final String status;
  final String username;

  const GameCard({
    Key? key,
    required this.title,
    required this.platform,
    required this.status,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(
              child: Icon(Icons.videogame_asset, size: 40, color: Colors.white),
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
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.person, size: 12, color: Colors.white),
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

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("User reviews will appear here"));
  }
}

class FriendsTab extends StatelessWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Friend activity and logs"));
  }
}

class ListsTab extends StatelessWidget {
  const ListsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Curated game lists go here"));
  }
}
