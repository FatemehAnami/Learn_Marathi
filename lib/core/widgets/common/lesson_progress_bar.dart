import 'package:flutter/material.dart';

class LessonProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const LessonProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: current / total,
          minHeight: 10,
          borderRadius: BorderRadius.circular(12),
        ),
        const SizedBox(height: 8),
        Text(
          "$current / $total",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}