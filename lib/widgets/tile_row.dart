import 'package:flutter/material.dart';
import '../screens/home_screen.dart' show TileStatus;

class TileRow extends StatelessWidget {
  final List<String> letters; // e.g. ['W', 'O', 'R', 'D', 'S']
  final List<TileStatus>? statuses; // optional statuses for each tile

  const TileRow({super.key, required this.letters, this.statuses});

  Color _bgColor(TileStatus status) {
    switch (status) {
      case TileStatus.correct:
        return Colors.green;
      case TileStatus.present:
        return Colors.amber; // yellow-like
      case TileStatus.absent:
        return Colors.grey.shade700;
      case TileStatus.unknown:
      default:
        return Colors.transparent;
    }
  }

  Color _textColor(TileStatus status) {
    switch (status) {
      case TileStatus.unknown:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  Border _border(TileStatus status) {
    if (status == TileStatus.unknown) {
      return Border.all(color: Colors.grey.shade600, width: 2);
    } else {
      return Border.all(color: Colors.transparent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TileStatus> s = statuses ?? List.generate(5, (_) => TileStatus.unknown);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final letter = letters.length > i ? letters[i] : '';
        final status = s.length > i ? s[i] : TileStatus.unknown;

        return Container(
          margin: const EdgeInsets.all(6),
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _bgColor(status),
            border: _border(status),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _textColor(status),
            ),
          ),
        );
      }),
    );
  }
}
