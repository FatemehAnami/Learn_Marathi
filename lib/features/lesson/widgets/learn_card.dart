import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';
import '../../../core/models/word.dart';
import '../../../core/services/speech_service.dart';

class LearnCard extends StatefulWidget {
  final Lesson lesson;
  final Word currentWord;

  const LearnCard({
    super.key,
    required this.lesson,
    required this.currentWord,
  });

  @override
  State<LearnCard> createState() => _LearnCardState();
}

class _LearnCardState extends State<LearnCard> {
  final SpeechService _speech =
      SpeechService.instance;

  @override
  void initState() {
    super.initState();

    // Play audio automatically when
    // the learning card appears.
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _playAudio();
    });
  }

  // --------------------------------------------------
  // PLAY WORD + SAMPLE SENTENCE
  // --------------------------------------------------

  Future<void> _playAudio() async {
    if (!mounted) return;

    final word =
        widget.currentWord.marathi;

    // If there is no example sentence,
    // just pronounce the word.
    if (widget.currentWord.examples.isEmpty) {
      await _speech.speak(word);
      return;
    }

    final example =
        widget.currentWord.examples.first;

    // First word, then sentence.
    await _speech.speakSequence([
      word,
      example.marathi,
    ]);
  }

  // --------------------------------------------------
  // STOP AUDIO WHEN CARD IS REMOVED
  // --------------------------------------------------

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  // --------------------------------------------------
  // UI
  // --------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {
    final hasExample =
        widget.currentWord.examples.isNotEmpty;

    final example = hasExample
        ? widget.currentWord.examples.first
        : null;

    return Column(
      children: [
        // ------------------------------------------------
        // TITLE
        // ------------------------------------------------

        const Text(
          "Learn this word",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // ------------------------------------------------
        // WORD CARD
        // ------------------------------------------------

        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                // ------------------------------------------
                // MARATHI WORD + SMALL REPLAY BUTTON
                // ------------------------------------------

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Flexible(
                      child: Text(
                        widget.currentWord.marathi,
                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          fontSize: 34,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Small replay button
                    IconButton(
                      onPressed: _playAudio,
                      icon: const Icon(
                        Icons.volume_up,
                      ),
                      iconSize: 26,
                      tooltip: "Replay audio",
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ------------------------------------------
                // ENGLISH WORD
                // ------------------------------------------

                Text(
                  widget.currentWord.english,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),

                // ------------------------------------------
                // SAMPLE SENTENCE
                // ------------------------------------------

                if (example != null) ...[
                  const SizedBox(height: 24),

                  Text(
                    example.marathi,
                    textAlign:
                        TextAlign.center,

                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    example.english,
                    textAlign:
                        TextAlign.center,

                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}