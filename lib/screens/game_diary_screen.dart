import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/GameReview.dart';
import '../providers/review_data.dart';

class GameDiaryScreen extends StatefulWidget {
  const GameDiaryScreen({Key? key}) : super(key: key);

  @override
  State<GameDiaryScreen> createState() => _GameDiaryScreenState();
}

class _GameDiaryScreenState extends State<GameDiaryScreen> {
  String _sortOrder = 'Descending';
  int _scoreThreshold = 0;

  final List<int> _scoreRanges = [0, 6, 7, 8, 9];

  @override
  Widget build(BuildContext context) {
    List<GameReview> reviews = Provider.of<ReviewData>(context).reviews;

    // Filter and sort reviews
    reviews = reviews.where((r) => r.overallRating >= _scoreThreshold).toList();
    reviews.sort((a, b) => _sortOrder == 'Descending'
        ? b.overallRating.compareTo(a.overallRating)
        : a.overallRating.compareTo(b.overallRating));

    return Scaffold(
      appBar: AppBar(title: const Text("Your Game Reviews")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Text("Sort:", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortOrder,
                  items: ['Descending', 'Ascending']
                      .map((order) => DropdownMenuItem(
                            value: order,
                            child: Text(order),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sortOrder = value);
                    }
                  },
                ),
                const Spacer(),
                const Text("Filter:", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _scoreThreshold,
                  items: _scoreRanges
                      .map((score) => DropdownMenuItem(
                            value: score,
                            child: Text(score == 0 ? "All" : "$score & Up"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _scoreThreshold = value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (_, index) {
                final review = reviews[index];
                return _ReviewCard(review: review);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final GameReview review;

  const _ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _showInDepth = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final hasInDepth = review.sectionScores != null && review.sectionScores!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (review.coverUrl != null)
                  Image.network(
                    review.coverUrl!,
                    height: 80,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.gameName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${review.overallRating}/10 ⭐",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      if (review.labels?.isNotEmpty == true)
                        Wrap(
                          spacing: 6,
                          children: review.labels!.map((label) {
                            return Chip(
                              label: Text(label),
                              backgroundColor: Colors.deepPurple,
                              labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.quickReview, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              "Worth full price: ${review.worthFullPrice ?? "Not Specified"}",
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
            if (hasInDepth) ...[
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("In-Depth Review"),
                trailing: Icon(_showInDepth ? Icons.expand_less : Icons.expand_more),
                onTap: () => setState(() => _showInDepth = !_showInDepth),
              ),
              if (_showInDepth)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: review.sectionScores!.entries.map((entry) {
                    final score = entry.value;
                    final notes = review.sectionNotes?[entry.key] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${entry.key}: ${score.toStringAsFixed(1)}/10",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          if (notes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                notes,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
