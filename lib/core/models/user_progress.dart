class UserProgress {
  final int xp;
  final int hearts;
  final int streak;
  final int currentLesson;

  const UserProgress({
    required this.xp,
    required this.hearts,
    required this.streak,
    required this.currentLesson,
  });

  UserProgress copyWith({
    int? xp,
    int? hearts,
    int? streak,
    int? currentLesson,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      hearts: hearts ?? this.hearts,
      streak: streak ?? this.streak,
      currentLesson: currentLesson ?? this.currentLesson,
    );
  }
}