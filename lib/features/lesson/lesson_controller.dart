import 'package:flutter/material.dart';

import '../../core/services/progress_service.dart';
import '../../core/models/question.dart';
import '../../core/models/lesson_result.dart';

class LessonController extends ChangeNotifier {
  final int unitId;
  final int lessonId;

  LessonController({
    required this.unitId,
    required this.lessonId,
  });

  int currentQuestionIndex = 0;

  bool showFeedback = false;
  bool lastAnswerCorrect = false;

  String correctAnswer = "";

  int hearts = 5;
  int lessonXP = 0;

  int correctAnswers = 0;
  int wrongAnswers = 0;

  List<Question> questions = [];

  // ---------------- Progress ----------------

  Future<void> loadProgress() async {
    hearts =
        await ProgressService().getHearts();

    notifyListeners();
  }

  // ---------------- Answer ----------------

  Future<AnswerResult> answer(
    bool correct,
    String answer,
  ) async {
    print(
      "ANSWER -> $answer | correct=$correct",
    );

    if (correct) {
      correctAnswers++;
      lessonXP += 10;

      await ProgressService().addXP(10);
    } else {
      wrongAnswers++;

      await ProgressService().loseHeart();

      hearts =
          await ProgressService().getHearts();
    }

    lastAnswerCorrect = correct;
    correctAnswer =  currentQuestion.word?.marathi ?? "";

    showFeedback = true;

    notifyListeners();

    return AnswerResult(
      outOfHearts: hearts == 0,
    );
  }

  // ---------------- Continue ----------------

  Future<bool> continueLesson() async {
    print("CONTINUE -> "      "index=$currentQuestionIndex / ${questions.length}",    );

    showFeedback = false;

    // -----------------------------------------
    // CURRENT QUESTION IS THE FINAL REVIEW
    // -----------------------------------------

    if (currentQuestion.type == QuestionType.finalReview) {
      print("FINAL REVIEW COMPLETED");

      final progress = ProgressService();

      print("SAVING LESSON -> unit=$unitId lesson=$lessonId",  );

      await progress.markLessonCompleted(
        unitId,
        lessonId,
      );

      print( "LESSON SAVED -> unit=$unitId lesson=$lessonId",  );

      await progress.addXP(20);
      await progress.updateStreak();

      notifyListeners();

      return true;
    }

    // ------------------------------------------
    // MOVE TO NEXT QUESTION
    // ------------------------------------------

    if (currentQuestionIndex < questions.length - 1) {

      currentQuestionIndex++;
      notifyListeners();
      return false;
    }

    return false;
  }

  // ---------------- Hearts ----------------

  Future<void> resetHearts() async {
    await ProgressService().resetHearts();

    hearts =
        await ProgressService().getHearts();

    notifyListeners();
  }

  // ---------------- Questions ----------------

  void setQuestions(
    List<Question> value,
  ) {
    if (questions.isEmpty) {
      questions = value;
    }
  }

  Question get currentQuestion =>
      questions[currentQuestionIndex];

  // ---------------- Result ----------------

  LessonResult getResult() {
    return LessonResult(
      xp: lessonXP + 20,
      correct: correctAnswers,
      wrong: wrongAnswers,
      heartsLeft: hearts,
    );
  }
}

class AnswerResult {
  final bool outOfHearts;

  const AnswerResult({
    required this.outOfHearts,
  });
}