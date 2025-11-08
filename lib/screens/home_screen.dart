import 'package:flutter/material.dart';
import '../widgets/tile_row.dart';
import '../widgets/keyboard.dart';
import '../utils/word_generator.dart';

enum TileStatus { unknown, correct, present, absent }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<String>> board = List.generate(6, (_) => List.generate(5, (_) => ''));
  List<List<TileStatus>> tileStatus =
      List.generate(6, (_) => List.generate(5, (_) => TileStatus.unknown));

  int currentRow = 0;
  int currentCol = 0;
  late String targetWord;
  bool gameOver = false;
  String? gameMessage;

  @override
  void initState() {
    super.initState();
    targetWord = WordGenerator.getRandomWord().toUpperCase();
    debugPrint('🎯 Target: $targetWord');
  }

  void handleKeyPress(String key) {
    if (gameOver) return; // stop if game ended

    setState(() {
      if (key == '⌫') {
        if (currentCol > 0) {
          currentCol--;
          board[currentRow][currentCol] = '';
        }
      } else if (key == 'ENTER') {
        if (currentCol == 5) {
          final guess = board[currentRow].join().toUpperCase();

          _evaluateGuessForRow(guess, currentRow);

          if (guess == targetWord) {
            _handleWin(currentRow);
            return;
          }

          if (currentRow < 5) {
            currentRow++;
            currentCol = 0;
          } else {
            _handleLoss();
          }
        }
      } else if (RegExp(r'^[A-Z]$').hasMatch(key)) {
        if (currentCol < 5) {
          board[currentRow][currentCol] = key;
          currentCol++;
        }
      }
    });
  }

  void _evaluateGuessForRow(String guess, int rowIndex) {
    final List<TileStatus> status = List.generate(5, (_) => TileStatus.unknown);
    final guessLetters = guess.split('');
    final targetLetters = targetWord.split('');

    List<bool> matched = List.generate(5, (_) => false);

    // First pass: correct letters
    for (int i = 0; i < 5; i++) {
      if (guessLetters[i] == targetLetters[i]) {
        status[i] = TileStatus.correct;
        matched[i] = true;
      }
    }

    // Frequency map for remaining target letters
    Map<String, int> remaining = {};
    for (int i = 0; i < 5; i++) {
      if (!matched[i]) {
        final t = targetLetters[i];
        remaining[t] = (remaining[t] ?? 0) + 1;
      }
    }

    // Second pass: present/absent
    for (int i = 0; i < 5; i++) {
      if (status[i] == TileStatus.correct) continue;
      final g = guessLetters[i];
      if ((remaining[g] ?? 0) > 0) {
        status[i] = TileStatus.present;
        remaining[g] = remaining[g]! - 1;
      } else {
        status[i] = TileStatus.absent;
      }
    }

    tileStatus[rowIndex] = status;
  }

  void _handleWin(int rowIndex) {
    setState(() {
      gameOver = true;
      gameMessage = _getSuccessMessage(rowIndex);
    });
  }

  void _handleLoss() {
    setState(() {
      gameOver = true;
      gameMessage = '😞 Better luck next time!\nWord: $targetWord';
    });
  }

  String _getSuccessMessage(int rowIndex) {
    switch (rowIndex) {
      case 0:
        return '🧠 GOD MODE!';
      case 1:
        return '🤯 GENIUS!';
      case 2:
        return '🔥 LEGENDARY!';
      case 3:
        return '💪 PROFESSIONAL!';
      case 4:
        return '🙂 AMATEUR!';
      case 5:
        return '😅 NOOBIE!';
      default:
        return '🎉 You got it!';
    }
  }

  Widget _buildOverlayMessage() {
    if (!gameOver || gameMessage == null) return const SizedBox.shrink();
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white30, width: 2),
          ),
          child: Text(
            gameMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Clone'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (r) {
                      return TileRow(
                        letters: board[r],
                        statuses: tileStatus[r],
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Keyboard(onKeyPressed: handleKeyPress),
              ),
            ],
          ),
          _buildOverlayMessage(),
        ],
      ),
    );
  }
}
