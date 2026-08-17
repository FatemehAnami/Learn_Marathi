class LessonResult {
  final int xp;
  final int correct;
  final int wrong;
  final int heartsLeft;

  const LessonResult({
    required this.xp,
    required this.correct,
    required this.wrong,
    required this.heartsLeft,
  });

  int get total => correct + wrong;

  double get accuracy {
    if (total == 0) return 0;
    return correct / total;
  }

  String get rating {
    final value = accuracy * 100;

    if (value >= 95) {
      return "⭐⭐⭐ Excellent";
    }

    if (value >= 80) {
      return "⭐⭐ Great";
    }

    if (value >= 60) {
      return "⭐ Good";
    }

    return "Keep Practicing 💪";
  }
}