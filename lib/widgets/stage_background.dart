import 'dart:math';

import 'package:flutter/material.dart';

class StageBackground extends StatefulWidget {
  final int stage;

  const StageBackground({
    super.key,
    required this.stage,
  });

  @override
  State<StageBackground> createState() => _StageBackgroundState();
}

class _StageBackgroundState extends State<StageBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // MAIN STAGE COLORS
  // ============================================================

  Color get backgroundColor {
    switch (widget.stage) {
      case 0:
        return const Color(0xFF030405);

      // 1 — Dark Violet
      case 1:
        return const Color(0xFF180A24);

      // 2 — Deep Blue
      case 2:
        return const Color(0xFF071A3D);

      // 3 — Dark Crimson
      case 3:
        return const Color(0xFF260B13);

      // 4 — Storm Blue
      case 4:
        return const Color(0xFF122637);

      // 5 — Midnight Navy
      case 5:
        return const Color(0xFF060E2A);

      // 6 — Deep Forest
      case 6:
        return const Color(0xFF0B211A);

      // 7 — Dark Plum
      case 7:
        return const Color(0xFF241127);

      // 8 — Almost Black
      case 8:
        return const Color(0xFF020304);

      // 9 — Final
      case 9:
        return const Color(0xFF080605);

      default:
        return const Color(0xFF030405);
    }
  }

  // ============================================================
  // STAGE GLOW COLORS
  // ============================================================

  Color get glowColor {
    switch (widget.stage) {
      case 1:
        return const Color(0xFF9B52C4);

      case 2:
        return const Color(0xFF3C78D8);

      case 3:
        return const Color(0xFFA83245);

      case 4:
        return const Color(0xFF527EA3);

      case 5:
        return const Color(0xFF3D66C0);

      case 6:
        return const Color(0xFF3D8B68);

      case 7:
        return const Color(0xFFA05EAD);

      case 8:
        return const Color(0xFF5E6470);

      case 9:
        return const Color(0xFF9A7558);

      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeInOutCubic,

      decoration: BoxDecoration(
        color: backgroundColor,

        gradient: RadialGradient(
          center: const Alignment(0, -0.20),
          radius: 1.3,

          colors: [
            glowColor.withValues(alpha: 0.20),
            backgroundColor,
          ],
        ),
      ),

      child: Stack(
        fit: StackFit.expand,
        children: [
          // ==========================================================
          // STAGE 1 — MYSTERY
          // ==========================================================

          if (widget.stage == 1)
            const _MysteryAtmosphere(),

          // ==========================================================
          // STAGE 2 — STARS
          // ==========================================================

          if (widget.stage >= 2 && widget.stage <= 5)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _StarsPainter(
                    progress: _animationController.value,
                    density:
                        widget.stage >= 5 ? 110 : 60,
                  ),
                );
              },
            ),

          // ==========================================================
          // STAGE 3 — MOUNTAINS
          // ==========================================================

          if (widget.stage >= 3 && widget.stage <= 6)
            const Positioned.fill(
              child: CustomPaint(
                painter: _MountainPainter(),
              ),
            ),

          // ==========================================================
          // STAGE 4 — RAIN
          // ==========================================================

          if (widget.stage == 4)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RainPainter(
                    progress: _animationController.value,
                  ),
                );
              },
            ),

          // ==========================================================
          // STAGE 5 — MOON
          // ==========================================================

          if (widget.stage == 5)
            const _Moon(),

          // ==========================================================
          // STAGE 6 — TRAIL
          // ==========================================================

          if (widget.stage >= 6 && widget.stage <= 7)
            const Positioned.fill(
              child: CustomPaint(
                painter: _TrailPainter(),
              ),
            ),

          // ==========================================================
          // STAGE 7 — POETIC LIGHT
          // ==========================================================

          if (widget.stage == 7)
            const _PoeticAtmosphere(),

          // ==========================================================
          // STAGE 8 — ANALYSIS
          // ==========================================================

          if (widget.stage == 8)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return _AnalysisAtmosphere(
                  progress: _animationController.value,
                );
              },
            ),

          // ==========================================================
          // STAGE 9 — FINAL WARM LIGHT
          // ==========================================================

          if (widget.stage == 9)
            const _FinalAtmosphere(),
        ],
      ),
    );
  }
}

// ======================================================================
// MYSTERY ATMOSPHERE
// ======================================================================

class _MysteryAtmosphere extends StatelessWidget {
  const _MysteryAtmosphere();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 450,
        height: 450,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFB35DDA).withValues(alpha: 0.15),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================================
// STARS
// ======================================================================

class _StarsPainter extends CustomPainter {
  final double progress;
  final int density;

  _StarsPainter({
    required this.progress,
    required this.density,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);

    for (int i = 0; i < density; i++) {
      final x = random.nextDouble() * size.width;

      final y =
          random.nextDouble() * size.height * 0.80;

      final pulse =
          0.4 +
          (sin(progress * 2 * pi + i) + 1) * 0.30;

      final radius =
          0.7 + random.nextDouble() * 1.5;

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: 0.10 + pulse * 0.55,
        );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _StarsPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.density != density;
  }
}

// ======================================================================
// MOUNTAINS
// ======================================================================

class _MountainPainter extends CustomPainter {
  const _MountainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // BACK MOUNTAIN
    final backPaint = Paint()
      ..color = const Color(0xFF08121F);

    final back = Path();

    back.moveTo(0, size.height * 0.84);

    back.lineTo(
      size.width * 0.20,
      size.height * 0.62,
    );

    back.lineTo(
      size.width * 0.34,
      size.height * 0.77,
    );

    back.lineTo(
      size.width * 0.52,
      size.height * 0.52,
    );

    back.lineTo(
      size.width * 0.70,
      size.height * 0.77,
    );

    back.lineTo(
      size.width * 0.84,
      size.height * 0.60,
    );

    back.lineTo(
      size.width,
      size.height * 0.77,
    );

    back.lineTo(
      size.width,
      size.height,
    );

    back.lineTo(
      0,
      size.height,
    );

    back.close();

    canvas.drawPath(back, backPaint);

    // FRONT MOUNTAIN
    final frontPaint = Paint()
      ..color = const Color(0xFF132438);

    final front = Path();

    front.moveTo(0, size.height * 0.91);

    front.lineTo(
      size.width * 0.18,
      size.height * 0.72,
    );

    front.lineTo(
      size.width * 0.32,
      size.height * 0.85,
    );

    front.lineTo(
      size.width * 0.48,
      size.height * 0.60,
    );

    front.lineTo(
      size.width * 0.65,
      size.height * 0.84,
    );

    front.lineTo(
      size.width * 0.82,
      size.height * 0.69,
    );

    front.lineTo(
      size.width,
      size.height * 0.86,
    );

    front.lineTo(
      size.width,
      size.height,
    );

    front.lineTo(
      0,
      size.height,
    );

    front.close();

    canvas.drawPath(front, frontPaint);
  }

  @override
  bool shouldRepaint(
    covariant _MountainPainter oldDelegate,
  ) {
    return false;
  }
}

// ======================================================================
// RAIN
// ======================================================================

class _RainPainter extends CustomPainter {
  final double progress;

  _RainPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(100);

    final paint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 180; i++) {
      final x =
          random.nextDouble() * size.width;

      final initialY =
          random.nextDouble() * size.height;

      final movement =
          progress * size.height * 1.5;

      final y =
          (initialY + movement) % size.height;

      paint.color = Colors.white.withValues(
        alpha: 0.08 +
            random.nextDouble() * 0.22,
      );

      canvas.drawLine(
        Offset(x, y),
        Offset(x - 5, y + 22),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _RainPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}

// ======================================================================
// MOON
// ======================================================================

class _Moon extends StatelessWidget {
  const _Moon();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65,
      right: 80,

      child: Container(
        width: 70,
        height: 70,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: const Color(0xFFE4E8F1),

          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB7D1FF)
                  .withValues(alpha: 0.30),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// TRAIL
// ======================================================================

class _TrailPainter extends CustomPainter {
  const _TrailPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF789C86)
          .withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(
      size.width * 0.50,
      size.height,
    );

    path.cubicTo(
      size.width * 0.38,
      size.height * 0.84,
      size.width * 0.64,
      size.height * 0.73,
      size.width * 0.48,
      size.height * 0.59,
    );

    path.cubicTo(
      size.width * 0.38,
      size.height * 0.49,
      size.width * 0.58,
      size.height * 0.39,
      size.width * 0.50,
      size.height * 0.27,
    );

    canvas.drawPath(path, paint);

    final glow = Paint()
      ..color = const Color(0xFFD5E7D9)
          .withValues(alpha: 0.40)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        25,
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.50,
        size.height * 0.27,
      ),
      7,
      glow,
    );
  }

  @override
  bool shouldRepaint(
    covariant _TrailPainter oldDelegate,
  ) {
    return false;
  }
}

// ======================================================================
// POETIC ATMOSPHERE
// ======================================================================

class _PoeticAtmosphere extends StatelessWidget {
  const _PoeticAtmosphere();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFD087E1)
                  .withValues(alpha: 0.14),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================================
// ANALYSIS
// ======================================================================

class _AnalysisAtmosphere extends StatelessWidget {
  final double progress;

  const _AnalysisAtmosphere({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final size = 100 + progress * 100;

    return Center(
      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          border: Border.all(
            color: const Color(0xFFA8C7FF)
                .withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}

// ======================================================================
// FINAL ATMOSPHERE
// ======================================================================

class _FinalAtmosphere extends StatelessWidget {
  const _FinalAtmosphere();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 350,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          gradient: RadialGradient(
            colors: [
              const Color(0xFFD39B6A)
                  .withValues(alpha: 0.10),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}