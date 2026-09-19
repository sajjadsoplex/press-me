import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'typewriter_text.dart';

class FinalReveal extends StatefulWidget {
  const FinalReveal({super.key});

  @override
  State<FinalReveal> createState() => _FinalRevealState();
}

class _FinalRevealState extends State<FinalReveal>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _lightningController;

  final Random _random = Random();

  Timer? _lightningTimer;

  bool _lightning = false;

  @override
  void initState() {
    super.initState();

    // Slow atmospheric glow.
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // Very fast lightning flash.
    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 180,
      ),
    );

    _startLightning();
  }

  void _startLightning() {
    _lightningTimer = Timer(
      Duration(
        milliseconds: 900 + _random.nextInt(1800),
      ),
      () {
        if (!mounted) return;

        _flashLightning();

        _startLightning();
      },
    );
  }

  Future<void> _flashLightning() async {
    if (!mounted) return;

    setState(() {
      _lightning = true;
    });

    await _lightningController.forward(from: 0);

    if (!mounted) return;

    await Future.delayed(
      const Duration(
        milliseconds: 55,
      ),
    );

    if (!mounted) return;

    setState(() {
      _lightning = false;
    });
  }

  @override
  void dispose() {
    _lightningTimer?.cancel();
    _glowController.dispose();
    _lightningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030405),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ==========================================================
          // DARK STORM BACKGROUND
          // ==========================================================

          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Color(0xFF101318),
                  Color(0xFF050607),
                  Color(0xFF010202),
                ],
              ),
            ),
          ),

          // ==========================================================
          // ATMOSPHERIC GLOW
          // ==========================================================

          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              final glow =
                  0.025 + (_glowController.value * 0.035);

              return Center(
                child: Container(
                  width: 650,
                  height: 650,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFB8C7D9)
                            .withValues(alpha: glow),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ==========================================================
          // LIGHTNING FLASH
          // ==========================================================

          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _lightning ? 1.0 : 0.0,
              duration: const Duration(
                milliseconds: 25,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.white.withValues(alpha: 0.22),
                      Colors.white.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ==========================================================
          // FINAL MESSAGE
          // ==========================================================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 70,
                ),
                child: const _LiteraryMessage(),
              ),
            ),
          ),

          // ==========================================================
          // LIGHTNING EDGE FLASHES
          // ==========================================================

          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _lightning ? 0.9 : 0.0,
              duration: const Duration(
                milliseconds: 20,
              ),
              child: CustomPaint(
                painter: _LightningPainter(
                  seed: _random.nextInt(100000),
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// FINAL MESSAGE
// ====================================================================

class _LiteraryMessage extends StatelessWidget {
  const _LiteraryMessage();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 760,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ==========================================================
          // GREETING
          // ==========================================================

          TypewriterText(
            text: 'Good Morning Malaika,',
            characterDuration:
                const Duration(milliseconds: 70),
            style: const TextStyle(
              color: Color(0xFFF4EDE4),
              fontSize: 22,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 48),

          // ==========================================================
          // MESSAGE
          // ==========================================================

          TypewriterText(
            text:
                'You actually pressed it nine times. 😂\n\n'
                'At this point, I think we can officially say\n'
                'you\'re either very curious…\n'
                'or very committed to pressing buttons. 🚀\n\n'
                'Either way, thanks for playing along.\n\n'
                'I hope this tiny piece of code\n'
                'made your morning a little more interesting.\n\n'
                'Have a great day! ☕✨',
            characterDuration:
                const Duration(milliseconds: 22),
            style: const TextStyle(
              color: Color(0xFFD5D0C9),
              fontSize: 17,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.7,
              height: 1.9,
            ),
          ),

          const SizedBox(height: 55),

          // ==========================================================
          // SIGNATURE
          // ==========================================================

          TypewriterText(
            text: '— Sajjad',
            characterDuration:
                const Duration(milliseconds: 65),
            style: const TextStyle(
              color: Color(0xFFB99677),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// LIGHTNING PAINTER
// ====================================================================

class _LightningPainter extends CustomPainter {
  final int seed;

  _LightningPainter({
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // --------------------------------------------------------------
    // LEFT LIGHTNING
    // --------------------------------------------------------------

    if (random.nextBool()) {
      final path = Path();

      double x = random.nextDouble() * size.width * 0.18;
      double y = size.height * (0.15 + random.nextDouble() * 0.45);

      path.moveTo(x, y);

      for (int i = 0; i < 7; i++) {
        x += (random.nextDouble() - 0.5) * 35;
        y += 25 + random.nextDouble() * 45;

        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }

    // --------------------------------------------------------------
    // RIGHT LIGHTNING
    // --------------------------------------------------------------

    if (random.nextBool()) {
      final path = Path();

      double x =
          size.width -
          random.nextDouble() * size.width * 0.18;

      double y =
          size.height *
          (0.15 + random.nextDouble() * 0.45);

      path.moveTo(x, y);

      for (int i = 0; i < 7; i++) {
        x += (random.nextDouble() - 0.5) * 35;
        y += 25 + random.nextDouble() * 45;

        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }

    // --------------------------------------------------------------
    // TOP SMALL FLASHES
    // --------------------------------------------------------------

    if (random.nextBool()) {
      final path = Path();

      double x = size.width *
          (0.25 + random.nextDouble() * 0.5);

      double y = 0;

      path.moveTo(x, y);

      for (int i = 0; i < 4; i++) {
        x += (random.nextDouble() - 0.5) * 45;
        y += 15 + random.nextDouble() * 25;

        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(
    covariant _LightningPainter oldDelegate,
  ) {
    return oldDelegate.seed != seed;
  }
}