import 'dart:math';

class WordGenerator {
  static final List<String> _wordList = [
    'APPLE',
    'BRAIN',
    'CRANE',
    'PLANT',
    'SMILE',
    'TRACK',
    'HOUSE',
    'MOUSE',
    'LIGHT',
    'WATER',
  ];

  static final _random = Random();

  /// Returns a random 5-letter word
  static String getRandomWord() {
    return _wordList[_random.nextInt(_wordList.length)];
  }

  /// Returns true if [word] exists in the list
  static bool isValidWord(String word) {
    return _wordList.contains(word.toUpperCase());
  }
}
