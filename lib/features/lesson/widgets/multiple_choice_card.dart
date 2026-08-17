import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';
import '../../../core/models/word.dart';

class MultipleChoiceCard extends StatefulWidget {
  final Lesson lesson;
  final Word currentWord;
  final Future<void> Function(bool correct, String answer) onAnswered;

  const MultipleChoiceCard({
    super.key,
    required this.lesson,
    required this.currentWord,
    required this.onAnswered,
  });

  @override
  State<MultipleChoiceCard> createState() =>
      _MultipleChoiceCardState();
}

class _MultipleChoiceCardState
    extends State<MultipleChoiceCard> {
  late List<Word> options;

  Word? selected;
  bool answered = false;

  @override
  void initState() {
    super.initState();

    options = [...widget.lesson.words];
    options.shuffle(Random());

    // Make sure the correct answer is always present.
    if (!options.any((w) => w.id == widget.currentWord.id)) {
      options.add(widget.currentWord);
    }

    options = options.take(4).toList();

    if (!options.any((w) => w.id == widget.currentWord.id)) {
      options[Random().nextInt(options.length)] =
          widget.currentWord;
    }

    options.shuffle();
  }

  Future<void> selectAnswer(Word word) async {
    if (answered) return;

    final correct = word.id == widget.currentWord.id;

    setState(() {
      answered = true;
      selected = word;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    await widget.onAnswered(
      correct,
      widget.currentWord.marathi,
    );
  }

  Color? buttonColor(Word word) {
    if (!answered) return null;

    if (word.id == widget.currentWord.id) {
      return Colors.green;
    }

    if (selected?.id == word.id) {
      return Colors.red;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        Text(
          widget.currentWord.english,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Choose the correct Marathi word",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 30),

        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              final word = options[index];

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        buttonColor(word),
                    minimumSize:
                        const Size(double.infinity, 60),
                  ),
                  onPressed: answered
                      ? null
                      : () => selectAnswer(word),
                  child: Text(
                    word.marathi,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}