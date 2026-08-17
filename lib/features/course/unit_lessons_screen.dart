import 'package:flutter/material.dart';

import '../../core/models/unit.dart';
import '../../core/models/lesson.dart';
import '../../core/services/progress_service.dart';
import '../lesson/lesson_screen.dart';

class UnitLessonsScreen extends StatefulWidget {
  final Unit unit;

  const UnitLessonsScreen({
    super.key,
    required this.unit,
  });

  @override
  State<UnitLessonsScreen> createState() =>
      _UnitLessonsScreenState();
}

class _UnitLessonsScreenState
    extends State<UnitLessonsScreen> {
  final ProgressService _progress =
      ProgressService();

  int highestCompletedLesson = 0;
  bool unitUnlocked = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _loadProgress();
  }

  List<Lesson> _getDisplayLessons() {
    final lessons = [
      ...widget.unit.lessons,
    ];

    // Only add Unit Review after Lesson 4
    if (lessons.length >= 4) {
      final reviewWords = lessons
          .take(4)
          .expand((lesson) => lesson.words)
          .toList();

      lessons.add(
        Lesson(
          id: 5,
          title: "Unit Review",
          words: reviewWords,
        ),
      );
    }

    return lessons;
  }

  // =====================================================
  // LOAD PROGRESS
  // =====================================================

  Future<void> _loadProgress() async {
    final unlocked =
        await _progress.isUnitUnlocked(
      widget.unit.id,
    );

    final highest =
        await _progress.getHighestCompletedLesson(
      widget.unit.id,
    );

    debugPrint(
      "UNIT ${widget.unit.id} -> "
      "highest completed lesson = $highest",
    );

    if (!mounted) return;

    setState(() {
      unitUnlocked = unlocked;
      highestCompletedLesson = highest;
      loading = false;
    });
  }

  // =====================================================
  // LESSON UNLOCK
  // =====================================================

  bool isLessonUnlocked(
    Lesson lesson,
  ) {
    if (!unitUnlocked) {
      return false;
    }

    if (lesson.id == 1) {
      return true;
    }

    return lesson.id <=
        highestCompletedLesson + 1;
  }

  // =====================================================
  // OPEN LESSON
  // =====================================================

  Future<void> openLesson(
    Lesson lesson,
  ) async {
    if (!isLessonUnlocked(lesson)) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          unitId: widget.unit.id,
          lessonId: lesson.id,
          lessonOverride: lesson.id == 5
              ? lesson
              : null,
        ),
      ),
    );
    // Reload progress after returning.
    await _loadProgress();
  }

  // =====================================================
  // UI
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFFF9F9FB),

      appBar: AppBar(
        title: Text(
          "Unit ${widget.unit.id}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: _LessonRoadMap(
        lessons: _getDisplayLessons(),
        unitUnlocked: unitUnlocked,
        highestCompletedLesson:
            highestCompletedLesson,
        isLessonUnlocked:
            isLessonUnlocked,
        onLessonPressed:
            openLesson,
      ),
    );
  }
}

// =========================================================
// LESSON ROADMAP
// =========================================================

class _LessonRoadMap extends StatelessWidget {
  final List<Lesson> lessons;

  final bool unitUnlocked;

  final int highestCompletedLesson;

  final bool Function(Lesson)
      isLessonUnlocked;

  final Future<void> Function(Lesson)
      onLessonPressed;

  const _LessonRoadMap({
    required this.lessons,
    required this.unitUnlocked,
    required this.highestCompletedLesson,
    required this.isLessonUnlocked,
    required this.onLessonPressed,
  });

  static const double nodeSize = 105;

  static const double rowHeight = 180;

  @override
  Widget build(
    BuildContext context,
  ) {
    final totalHeight =
        lessons.length * rowHeight + 80;

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: totalHeight,

            child: Stack(
              children: [
                // ---------------------------------------
                // ROAD
                // ---------------------------------------

                Positioned.fill(
                  child: CustomPaint(
                    painter: _LessonRoadPainter(
                      itemCount:
                          lessons.length,
                      nodeSize:
                          nodeSize,
                      rowHeight:
                          rowHeight,
                    ),
                  ),
                ),

                // ---------------------------------------
                // LESSON NODES
                // ---------------------------------------

                for (
                  int index = 0;
                  index < lessons.length;
                  index++
                )
                
                  _buildLessonNode(
                    context,
                    lessons[index],
                    index,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // BUILD NODE
  // =====================================================

  Widget _buildLessonNode(
    BuildContext context,
    Lesson lesson,
    int index,
  ) {
    final unlocked =
        isLessonUnlocked(lesson);

    final completed =
        unitUnlocked &&
        lesson.id <=
            highestCompletedLesson;

    final bool left =
        index.isEven;

    return Positioned(
      top:
          index * rowHeight + 20,

      left: left
          ? 28
          : null,

      right: left
          ? null
          : 28,

      child: Column(
        children: [
          GestureDetector(
            onTap: unlocked
                ? () {
                    onLessonPressed(
                      lesson,
                    );
                  }
                : null,

            child: _LessonCircle(
              lesson: lesson,
              unlocked: unlocked,
              completed: completed,
              isFirst: index == 0,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: nodeSize + 30,

            child: Column(
              children: [
                Text(
                  "Lesson ${lesson.id}",
                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color: unlocked
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  lesson.title,
                  textAlign:
                      TextAlign.center,

                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,
                    color: unlocked
                        ? Colors.black54
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// LESSON CIRCLE
// =========================================================

class _LessonCircle
    extends StatelessWidget {
  final Lesson lesson;
  final bool unlocked;
  final bool completed;
  final bool isFirst;

  const _LessonCircle({
    required this.lesson,
    required this.unlocked,
    required this.completed,
    required this.isFirst,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        Container(
          width: 105,
          height: 105,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

          gradient: completed
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF66BB6A),
                  Color(0xFF43A047),
                ],
              )
            : unlocked
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD94CFF),
                      Color(0xFFB84DDE),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE0E0E0),
                      Color(0xFFCFCFCF),
                    ],
                  ),

            border: Border.all(
              color: completed
                  ? const Color(0xFF2E7D32)
                  : unlocked
                      ? const Color(0xFF8120A8)
                      : const Color(0xFFB8B8B8),
              width: 7,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 7,
                offset:
                    Offset(0, 5),
              ),
            ],
          ),

          child: Center(
            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  )
                : unlocked
                    ? const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 42,
                      )
                    : const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32,
                      ),
          ),
        ),

        // ---------------------------------------------
        // START LABEL
        // ---------------------------------------------

        if (isFirst && unlocked)
          Positioned(
            top: -18,
            right: -18,

            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 9,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(8),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset:
                        Offset(0, 2),
                  ),
                ],
              ),

              child: const Text(
                "START",
                style: TextStyle(
                  color:
                      Color(0xFFD24CFF),
                  fontSize: 15,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// =========================================================
// ROAD PAINTER
// =========================================================

class _LessonRoadPainter
    extends CustomPainter {
  final int itemCount;
  final double nodeSize;
  final double rowHeight;

  _LessonRoadPainter({
    required this.itemCount,
    required this.nodeSize,
    required this.rowHeight,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (itemCount < 2) {
      return;
    }

    final paint = Paint()
      ..color =
          const Color(0xFFDDBCE8)
      ..strokeWidth = 6
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round;

    // The node centers.
    final double leftX =
        28 + nodeSize / 2;

    final double rightX =
        size.width -
        28 -
        nodeSize / 2;

    for (
      int index = 0;
      index < itemCount - 1;
      index++
    ) {
      final bool currentLeft =
          index.isEven;

      final double startX =
          currentLeft
              ? leftX
              : rightX;

      final double endX =
          currentLeft
              ? rightX
              : leftX;

      final double startY =
          index * rowHeight +
          20 +
          nodeSize;

      final double endY =
          (index + 1) * rowHeight +
          20;

      final double middleY =
          (startY + endY) / 2;

      final path = Path();

      path.moveTo(
        startX,
        startY - 5,
      );

      path.cubicTo(
        startX,
        middleY,
        endX,
        middleY,
        endX,
        endY + 5,
      );

      canvas.drawPath(
        path,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _LessonRoadPainter
        oldDelegate,
  ) {
    return oldDelegate.itemCount !=
            itemCount ||
        oldDelegate.nodeSize !=
            nodeSize ||
        oldDelegate.rowHeight !=
            rowHeight;
  }
}