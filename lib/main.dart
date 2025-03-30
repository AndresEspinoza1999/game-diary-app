import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_game_screen.dart';
import 'screens/game_diary_screen.dart';
import 'screens/search_games_test_screen.dart'; // <-- Added
import 'data/game_data.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameData()),
      ],
      child: const GameDiaryApp(),
    ),
  );
}

class GameDiaryApp extends StatelessWidget {
  const GameDiaryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Diary',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      routes: {
        '/add': (context) => const AddGameScreen(),
        '/test': (context) => const SearchGamesTestScreen(), // <-- Added
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    GameDiaryScreen(),
    Placeholder(), // Add Game (handled via route)
    DiscoverScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/add');
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 2 ? _currentIndex : (_currentIndex < 2 ? _currentIndex : 0),
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.book), label: "Diary"),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
            label: "",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discover"),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}
