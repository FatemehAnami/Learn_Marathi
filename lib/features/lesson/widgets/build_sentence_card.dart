import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/models/word.dart';

class BuildSentenceCard extends StatefulWidget {
  final Word currentWord;

  final void Function(bool correct, String answer)
      onAnswered;

  const BuildSentenceCard({
    super.key,
    required this.currentWord,
    required this.onAnswered,
  });

  @override
  State<BuildSentenceCard> createState() =>
      _BuildSentenceCardState();
}

class _BuildSentenceCardState
    extends State<BuildSentenceCard> {

  late List<String> availableWords;

  final List<String> selectedWords = [];

  bool answered = false;

  @override
  void initState() {
    super.initState();
    _buildQuestion();
  }

  void _buildQuestion() {

    answered = false;

    selectedWords.clear();

    final sentence =
        widget.currentWord.examples.first.marathi;

    availableWords =
        sentence.split(" ");

    availableWords.shuffle(Random());
  }

  void _removeSelectedWord(String word) {
    if (answered) return;

    setState(() {
      selectedWords.remove(word);
      availableWords.add(word);
    });
  }

  @override
  void didUpdateWidget(
      covariant BuildSentenceCard oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentWord.id !=
        widget.currentWord.id) {

      setState(() {
        _buildQuestion();
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    final example =
        widget.currentWord.examples.first;

    return Column(

      children: [

        const SizedBox(height: 20),

        const Text(
          "Build the sentence",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          example.english,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),

        const SizedBox(height: 30),

        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            children: selectedWords
                .map(
                  (word) => ActionChip(
                    label: Text(word),
                    onPressed: answered
                        ? null
                        : () {
                               _removeSelectedWord(word);
                        },
            ),
                )
                .toList(),
         ),
        ),

        const SizedBox(height: 20),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableWords
              .map(
                (word) => ActionChip(
                  label: Text(word),
                  onPressed:
                      answered
                          ? null
                          : () {

                              setState(() {

                                selectedWords
                                    .add(word);

                                availableWords
                                    .remove(word);

                              });

                            },
                ),
              )
              .toList(),
        ),

        const Spacer(),

        ElevatedButton(

          onPressed:
              answered
                  ? null
                  : () {

                      answered = true;

                      final answer =
                          selectedWords.join(" ");

                      widget.onAnswered(

                        answer ==
                            example.marathi,

                        answer,

                      );

                    },

          child: const Text(
            "Check",
          ),
        ),
      ],
    );
  }
}