import 'package:flutter/material.dart';

import '../../core/models/lesson.dart';
import '../../core/models/lesson_result.dart';
import '../../core/models/question.dart';

import '../../core/services/lesson_engine.dart';
import '../../core/repositories/unit_repository.dart';

import 'lesson_controller.dart';

import 'widgets/feedback_panel.dart';
import 'widgets/learn_card.dart';
import 'widgets/listening_card.dart';
import 'widgets/multiple_choice_card.dart';
import 'widgets/example_choice_card.dart';
import 'widgets/fill_blank_card.dart';
import 'widgets/match_words_card.dart';
import 'widgets/build_sentence_card.dart';
import 'widgets/lesson_summary_card.dart';
import '../../core/services/progress_service.dart';
import '../../core/models/word.dart';

class LessonScreen extends StatefulWidget {
  final int unitId;
  final int lessonId;

  // Used for generated lessons such as Unit Review.
  final Lesson? lessonOverride;

  const LessonScreen({
    super.key,
    required this.unitId,
    required this.lessonId,
    this.lessonOverride,
  });

  @override
  State<LessonScreen> createState() =>
      _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {

  late final LessonController controller;
  late Future<Lesson> lessonFuture;  

  @override
  void initState() {
    super.initState();

    controller = LessonController(
      unitId: widget.unitId,
      lessonId: widget.lessonId,
    );    
    controller.loadProgress();

    if (widget.lessonOverride != null) {
      lessonFuture = Future.value(widget.lessonOverride!);
    } else {
      lessonFuture = UnitRepository().loadLesson(
        unitId: widget.unitId,
        lessonId: widget.lessonId,
      );
    }

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<Lesson> _loadLesson() async {
    // Normal lessons: 1, 2, 3, 4
    if (widget.lessonId != 5) {
      return UnitRepository().loadLesson(
        unitId: widget.unitId,
        lessonId: widget.lessonId,
      );
    }

    // ==========================================
    // UNIT REVIEW
    // ==========================================

    final repository = UnitRepository();

    final List<Word> allWords = [];

    // Load Lessons 1-4
    for (int lessonId = 1; lessonId <= 4; lessonId++) {
      final lesson = await repository.loadLesson(
        unitId: widget.unitId,
        lessonId: lessonId,
      );

      allWords.addAll(lesson.words);
    }

    // Make sure we have enough words
    if (allWords.length < 10) {
      throw Exception(
        "Unit review needs at least 10 words.",
      );
    }

    // Shuffle the 16 words
    allWords.shuffle();

    // Take exactly 10 DIFFERENT words
    final reviewWords = allWords.take(10).toList();

    return Lesson(
      id: 5,
      title: "Unit Review",
      words: reviewWords,
    );
  }

  Future<void> handleAnswer(
    bool correct,
    String answer,
  ) async {

    final result =
        await controller.answer(
      correct,
      answer,
    );

    if (!result.outOfHearts) {
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {

        return AlertDialog(
          title: const Text(
            "💔 Out of Hearts",
          ),
          content: const Text(
            "Try again tomorrow or reset hearts.",
          ),
          actions: [

            TextButton(
              onPressed: () async {

                await controller.resetHearts();

                if (!mounted) return;

                Navigator.pop(context);
                Navigator.pop(context);

              },
              child: const Text("OK"),
            )

          ],
        );

      },
    );
  }

  Future<void> continueLesson() async {
    
    final finished =  await controller.continueLesson();

    if (finished) {
      await ProgressService().markLessonCompleted(
        widget.unitId,
        widget.lessonId,
    );
    //if (!finished) return;

      final LessonResult result =
        controller.getResult();

      if (!mounted) return;
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "🎉 Lesson Complete",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text("⭐ XP: ${result.xp}"),

              const SizedBox(height: 8),

              Text(
                "❤️ Hearts: ${result.heartsLeft}",
              ),

              const SizedBox(height: 8),

              Text(
                "✅ Correct: ${result.correct}",
              ),

              const SizedBox(height: 8),

              Text(
                "❌ Wrong: ${result.wrong}",
              ),

              const Divider(),

              Text(
                "🎯 Accuracy: ${(result.accuracy * 100).toStringAsFixed(0)}%",
              ),

              const SizedBox(height: 8),

              Text(
                result.rating,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Continue",
              ),
            ),

          ],
        );
      },
    );
  }}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [

            const Text("Lesson"),

            Text(
              "❤️ ${controller.hearts}",
            ),

          ],
        ),

      ),

      body: FutureBuilder<Lesson>(
        future: lessonFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final lesson = snapshot.data!;

          if (controller.questions.isEmpty) {
            controller.setQuestions(
              LessonEngine().build(lesson),
            );
          }

          final question = controller.currentQuestion;

          Widget page;
          print(
            "QUESTION ${{controller.currentQuestionIndex}} -> ${question.type} (${question.word?.id})",
);
          switch (question.type) {

            // ===========================
            // Learn
            // ===========================

            case QuestionType.learn:
              page = LearnCard(
                lesson: lesson,
                currentWord: question.word!,
              );
              break;

            // ===========================
            // Vocabulary
            // ===========================

            case QuestionType.vocabularyMultipleChoice:
              print("BUILDING PAGE MultipleChoiceCaRD");
              page = MultipleChoiceCard(
                key: ValueKey(
                  "${controller.currentQuestionIndex}_${question.word!.id}",
                ),                
                lesson: lesson,
                currentWord: question.word!,
                onAnswered: (correct, answer) =>
                    handleAnswer(correct, answer),
              );
              break;

            case QuestionType.vocabularyListening:
              print(
                "BUILDING PAGE ListeningCard "
                "${question.word!.id}",
              );
              page = ListeningCard(
                key: ValueKey(
                  "${controller.currentQuestionIndex}_${question.word!.id}",
                ),
                lesson: lesson,
                currentWord: question.word!,
                onAnswered: (correct, answer) =>
                    handleAnswer(
                  correct,
                  answer,
                ),
              );
              break;

            case QuestionType.vocabularyMatch:
              print("BUILDING PAGE MatchWordsCard");
              page = MatchWordsCard(
                
                key: ValueKey(
                  "${controller.currentQuestionIndex}_${question.word!.id}",
                ),
                lesson: lesson,
                currentWord: question.word!,
                onAnswered: (correct, answer) =>
                    handleAnswer(
                  correct,
                  answer,
                ),
              );
              break;

            // ===========================
            // Sentence
            // ===========================

            case QuestionType.sentenceMultipleChoice:
              print("BUILDING PAGE ExampleChoiceCard");
              page = ExampleChoiceCard(
                key: ValueKey(
                  "${controller.currentQuestionIndex}_${question.word!.id}",
                ),
                lesson: lesson,
                currentWord: question.word!,
                onAnswered: (correct, answer) =>
                    handleAnswer(
                  correct,
                  answer,
                ),
              );
              break;              

            case QuestionType.sentenceFillBlank:
              print("BUILDING PAGE FillBlankCard");
              page = FillBlankCard(
                key: ValueKey(
                  "${controller.currentQuestionIndex}_${question.word!.id}",
            ),
                currentWord: question.word!,
                onAnswered: (correct, answer) =>
                    handleAnswer(
                  correct,
                  answer,
                ),
              );
              break;

            case QuestionType.sentenceBuild:
              print("BUILDING PAGE BuildSentenceCard");
              page = BuildSentenceCard(
                key: ValueKey(
                  "${controller.currentQuestionIndex}_${question.word!.id}",
                ),
                currentWord: question.word!,
                onAnswered: (correct, answer) =>
                    handleAnswer(correct, answer),
              );
              break;

            // ===========================
            // End
            // ===========================
             
            case QuestionType.finalReview:
              print("BUILDING PAGE FinalReviewCard");
              page = LessonSummaryCard(
                xp: controller.lessonXP + 20,
                hearts: controller.hearts,
                correct: controller.correctAnswers,
                wrong: controller.wrongAnswers,
                onFinish: () async {
                  print("FINISH BUTTON PRESSED");

                  final progress = ProgressService();

                  await progress.markLessonCompleted(
                    widget.unitId,
                    widget.lessonId,
                  );

                  print( "LESSON COMPLETED -> "  "unit=${widget.unitId}, " "lesson=${widget.lessonId}",  );

                  // Lesson 5 is the Unit Review.
                  // Completing it completes the whole unit.
                  if (widget.lessonId == 5) {
                    await progress.markUnitCompleted(
                      widget.unitId,
                    );

                    print("UNIT COMPLETED -> " "unit=${widget.unitId}",   );
                  }

                  if (!mounted) return;

                  Navigator.pop(context);
                },      
              );    
              break;
          }

          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: (controller.currentQuestionIndex + 1) /
                            controller.questions.length,
                        minHeight: 8,
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: page,
                      ),

                      if (question.type == QuestionType.learn)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: continueLesson,
                            child: const Text(
                              "Continue",
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (controller.showFeedback)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FeedbackPanel(
                    correct: controller.lastAnswerCorrect,
                    correctAnswer: controller.correctAnswer,
                    onContinue: continueLesson,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}                    