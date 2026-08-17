import '../repositories/unit_repository.dart';
import '../models/lesson.dart';

class LessonService {
  final UnitRepository _repository =
      UnitRepository();

  Future<Lesson> getLesson({
    required int unitNumber,
    required int lessonNumber,
  }) {
    return _repository.loadLesson(
      unitId: unitNumber,
      lessonId: lessonNumber,
    );
  }
}