import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String heartsKey = "hearts";
  static const String xpKey = "xp";

  static const int maxHearts = 5;

  static const String streakKey = "streak";
  static const String lastPracticeKey = "last_practice";

  // ---------------- Hearts ----------------

  Future<int> getHearts() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(heartsKey) ?? maxHearts;
  }

  Future<void> setHearts(int hearts) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      heartsKey,
      hearts,
    );
  }

  Future<void> loseHeart() async {
    final prefs =
        await SharedPreferences.getInstance();

    int hearts =
        prefs.getInt(heartsKey) ?? maxHearts;

    if (hearts > 0) {
      hearts--;
    }

    await prefs.setInt(
      heartsKey,
      hearts,
    );
  }

  Future<void> resetHearts() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      heartsKey,
      maxHearts,
    );
  }

  // ---------------- XP ----------------

  Future<int> getXP() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(xpKey) ?? 0;
  }

  Future<void> addXP(int amount) async {
    final prefs =
        await SharedPreferences.getInstance();

    int xp =
        prefs.getInt(xpKey) ?? 0;

    xp += amount;

    await prefs.setInt(
      xpKey,
      xp,
    );
  }

  Future<void> resetXP() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      xpKey,
      0,
    );
  }

  // ---------------- Streak ----------------

  Future<int> getStreak() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(streakKey) ?? 0;
  }

  Future<void> updateStreak() async {
    final prefs =
        await SharedPreferences.getInstance();

    final today = DateTime.now();

    final todayString =
        "${today.year}-${today.month}-${today.day}";

    final lastDay =
        prefs.getString(lastPracticeKey);

    if (lastDay == todayString) {
      return;
    }

    int streak =
        prefs.getInt(streakKey) ?? 0;

    streak++;

    await prefs.setInt(
      streakKey,
      streak,
    );

    await prefs.setString(
      lastPracticeKey,
      todayString,
    );
  }

  Future<void> resetStreak() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      streakKey,
      0,
    );
  }

  // ---------------- Lesson Progress ----------------

  String _lessonKey(int unitId, int lessonId) {
    return "completed_unit_${unitId}_lesson_$lessonId";
  }

  Future<void> markLessonCompleted(
    int unitId,
    int lessonId,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final key =
        'completed_unit_${unitId}_lesson_$lessonId';
    print("SAVING KEY: $key");

    await prefs.setBool(key, true);

    print("VALUE AFTER SAVE: ${prefs.getBool(key)}",  );
  }

  Future<bool> isLessonCompleted(
    int unitId,
    int lessonId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          _lessonKey(unitId, lessonId),
        ) ??
        false;
  }

  Future<int> getHighestCompletedLesson(
    int unitId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    int highest = 0;

    for (int lessonId = 1; lessonId <= 100; lessonId++) {
      final key =
        "completed_unit_${unitId}_lesson_$lessonId";

      final completed =
        prefs.getBool(key) ?? false;  
      //final completed = prefs.getBool(
      //      _lessonKey(unitId, lessonId),
      //    ) ??
      //    false;
      print("CHECK -> $key = $completed",);

      if (completed) {
        highest = lessonId;
      } else {
        // Stop at the first incomplete lesson.
        break;
      }
    }

    print(
      "HIGHEST COMPLETED -> "
      "unit=$unitId lesson=$highest",
      );

    return highest;
  }

// ---------------- Course Progress ----------------

  String _unitKey(int unitId) {
    return "completed_unit_$unitId";
  }

  Future<bool> isUnitCompleted(int unitId) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          _unitKey(unitId),
        ) ??
        false;
  }

  Future<void> markUnitCompleted(int unitId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _unitKey(unitId),
      true,
    );
  }

  Future<bool> isUnitUnlocked(int unitId) async {
    // Unit 1 is always unlocked.
    if (unitId == 1) {
      return true;
    }

    // Every other unit requires the previous
    // unit to be completed.
    return isUnitCompleted(unitId - 1);
  }
}