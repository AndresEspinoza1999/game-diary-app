import 'package:flutter/material.dart';

class GameDiaryScreen extends StatelessWidget {
  const GameDiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> diaryEntries = [
      {
        'title': 'Elden Ring',
        'platform': 'PC',
        'status': 'Completed',
        'date': 'Mar 26, 2025',
        'moods': ['Hyped', 'Immersed'],
        'notes': 'Incredible boss design. Took me 80 hours to beat!'
      },
      {
        'title': 'Stardew Valley',
        'platform': 'Switch',
        'status': 'Playing',
        'date': 'Mar 22, 2025',
        'moods': ['Relaxed'],
        'notes': 'My chill game. Farming strawberries this spring.'
      },
      {
        'title': 'Cyberpunk 2077',
        'platform': 'PC',
        'status': 'Dropped',
        'date': 'Mar 18, 2025',
        'moods': ['Frustrated'],
        'notes': 'Bugs broke 3 quests in a row. Gave up.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Game Diary')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final game = diaryEntries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: const Color(0xFF2C2C2E),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(game['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${game['platform']} • ${game['status']}"),
                  Text(game['date'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              children: [
                if (game['moods'] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Wrap(
                      spacing: 8,
                      children: List.generate(game['moods'].length, (i) {
                        return Chip(
                          label: Text(game['moods'][i]),
                          backgroundColor: Colors.deepPurple.shade400,
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }),
                    ),
                  ),
                if (game['notes'] != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      game['notes'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
