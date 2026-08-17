import 'word.dart';

enum QuestionType {
  learn,

  vocabularyMultipleChoice,
  vocabularyListening,
  vocabularyMatch,

  sentenceMultipleChoice,
  sentenceFillBlank,
  sentenceBuild,

  finalReview,
}

class Question {
  final QuestionType type;

  final Word? word;

  const Question({
    required this.type,
    this.word,
  });
}