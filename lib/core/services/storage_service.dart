import 'package:shared_preferences/shared_preferences.dart';

import '../storage/preference_keys.dart';

class StorageService {
  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<void> saveXp(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(PreferenceKeys.xp, value);
  }

  Future<int> getXp() async {
    final prefs = await _prefs;
    return prefs.getInt(PreferenceKeys.xp) ?? 0;
  }

  Future<void> saveHearts(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(PreferenceKeys.hearts, value);
  }

  Future<int> getHearts() async {
    final prefs = await _prefs;
    return prefs.getInt(PreferenceKeys.hearts) ?? 5;
  }

  Future<void> saveCurrentLesson(int lesson) async {
    final prefs = await _prefs;
    await prefs.setInt(
      PreferenceKeys.currentLesson,
      lesson,
    );
  }

  Future<int> getCurrentLesson() async {
    final prefs = await _prefs;
    return prefs.getInt(
          PreferenceKeys.currentLesson,
        ) ??
        1;
  }
}