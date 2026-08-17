import 'dart:math';

import '../models/word.dart';
import '../models/lesson.dart';
import '../models/question.dart';

class LessonEngine {
  List<Question> build(Lesson lesson) {
    final random = Random();
    final Map<String, Set<QuestionType>> usedReviewTypes = {};
    final List<Question> lessonQuestions = [];

    // ==========================================
    // UNIT REVIEW
    // ==========================================

    if (lesson.id == 5) {
      final List<Word> reviewWords = List.from(lesson.words);

      reviewWords.shuffle(random);

      final reviewTypes = [
        QuestionType.vocabularyMultipleChoice,
        QuestionType.vocabularyListening,
        QuestionType.vocabularyMatch,
        QuestionType.sentenceMultipleChoice,
        QuestionType.sentenceFillBlank,
        QuestionType.sentenceBuild,
      ];

      for (int i = 0; i < reviewWords.length && i < 10; i++) {
        final word = reviewWords[i];

        final type = reviewTypes[
          i % reviewTypes.length
        ];

        lessonQuestions.add(
          Question(
            type: type,
            word: word,
          ),
        );
      }

      lessonQuestions.add(
        Question(
          type: QuestionType.finalReview,
        ),
      );

      return lessonQuestions;
    }

    // ==========================================
    // NORMAL LESSON
    // ==========================================

    final List<Word> learnedWords = [];

    for (final word in lesson.words) {
      // ---------------------------------------------
      // 1. Learn the new word
      // ---------------------------------------------

      lessonQuestions.add(
        Question(
          type: QuestionType.learn,
          word: word,
        ),
      );

      // Add word to learned pool
      learnedWords.add(word);

      // Make sure this word has a tracking set
      usedReviewTypes.putIfAbsent(
        word.id,
        () => <QuestionType>{},
      );

      // ---------------------------------------------
      // 2. Generate up to 3 review questions
      // ---------------------------------------------

      for (int i = 0; i < 3; i++) {
        if (learnedWords.isEmpty) {
          break;
        }

        // Find words that still have at least one
        // unused review type.
        final availableWords = learnedWords
            .where(
              (reviewWord) =>
                  _hasAvailableReviewType(
                reviewWord,
                usedReviewTypes,
              ),
            )
            .toList();

        // If every learned word has already used
        // every review type, stop generating.
        if (availableWords.isEmpty) {
          break;
        }

        // Pick a random word from the available pool.
        final reviewWord =
            availableWords[
              random.nextInt(
                availableWords.length,
              )
            ];

        // Pick a review type that this word has
        // NOT used before.
        final reviewType =
            _randomUnusedQuestionType(
          reviewWord,
          usedReviewTypes,
          random,
        );

        // Remember this combination.
        usedReviewTypes[
          reviewWord.id
        ]!.add(reviewType);

        // Add question.
        lessonQuestions.add(
          Question(
            type: reviewType,
            word: reviewWord,
          ),
        );
      }
    }

    // =====================================================
    // FINAL REVIEW
    // =====================================================

    for (int i = 0; i < 4; i++) {
      final availableWords = lesson.words
          .where(
            (word) =>
                _hasAvailableReviewType(
              word,
              usedReviewTypes,
            ),
          )
          .toList();

      // No more unique word + review combinations.
      if (availableWords.isEmpty) {
        break;
      }

      final reviewWord =
          availableWords[
            random.nextInt(
              availableWords.length,
            )
          ];

      final reviewType =
          _randomUnusedQuestionType(
        reviewWord,
        usedReviewTypes,
        random,
      );

      // Remember the combination.
      usedReviewTypes[
        reviewWord.id
      ]!.add(reviewType);

      lessonQuestions.add(
        Question(
          type: reviewType,
          word: reviewWord,
        ),
      );
    }

    // =====================================================
    // FINAL REVIEW SCREEN
    // =====================================================

    lessonQuestions.add(
      Question(
        type: QuestionType.finalReview,
      ),
    );

    return lessonQuestions;
  }

  List<Question> buildUnitReview(
    List<Word> unitWords,
  ) {
    final random = Random();

    // Make a copy so we don't modify the original
    final words = [...unitWords];

    // Randomize the 16 words
    words.shuffle(random);

    // Select exactly 10 different words
    final selectedWords = words.take(10).toList();

    final questions = <Question>[];

    for (final word in selectedWords) {
      questions.add(
        Question(
          type: _randomQuestionType(random),
          word: word,
        ),
      );
    }

    // End of review
    questions.add(
      Question(
        type: QuestionType.finalReview,
      ),
    );

    return questions;
  }



  // =====================================================
  // ALL REVIEW TYPES
  // =====================================================

  List<QuestionType> _reviewTypes() {
    return [
      QuestionType.vocabularyMultipleChoice,
      QuestionType.vocabularyListening,
      QuestionType.vocabularyMatch,
      QuestionType.sentenceMultipleChoice,
      QuestionType.sentenceFillBlank,
      QuestionType.sentenceBuild,
    ];
  }

  // =====================================================
  // CHECK IF WORD HAS UNUSED REVIEW TYPE
  // =====================================================

  bool _hasAvailableReviewType(
    Word word,
    Map<String, Set<QuestionType>> usedReviewTypes,
  ) {
    final used =
        usedReviewTypes[word.id] ??
            <QuestionType>{};

    return _reviewTypes().any(
      (type) => !used.contains(type),
    );
  }

  // =====================================================
  // GET RANDOM UNUSED REVIEW TYPE
  // =====================================================

  QuestionType _randomUnusedQuestionType(
    Word word,
    Map<String, Set<QuestionType>> usedReviewTypes,
    Random random,
  ) {
    final types = [
      QuestionType.vocabularyMultipleChoice,
      QuestionType.vocabularyListening,
      QuestionType.vocabularyMatch,
      QuestionType.sentenceMultipleChoice,
      QuestionType.sentenceFillBlank,
      QuestionType.sentenceBuild,
    ];

    // Get the review types already used for this word.
    final usedTypes = usedReviewTypes.putIfAbsent(
      word.id,
      () => <QuestionType>{},
    );

    // Find types that haven't been used for this word.
    final unusedTypes = types
        .where((type) => !usedTypes.contains(type))
        .toList();

    // If every review type has already been used,
    // allow the types to start again.
    if (unusedTypes.isEmpty) {
      usedTypes.clear();
      return types[random.nextInt(types.length)];
    }

    // Pick one unused type.
    final selected =
        unusedTypes[random.nextInt(unusedTypes.length)];

    // Remember that this type was used for this word.
    usedTypes.add(selected);

    return selected;
  }

  QuestionType _randomQuestionType(Random random) {
    final types = [
      QuestionType.vocabularyMultipleChoice,
      QuestionType.vocabularyListening,
      QuestionType.vocabularyMatch,
      QuestionType.sentenceMultipleChoice,
      QuestionType.sentenceFillBlank,
      QuestionType.sentenceBuild,
    ];

    return types[random.nextInt(types.length)];
  }
}