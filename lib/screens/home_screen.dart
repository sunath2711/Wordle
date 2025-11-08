import 'package:flutter/material.dart';
import '../widgets/tile_row.dart';
import '../widgets/keyboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<String>> board = List.generate(6, (_) => List.generate(5, (_) => ''));

  void handleKeyPress(String key) {
    // For now, just log the key
    debugPrint('Key pressed: $key');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Clone'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The grid
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: board.map((row) => TileRow(letters: row)).toList(),
              ),
            ),
          ),

          // The keyboard
          Expanded(
            flex: 2,
            child: Keyboard(onKeyPressed: handleKeyPress),
          ),
        ],
      ),
    );
  }
}

