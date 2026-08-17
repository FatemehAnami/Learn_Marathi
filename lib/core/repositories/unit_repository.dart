import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/unit.dart';
import '../models/lesson.dart';

class UnitRepository {
  /// Load an entire unit from assets
  
  Future<Unit> loadUnit(int unitId) async {
    final jsonString = await rootBundle.loadString(
      'assets/units/unit$unitId.json',
    );

    final List<dynamic> jsonList =
        jsonDecode(jsonString);

    final Map<String, dynamic> unitJson =
        jsonList.firstWhere(
      (unit) => unit["unit"] == unitId,
    );

    return Unit.fromJson(unitJson);
  }

  /// Load a single lesson from a unit
  Future<Lesson> loadLesson({
    required int unitId,
    required int lessonId,
  }) async {
    final unit = await loadUnit(unitId);

    return unit.lessons.firstWhere(
      (lesson) => lesson.id == lessonId,
    );
  }
}