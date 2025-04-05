import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../models/GameReview.dart';
import '../providers/review_data.dart';

class ReviewFormScreen extends StatefulWidget {
  final Game game;

  const ReviewFormScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  int _rating = 5;
  final _quickReviewController = TextEditingController();
  List<String> _labels = [];
  bool _showInDepth = false;
  String? _priceValue;

  final Map<String, double> _sectionScores = {
    'Gameplay & Controls': 5.0,
    'Graphics & Visuals': 5.0,
    'Story & Characters': 5.0,
    'Sound & Music': 5.0,
    'Replayability': 5.0,
  };

  final Map<String, TextEditingController> _sectionControllers = {
    'Gameplay & Controls': TextEditingController(),
    'Graphics & Visuals': TextEditingController(),
    'Story & Characters': TextEditingController(),
    'Sound & Music': TextEditingController(),
    'Replayability': TextEditingController(),
  };

  final List<String> predefinedLabels = [
    "Challenging",
    "Relaxing",
    "Story-Driven",
    "Action-Packed",
    "Cozy",
    "Grindy",
    "Exploration-Focused",
    "Quick Sessions",
    "Emotional",
    "Highly Replayable",
    "Great for Co-Op",
    "Breathtaking Visuals",
    "Immersive World",
  ];

  void _submitReview() {
    if (_rating == 0 || _quickReviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and review")),
      );
      return;
    }

    final inDepthScores = _showInDepth ? Map<String, double>.from(_sectionScores) : null;
    final inDepthNotes = _showInDepth
        ? _sectionControllers.map((key, ctrl) => MapEntry(key, ctrl.text.trim()))
        : null;

    final review = GameReview(
      gameId: widget.game.id,
      gameName: widget.game.name,
      coverUrl: widget.game.coverUrl,
      overallRating: _rating,
      quickReview: _quickReviewController.text.trim(),
      worthFullPrice: _priceValue,
      sectionScores: inDepthScores,
      sectionNotes: inDepthNotes,
      labels: _labels,
    );

    Provider.of<ReviewData>(context, listen: false).addReview(review);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review submitted!")),
    );
    Navigator.pop(context);
  }

  Widget _buildSliderRating(String label, double value, ValueChanged<double> onChanged) {
    final controller = TextEditingController(text: value.toInt().toString());

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                  child: Slider(
                    value: value,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: value.toStringAsFixed(0),
                    onChanged: onChanged,
                  ),
                ),
              ),
              SizedBox(
                width: 52,
                height: 52,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onSubmitted: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= 1 && parsed <= 10) {
                      onChanged(parsed.toDouble());
                    } else {
                      controller.text = value.toInt().toString();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInDepthSection(String sectionTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sectionTitle,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent)),
              const SizedBox(height: 10),
              _buildSliderRating(
                sectionTitle,
                _sectionScores[sectionTitle]!,
                (value) => setState(() => _sectionScores[sectionTitle] = value),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sectionControllers[sectionTitle],
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Add your notes...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Was it worth full price?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 10,
            children: ['Yes', 'No', 'Wait for a Sale'].map((label) {
              final selected = _priceValue == label;
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) {
                  setState(() => _priceValue = label);
                },
                selectedColor: Colors.deepPurple,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.grey[200],
                ),
                backgroundColor: Colors.grey[800],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPredefinedLabels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text("Select Labels:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: predefinedLabels.map((label) {
            final isSelected = _labels.contains(label);
            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  isSelected ? _labels.remove(label) : _labels.add(label);
                });
              },
              selectedColor: Colors.deepPurple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[200],
              ),
              backgroundColor: Colors.grey[800],
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;

    return Scaffold(
      appBar: AppBar(title: const Text("Write Review")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                if (game.coverUrl != null)
                  Image.network(game.coverUrl!, height: 100),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    game.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSliderRating("Overall Rating", _rating.toDouble(), (value) {
              setState(() => _rating = value.toInt());
            }),
            const SizedBox(height: 12),
            TextField(
              controller: _quickReviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Write your quick thoughts...",
                border: OutlineInputBorder(),
              ),
            ),
            _buildPriceFeedback(),
            _buildPredefinedLabels(),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("In-Depth Review"),
              trailing: Icon(_showInDepth ? Icons.expand_less : Icons.expand_more),
              onTap: () => setState(() => _showInDepth = !_showInDepth),
            ),
            if (_showInDepth)
              ..._sectionScores.keys.map((section) => _buildInDepthSection(section)).toList(),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submitReview, child: const Text("Submit Review")),
          ],
        ),
      ),
    );
  }
}
