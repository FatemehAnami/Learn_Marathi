import 'package:flutter/material.dart';

class LessonSummaryCard extends StatelessWidget {
  final int xp;
  final int hearts;
  final int correct;
  final int wrong;
  final VoidCallback onFinish;

  const LessonSummaryCard({
    super.key,
    required this.xp,
    required this.hearts,
    required this.correct,
    required this.wrong,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final total = correct + wrong;

    final accuracy = total == 0
        ? 0
        : ((correct / total) * 100).round();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎉 Lesson Complete!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        "⭐ XP: $xp",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "❤️ Hearts: $hearts",
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),

                      const Divider(height: 40),

                      Text(
                        "Correct: $correct",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Wrong: $wrong",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Accuracy: $accuracy%",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onFinish,
                  child: const Text(
                    "Finish",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
          ],
          ),
        ),
      )
    );
  }
}