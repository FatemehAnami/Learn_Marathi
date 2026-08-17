import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';
import '../../../core/models/word.dart';
import '../../../core/services/speech_service.dart';

class ListeningCard extends StatefulWidget {
  final Lesson lesson;
  final Word currentWord;

  final void Function(
    bool correct,
    String answer,
  ) onAnswered;

  const ListeningCard({
    super.key,
    required this.lesson,
    required this.currentWord,
    required this.onAnswered,
  });

  @override
  State<ListeningCard> createState() =>
      _ListeningCardState();
}

class _ListeningCardState
    extends State<ListeningCard> {

  final SpeechService _speech =
          SpeechService.instance;

      late List<Word> options;

      Word? selected;

      bool answered = false;

  @override
  void initState() {
    super.initState();

    // Create the answer options only once.
    options = [...widget.lesson.words];

    options.shuffle();

    // Keep only 4 choices.
    options = options.take(4).toList();

    // Make sure the correct answer is included.
    if (!options.contains(widget.currentWord)) {
      options[0] = widget.currentWord;
    }

    // Shuffle one more time so the correct answer
    // is not always in the same position.
    options.shuffle();

    // Play automatically after the card appears.
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _playAudio();
    });
  }



  // =====================================================
  // PLAY AUDIO
  // =====================================================

  Future<void> _playAudio() async {
    if (!mounted) return;

    await _speech.speak(
      widget.currentWord.marathi,
    );
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  // =====================================================
  // ANSWER
  // =====================================================

  void _selectAnswer(Word word) {
    if (answered) {
      return;
    }

    final correct =
        word.id ==
        widget.currentWord.id;

    setState(() {
      selected = word;
      answered = true;
    });

    widget.onAnswered(
      correct,
      word.marathi,
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Listen and choose the correct word",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Small replay button
            IconButton(
              onPressed: _playAudio,
              icon: const Icon(
                Icons.volume_up,
              ),
              iconSize: 24,
              tooltip: "Replay",
            ),
          ],
        ),

        const SizedBox(height: 30),

        // =================================================
        // AUDIO BUTTON
        // =================================================

        const SizedBox(height: 12),

        const Text(
          "Tap to hear again",
          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 30),

        // =================================================
        // OPTIONS
        // =================================================

        Expanded(
          child: ListView.builder(
            itemCount: options.length,

            itemBuilder:
                (context, index) {
              final word =
                  options[index];

              Color? backgroundColor;

              if (answered) {
                if (word.id ==
                    widget
                        .currentWord
                        .id) {
                  backgroundColor =
                      Colors.green;
                }

                if (selected?.id ==
                        word.id &&
                    word.id !=
                        widget
                            .currentWord
                            .id) {
                  backgroundColor =
                      Colors.red;
                }
              }

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                child:
                    SizedBox(
                  width:
                      double.infinity,

                  child:
                      ElevatedButton(
                    onPressed:
                        answered
                            ? null
                            : () {
                                _selectAnswer(
                                  word,
                                );
                              },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          backgroundColor,

                      minimumSize:
                          const Size(
                        double.infinity,
                        60,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),
                      ),
                    ),

                    child: Text(
                      word.marathi,

                      style:
                          const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
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