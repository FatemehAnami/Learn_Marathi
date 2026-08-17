import 'package:flutter/material.dart';

import '../../core/models/unit.dart';
import '../../core/repositories/unit_repository.dart';
import '../../core/services/progress_service.dart';
import 'unit_lessons_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() =>
      _CourseScreenState();
}

class _CourseScreenState
    extends State<CourseScreen> {
  final UnitRepository _repository =
      UnitRepository();

  final ProgressService _progress =
      ProgressService();

  late Future<List<Unit>> _unitsFuture;

  @override
  void initState() {
    super.initState();

    _unitsFuture = _loadUnits();
  }

  // =====================================================
  // LOAD UNITS
  // =====================================================

  Future<List<Unit>> _loadUnits() async {
    final List<Unit> units = [];

    const totalUnits = 12;

    for (int unitId = 1;
        unitId <= totalUnits;
        unitId++) {
      try {
        final unit =
            await _repository.loadUnit(unitId);

        units.add(unit);
      } catch (e) {
        debugPrint(
          "Could not load unit $unitId: $e",
        );
      }
    }

    return units;
  }

  // =====================================================
  // CHECK UNIT UNLOCK
  // =====================================================

  Future<bool> _isUnitUnlocked(
    int unitId,
  ) async {
    return await _progress.isUnitUnlocked(
      unitId,
    );
  }

  // =====================================================
  // OPEN UNIT
  // =====================================================

  Future<void> _openUnit(
    Unit unit,
  ) async {
    final unlocked =
        await _isUnitUnlocked(unit.id);

    if (!unlocked) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            UnitLessonsScreen(
          unit: unit,
        ),
      ),
    );

    // Refresh after returning from unit.
    if (mounted) {
      setState(() {});
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF9F9FB),

      appBar: AppBar(
        title: const Text(
          "My Course",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Unit>>(
        future: _unitsFuture,

        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading units:\n"
                "${snapshot.error}",
                textAlign:
                    TextAlign.center,
              ),
            );
          }

          final units =
              snapshot.data ?? [];

          if (units.isEmpty) {
            return const Center(
              child: Text(
                "No units found.",
              ),
            );
          }

          return _RoadMap(
            units: units,
            onUnitPressed: _openUnit,
            isUnitUnlocked:
                _isUnitUnlocked,
          );
        },
      ),
    );
  }
}

// =========================================================
// ROADMAP
// =========================================================

class _RoadMap extends StatelessWidget {
  final List<Unit> units;

  final Future<void> Function(Unit)
      onUnitPressed;

  final Future<bool> Function(int)
      isUnitUnlocked;

  const _RoadMap({
    required this.units,
    required this.onUnitPressed,
    required this.isUnitUnlocked,
  });

  static const double nodeSize = 110;

  static const double rowHeight = 190;

  @override
  Widget build(
    BuildContext context,
  ) {
    final totalHeight =
        units.length * rowHeight + 80;

    return FutureBuilder<List<bool>>(
      future: Future.wait(
        units.map(
          (unit) =>
              isUnitUnlocked(unit.id),
        ),
      ),

      builder: (
        context,
        snapshot,
      ) {
        if (!snapshot.hasData) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        final unlocked =
            snapshot.data!;

        return LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            return SingleChildScrollView(
              child: SizedBox(
                height: totalHeight,
                width:
                    constraints.maxWidth,

                child: Stack(
                  children: [
                    // -----------------------------------
                    // CONNECTING ROAD
                    // -----------------------------------

                    Positioned.fill(
                      child: CustomPaint(
                        painter:
                            _RoadPainter(
                          itemCount:
                              units.length,
                          nodeSize:
                              nodeSize,
                          rowHeight:
                              rowHeight,
                        ),
                      ),
                    ),

                    // -----------------------------------
                    // UNIT NODES
                    // -----------------------------------

                    for (
                      int index = 0;
                      index < units.length;
                      index++
                    )
                      _buildNode(
                        context,
                        units[index],
                        index,
                        unlocked[index],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =====================================================
  // NODE
  // =====================================================

  Widget _buildNode(
    BuildContext context,
    Unit unit,
    int index,
    bool unlocked,
  ) {
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
                    onUnitPressed(unit);
                  }
                : null,

            child: _UnitCircle(
              unit: unit,
              unlocked: unlocked,
              isFirst: index == 0,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: nodeSize + 30,

            child: Text(
              "Unit ${unit.id}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
                color: unlocked
                    ? Colors.black87
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// UNIT CIRCLE
// =========================================================

class _UnitCircle
    extends StatelessWidget {
  final Unit unit;
  final bool unlocked;
  final bool isFirst;

  const _UnitCircle({
    required this.unit,
    required this.unlocked,
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
          width: 110,
          height: 110,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            gradient: unlocked
                ? const LinearGradient(
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      Color(0xFFD94CFF),
                      Color(0xFFB84DDE),
                    ],
                  )
                : const LinearGradient(
                    begin:
                        Alignment.topLeft,
                    end:
                        Alignment.bottomRight,
                    colors: [
                      Color(0xFFE0E0E0),
                      Color(0xFFCFCFCF),
                    ],
                  ),

            border: Border.all(
              color: unlocked
                  ? const Color(
                      0xFF8120A8,
                    )
                  : const Color(
                      0xFFB8B8B8,
                    ),
              width: 7,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 7,
                offset: Offset(0, 5),
              ),
            ],
          ),

          child: Center(
            child: unlocked
                ? Padding(
                    padding:
                        const EdgeInsets.all(
                      10,
                    ),
                    child: Text(
                      unit.title,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 34,
                  ),
          ),
        ),

        // -----------------------------------------------
        // START LABEL
        // -----------------------------------------------

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
                    BorderRadius.circular(
                  8,
                ),
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

class _RoadPainter
    extends CustomPainter {
  final int itemCount;
  final double nodeSize;
  final double rowHeight;

  _RoadPainter({
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
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

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

      final path = Path();

      path.moveTo(
        startX,
        startY - 5,
      );

      final double middleY =
          (startY + endY) / 2;

      // Smooth horizontal/vertical
      // transition like the reference image.
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
    covariant _RoadPainter oldDelegate,
  ) {
    return oldDelegate.itemCount !=
            itemCount ||
        oldDelegate.nodeSize !=
            nodeSize ||
        oldDelegate.rowHeight !=
            rowHeight;
  }
}