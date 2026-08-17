import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';
import 'lesson_node.dart';

class UnitLessonPath extends StatelessWidget {
  final List<Lesson> lessons;
  final bool unitUnlocked;
  final int highestCompletedLesson;

  final bool Function(Lesson lesson) isLessonUnlocked;

  final Future<void> Function(Lesson lesson)
      onLessonPressed;

  const UnitLessonPath({
    super.key,
    required this.lessons,
    required this.unitUnlocked,
    required this.highestCompletedLesson,
    required this.isLessonUnlocked,
    required this.onLessonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 35,
        bottom: 60,
      ),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];

        final unlocked =
            isLessonUnlocked(lesson);

        final completed =
            unitUnlocked &&
            lesson.id <= highestCompletedLesson;

        return LessonNode(
          lesson: lesson,
          unlocked: unlocked,
          completed: completed,
          index: index,
          isLast: index == lessons.length - 1,
          onPressed: () {
            onLessonPressed(lesson);
          },
        );
      },
    );
  }
}