import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';
import '../../../core/models/word.dart';

class ExampleChoiceCard extends StatefulWidget {
  final Lesson lesson;
  final Word currentWord;

  final void Function(bool correct, String answer) onAnswered;

  const ExampleChoiceCard({
    super.key,
    required this.lesson,
    required this.currentWord,
    required this.onAnswered,
  });

  @override
  State<ExampleChoiceCard> createState() =>
      _ExampleChoiceCardState();
}

class _ExampleChoiceCardState
    extends State<ExampleChoiceCard> {

  late List<Word> options;

  Word? selected;

  bool answered = false;

  @override
  void initState() {
    super.initState();
    _createOptions();
  }

  void _createOptions() {
    final random = Random();

    answered = false;
    selected = null;

    final available =
        List<Word>.from(widget.lesson.words);

    available.shuffle(random);

    // Make sure the current word is included.
    available.removeWhere(
      (word) => word.id == widget.currentWord.id,
    );

    final otherWords =
        available.take(3).toList();

    options = [
      ...otherWords,
      widget.currentWord,
    ];

    options.shuffle(random);
  }

  @override
  void didUpdateWidget(
    covariant ExampleChoiceCard oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentWord.id !=
        widget.currentWord.id) {

      setState(() {
        _createOptions();
      });
    }
  }

  void _selectAnswer(Word word) {
    if (answered) {
      return;
    }

    final correct =
        word.id == widget.currentWord.id;

    setState(() {
      answered = true;
      selected = word;
    });

    widget.onAnswered(
      correct,
      word.marathi,
    );
  }

  @override
  Widget build(BuildContext context) {
    final example =
        widget.currentWord.examples.first;

    final sentence =
        example.marathi.replaceFirst(
      widget.currentWord.marathi,
      "_____",
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [

        const SizedBox(height: 20),

        const Text(
          "Which word completes this sentence?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 24),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                Text(
                  sentence,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  example.english,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {

              final word = options[index];

              Color? backgroundColor;

              if (answered) {

                if (word.id ==
                    widget.currentWord.id) {
                  backgroundColor =
                      Colors.green;
                } else if (selected?.id ==
                    word.id) {
                  backgroundColor =
                      Colors.red;
                }
              }

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        backgroundColor,
                    minimumSize:
                        const Size(
                      double.infinity,
                      60,
                    ),
                  ),
                  onPressed:
                      answered
                          ? null
                          : () {
                              _selectAnswer(
                                word,
                              );
                            },
                  child: Text(
                    word.marathi,
                    style: const TextStyle(
                      fontSize: 20,
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