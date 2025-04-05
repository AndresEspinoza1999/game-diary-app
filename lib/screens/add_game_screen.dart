import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../data/game_data.dart';

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({Key? key}) : super(key: key);

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newGame = Game(
  id: DateTime.now().millisecondsSinceEpoch, // or use a proper ID generator
  name: _nameController.text.trim(),
  summary: _summaryController.text.trim(),
  coverUrl: null,
  platforms: [],
);


      Provider.of<GameData>(context, listen: false).addGame(newGame);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Game Title'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Please enter a game title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Summary'),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
