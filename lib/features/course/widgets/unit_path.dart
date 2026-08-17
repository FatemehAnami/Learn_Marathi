import 'package:flutter/material.dart';

import '../../../core/models/unit.dart';

class UnitPath extends StatelessWidget {
  final List<Unit> units;

  final bool Function(Unit unit) isUnitUnlocked;

  final void Function(Unit unit) onUnitPressed;

  const UnitPath({
    super.key,
    required this.units,
    required this.isUnitUnlocked,
    required this.onUnitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 35,
        bottom: 60,
      ),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];

        return UnitNode(
          unit: unit,
          unlocked: isUnitUnlocked(unit),
          index: index,
          isLast: index == units.length - 1,
          onPressed: () {
            onUnitPressed(unit);
          },
        );
      },
    );
  }
}


// =====================================================
// UNIT NODE
// =====================================================

class UnitNode extends StatelessWidget {
  final Unit unit;
  final bool unlocked;
  final int index;
  final bool isLast;
  final VoidCallback onPressed;

  const UnitNode({
    super.key,
    required this.unit,
    required this.unlocked,
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
          // Connecting zig-zag path
          if (!isLast)
            Positioned.fill(
              child: CustomPaint(
                painter: _UnitPathPainter(
                  moveLeft: moveLeft,
                ),
              ),
            ),

          // Unit node
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
                  _buildUnitNode(),

                  const SizedBox(height: 8),

                  Text(
                    "Unit ${unit.id}",
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

          // START label
          if (index == 0 && unlocked)
            Positioned(
              top: -5,
              left: moveLeft ? 35 : null,
              right: moveLeft ? null : 35,
              child: const _StartBubble(),
            ),
        ],
      ),
    );
  }

  // ===================================================
  // CIRCULAR UNIT NODE
  // ===================================================

  Widget _buildUnitNode() {
    return GestureDetector(
      onTap: unlocked ? onPressed : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: unlocked
              ? const Color(0xFF7B1FA2)
              : Colors.grey.shade400,
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
            color: unlocked
                ? const Color(0xFFD65AFF)
                : Colors.grey.shade300,
          ),
          child: Center(
            child: unlocked
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      unit.title,
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
                    size: 32,
                    color: Colors.white,
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

class _UnitPathPainter extends CustomPainter {
  final bool moveLeft;

  _UnitPathPainter({
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
    covariant _UnitPathPainter oldDelegate,
  ) {
    return oldDelegate.moveLeft != moveLeft;
  }
}


// =====================================================
// START BUBBLE
// =====================================================

class _StartBubble extends StatelessWidget {
  const _StartBubble();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "START",
            style: TextStyle(
              color: Color(0xFFD65AFF),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(16, 8),
          painter: _BubbleArrowPainter(),
        ),
      ],
    );
  }
}


// =====================================================
// BUBBLE ARROW
// =====================================================

class _BubbleArrowPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(
      size.width / 2,
      size.height,
    );
    path.lineTo(
      size.width,
      0,
    );
    path.close();

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _BubbleArrowPainter oldDelegate,
  ) {
    return false;
  }
}