import 'package:flutter/material.dart';
import '../screens/games_tab_with_feed.dart'; // ✅ correct if it's in lib/screens/
import '../widgets/game_feed_card.dart';


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
            tabs: [
              Tab(text: "Games"),
              Tab(text: "Reviews"),
              Tab(text: "Lists"),
              Tab(text: "Journal"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GamesTab(), // 👈 this uses the new feed layout
            Center(child: Text("Reviews tab placeholder")),
            Center(child: Text("Friends tab placeholder")),
            Center(child: Text("Lists tab placeholder")),
          ],
        ),
      ),
    );
  }
}
