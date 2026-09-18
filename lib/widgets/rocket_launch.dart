import 'dart:math';
import 'package:flutter/material.dart';

class RocketLaunch extends StatefulWidget {
  final VoidCallback onFinished;

  const RocketLaunch({
    super.key,
    required this.onFinished,
  });

  @override
  State<RocketLaunch> createState() => _RocketLaunchState();
}

class _RocketLaunchState extends State<RocketLaunch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final Random _random = Random();

  late final List<_Spark> sparks;

  @override
  void initState() {
    super.initState();

    sparks = List.generate(
      28,
      (_) => _Spark(
        angle: _random.nextDouble() * pi * 2,
        distance: 25 + _random.nextDouble() * 80,
        size: 1.2 + _random.nextDouble() * 3,
        speed: 0.5 + _random.nextDouble() * 0.5,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _controller.forward().whenComplete(() {
      if (mounted) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = Curves.easeInCubic.transform(
            _controller.value,
          );

          return CustomPaint(
            painter: _RocketPainter(
              progress: progress,
              sparks: sparks,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Spark {
  final double angle;
  final double distance;
  final double size;
  final double speed;

  _Spark({
    required this.angle,
    required this.distance,
    required this.size,
    required this.speed,
  });
}

class _RocketPainter extends CustomPainter {
  final double progress;
  final List<_Spark> sparks;

  _RocketPainter({
    required this.progress,
    required this.sparks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Rocket launches from the lower-middle area.
    final startX = size.width / 2;
    final startY = size.height * 0.58;

    // ------------------------------------------------------------
    // SPARK BURST
    // ------------------------------------------------------------

    final sparkProgress = (progress * 3.0).clamp(0.0, 1.0);
    final sparkOpacity = (1.0 - sparkProgress).clamp(0.0, 1.0);

    for (final spark in sparks) {
      final distance =
          spark.distance * Curves.easeOut.transform(sparkProgress);

      final dx = cos(spark.angle) * distance;
      final dy = sin(spark.angle) * distance;

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: sparkOpacity * 0.9,
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          startX + dx,
          startY + dy,
        ),
        spark.size * (1 - sparkProgress * 0.4),
        paint,
      );
    }

    // ------------------------------------------------------------
    // ROCKET POSITION
    // ------------------------------------------------------------

    // Very fast upward movement.
    final rocketDistance = size.height * 1.15;

    final rocketY = startY - rocketDistance * progress;

    // ------------------------------------------------------------
    // ROCKET TRAIL
    // ------------------------------------------------------------

    final trailLength = 70.0 + progress * 90;

    final trailGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.75),
        ],
      ).createShader(
        Rect.fromLTWH(
          startX - 8,
          rocketY,
          16,
          trailLength,
        ),
      );

    final trailPath = Path();

    trailPath.moveTo(
      startX - 4,
      rocketY + 5,
    );

    trailPath.lineTo(
      startX + 4,
      rocketY + 5,
    );

    trailPath.lineTo(
      startX,
      rocketY + trailLength,
    );

    trailPath.close();

    canvas.drawPath(
      trailPath,
      trailGradient,
    );

    // ------------------------------------------------------------
    // ROCKET GLOW
    // ------------------------------------------------------------

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        14,
      );

    canvas.drawCircle(
      Offset(startX, rocketY),
      13,
      glowPaint,
    );

    // ------------------------------------------------------------
    // ROCKET BODY
    // ------------------------------------------------------------

    final rocketPaint = Paint()
      ..color = const Color(0xFFECECEC)
      ..style = PaintingStyle.fill;

    final rocketPath = Path();

    // Nose
    rocketPath.moveTo(
      startX,
      rocketY - 15,
    );

    // Right side
    rocketPath.lineTo(
      startX + 6,
      rocketY - 3,
    );

    rocketPath.lineTo(
      startX + 5,
      rocketY + 9,
    );

    // Right fin
    rocketPath.lineTo(
      startX + 10,
      rocketY + 14,
    );

    rocketPath.lineTo(
      startX + 4,
      rocketY + 12,
    );

    // Bottom
    rocketPath.lineTo(
      startX,
      rocketY + 17,
    );

    rocketPath.lineTo(
      startX - 4,
      rocketY + 12,
    );

    // Left fin
    rocketPath.lineTo(
      startX - 10,
      rocketY + 14,
    );

    rocketPath.lineTo(
      startX - 5,
      rocketY + 9,
    );

    rocketPath.lineTo(
      startX - 6,
      rocketY - 3,
    );

    rocketPath.close();

    canvas.drawPath(
      rocketPath,
      rocketPaint,
    );

    // ------------------------------------------------------------
    // ROCKET WINDOW
    // ------------------------------------------------------------

    final windowPaint = Paint()
      ..color = const Color(0xFF20242B);

    canvas.drawCircle(
      Offset(
        startX,
        rocketY - 3,
      ),
      2.4,
      windowPaint,
    );

    // ------------------------------------------------------------
    // ENGINE FLAME
    // ------------------------------------------------------------

    final flameProgress =
        0.7 + sin(progress * pi * 8) * 0.25;

    final flamePaint = Paint()
      ..color = Colors.white.withValues(
        alpha: 0.85,
      );

    final flamePath = Path();

    flamePath.moveTo(
      startX - 3,
      rocketY + 14,
    );

    flamePath.lineTo(
      startX + 3,
      rocketY + 14,
    );

    flamePath.lineTo(
      startX,
      rocketY + 14 + 15 * flameProgress,
    );

    flamePath.close();

    canvas.drawPath(
      flamePath,
      flamePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RocketPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}