import 'package:flutter/material.dart';

class FeedbackPanel extends StatelessWidget {
  final bool correct;
  final String? correctAnswer;
  final VoidCallback onContinue;

  const FeedbackPanel({
    super.key,
    required this.correct,
    this.correctAnswer,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        correct ? Colors.green.shade100 : Colors.red.shade100;

    final Color textColor =
        correct ? Colors.green.shade900 : Colors.red.shade900;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            correct ? "✅ Correct!" : "❌ Incorrect",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          if (!correct) ...[
            const SizedBox(height: 10),
            Text(
              "Correct answer:",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              correctAnswer ?? "",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              child: const Text("Continue"),
            ),
          )
        ],
      ),
    );
  }
}