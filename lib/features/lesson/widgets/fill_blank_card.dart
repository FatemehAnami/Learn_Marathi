import 'package:flutter/material.dart';
import '../../../core/models/word.dart';

class FillBlankCard extends StatefulWidget {
  final Word currentWord;
  final void Function(bool correct, String answer)
      onAnswered;

  const FillBlankCard({
    super.key,
    required this.currentWord,
    required this.onAnswered,
  });

  @override
  State<FillBlankCard> createState() =>
      _FillBlankCardState();
}

class _FillBlankCardState
    extends State<FillBlankCard> {

  final TextEditingController controller =
      TextEditingController();

  bool answered = false;
  String correctAnswer = "";

  @override
  Widget build(BuildContext context) {

    final example =
        widget.currentWord.examples.first;

    final sentence =
        example.marathi.replaceFirst(
      widget.currentWord.marathi,
      "_____",
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
          CrossAxisAlignment.stretch,
        children: [

          const SizedBox(height: 20),

          const Text(
            "Fill in the blank",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          Text(
            sentence,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            example.english,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),

          TextField(
            controller: controller,
            enabled: !answered,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Type the missing word",
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(

            onPressed: answered
                ? null
                : () {
                    print("Pressed Check");
                    
                    final userAnswer =
                        controller.text.trim();

                    final correctAnswer =
                        widget.currentWord.marathi
                            .trim();

                    final correct =
                        userAnswer.toLowerCase() ==
                            correctAnswer
                                .toLowerCase();

                    setState(() {
                      answered = true;
                    });

                    widget.onAnswered(
                      correct,
                      userAnswer,
                    );

                  },

            child: const Text("Check"),
          ),

          if (answered) ...[
            const SizedBox(height: 24),

            const Text(
              "Your answer:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              controller.text.trim(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Correct answer:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.currentWord.marathi.trim(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],

        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}