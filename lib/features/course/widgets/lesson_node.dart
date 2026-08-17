import 'package:flutter/material.dart';

import '../../../core/models/lesson.dart';

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final bool unlocked;
  final bool completed;
  final int index;
  final bool isLast;
  final VoidCallback onPressed;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.unlocked,
    required this.completed,
    required this.index,
    required this.isLast,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool moveLeft = index.isOdd;

    return SizedBox(
      height: 155,
      child: Stack(
        children: [
          // Connecting zig-zag line
          if (!isLast)
            Positioned.fill(
              child: CustomPaint(
                painter: _LessonPathPainter(
                  moveLeft: moveLeft,
                ),
              ),
            ),

          // Lesson node
          Align(
            alignment: moveLeft
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 55,
              ),
              child: Column(
                children: [
                  _buildNode(),

                  const SizedBox(height: 8),

                  Text(
                    "Lesson ${lesson.id}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: unlocked
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode() {
    final Color outerColor;

    if (completed) {
      outerColor = const Color(0xFF43A047);
    } else if (unlocked) {
      outerColor = const Color(0xFF7B1FA2);
    } else {
      outerColor = Colors.grey.shade400;
    }

    final Color innerColor;

    if (completed) {
      innerColor = const Color(0xFF66BB6A);
    } else if (unlocked) {
      innerColor = const Color(0xFFD65AFF);
    } else {
      innerColor = Colors.grey.shade300;
    }

    return GestureDetector(
      onTap: unlocked ? onPressed : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: outerColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 6,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: innerColor,
          ),
          child: Center(
            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 38,
                  )
                : unlocked
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          lesson.title,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 32,
                      ),
          ),
        ),
      ),
    );
  }
}


// =====================================================
// ZIG-ZAG PATH
// =====================================================

class _LessonPathPainter extends CustomPainter {
  final bool moveLeft;

  _LessonPathPainter({
    required this.moveLeft,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE0C8E8);

    final leftX = size.width * 0.28;
    final rightX = size.width * 0.72;

    final startX =
        moveLeft ? rightX : leftX;

    final endX =
        moveLeft ? leftX : rightX;

    final path = Path();

    path.moveTo(
      startX,
      65,
    );

    path.cubicTo(
      startX,
      105,
      endX,
      40,
      endX,
      125,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _LessonPathPainter oldDelegate,
  ) {
    return oldDelegate.moveLeft != moveLeft;
  }
}