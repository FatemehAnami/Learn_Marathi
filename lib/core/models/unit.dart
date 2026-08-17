import 'lesson.dart';

class Unit {
  final int id;
  final String title;
  final List<Lesson> lessons;

  const Unit({
    required this.id,
    required this.title,
    required this.lessons,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json["unit"] as int,
      title: json["title"] as String,
      lessons: (json["lessons"] as List)
          .map(
            (e) => Lesson.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "unit": id,
      "title": title,
      "lessons": lessons
          .map((e) => e.toJson())
          .toList(),
    };
  }
}