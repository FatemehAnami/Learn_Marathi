import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';
import '../../../core/models/word.dart';

class MatchWordsCard extends StatefulWidget {
  final Lesson lesson;
  final Word currentWord;

  final void Function(bool correct, String answer)
      onAnswered;

  const MatchWordsCard({
    super.key,
    required this.lesson,
    required this.currentWord,
    required this.onAnswered,
  });

  @override
  State<MatchWordsCard> createState() =>
      _MatchWordsCardState();
}

class _MatchWordsCardState
    extends State<MatchWordsCard> {

  late List<Word> words;
  late List<String> meanings;

  String? selectedMeaning;

  bool answered = false;

  @override
  void initState() {
    super.initState();

    final random = Random();

    words = [...widget.lesson.words];

    words.shuffle();

    words = words.take(4).toList();

    if (!words.contains(widget.currentWord)) {
      words[random.nextInt(words.length)] =
          widget.currentWord;
    }

    meanings = words
        .map((e) => e.english)
        .toList();

    meanings.shuffle();
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        const SizedBox(height: 20),

        const Text(
          "Match the word",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        Text(
          widget.currentWord.marathi,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 40),

        Expanded(
          child: ListView.builder(

            itemCount: meanings.length,

            itemBuilder: (context, index) {

              final meaning =
                  meanings[index];

              Color? color;

              if (answered) {

                if (meaning ==
                    widget.currentWord.english) {
                  color = Colors.green;
                }

                if (selectedMeaning ==
                        meaning &&
                    meaning !=
                        widget.currentWord
                            .english) {
                  color = Colors.red;
                }
              }

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                child:
                    ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: color,
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

                              setState(() {

                                answered = true;

                                selectedMeaning =
                                    meaning;

                              });

                              widget.onAnswered(

                                meaning ==
                                    widget.currentWord
                                        .english,

                                meaning,

                              );

                            },

                  child: Text(
                    meaning,
                    style:
                        const TextStyle(
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