import 'package:flutter/material.dart';

import '../data/stages.dart';
import '../widgets/floating_particles.dart';
import '../widgets/final_reveal.dart';
import '../widgets/rocket_launch.dart';
import '../widgets/stage_background.dart';

class PressMeScreen extends StatefulWidget {
  const PressMeScreen({super.key});

  @override
  State<PressMeScreen> createState() => _PressMeScreenState();
}

class _PressMeScreenState extends State<PressMeScreen>
    with TickerProviderStateMixin {
  int pressCount = 0;

  bool isLaunching = false;

  late final AnimationController _buttonController;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  PressStage get currentStage {
    return stages[pressCount];
  }

  // ---------------------------------------------------------------
  // PRESS BUTTON
  // ---------------------------------------------------------------

  void pressButton() {
    if (isLaunching) return;

    if (pressCount >= 9) return;

    setState(() {
      isLaunching = true;
    });

    // Quick button press effect.
    _buttonController.forward().then((_) {
      if (mounted) {
        _buttonController.reverse();
      }
    });
  }

  // ---------------------------------------------------------------
  // ROCKET FINISHED
  // ---------------------------------------------------------------

  void rocketFinished() {
    if (!mounted) return;

    setState(() {
      pressCount++;
      isLaunching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------
    // FINAL REVEAL
    // -------------------------------------------------------------

    if (pressCount >= 9) {
      return const FinalReveal();
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------------------------------------------------------
          // BACKGROUND
          // ---------------------------------------------------------

          StageBackground(
            stage: pressCount,
          ),

          // ---------------------------------------------------------
          // FLOATING PARTICLES
          // ---------------------------------------------------------

          const FloatingParticles(),

          // ---------------------------------------------------------
          // MAIN CONTENT
          // ---------------------------------------------------------

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // ------------------------------------------------
                    // STAGE COUNTER
                    // ------------------------------------------------

                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      child: Text(
                        '${pressCount + 1} / 9',
                        key: ValueKey(pressCount),
                        style: const TextStyle(
                          color: Color(0xFF676C75),
                          fontSize: 11,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ------------------------------------------------
                    // STAGE TEXT
                    // ------------------------------------------------

                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 650,
                      ),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: SizedBox(
                        key: ValueKey(pressCount),
                        width: 650,
                        child: Text(
                          currentStage.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFECE9E2),
                            fontSize: 21,
                            height: 1.5,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.2,
                            fontFamily: 'serif',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 55),

                    // ------------------------------------------------
                    // PRESS BUTTON
                    // ------------------------------------------------

                    if (!isLaunching)
                      AnimatedBuilder(
                        animation: _buttonController,
                        builder: (context, child) {
                          final scale =
                              1 - (_buttonController.value * 0.08);

                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: _PressButton(
                          onPressed: pressButton,
                        ),
                      ),

                    const Spacer(),

                    // ------------------------------------------------
                    // BOTTOM LABEL
                    // ------------------------------------------------

                    AnimatedOpacity(
                      opacity: isLaunching ? 0 : 1,
                      duration: const Duration(
                        milliseconds: 150,
                      ),
                      child: const Text(
                        'PRESS',
                        style: TextStyle(
                          color: Color(0xFF555A63),
                          fontSize: 10,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------
          // ROCKET + SPARK EFFECT
          // ---------------------------------------------------------

          if (isLaunching)
            Positioned.fill(
              child: RocketLaunch(
                onFinished: rocketFinished,
              ),
            ),
        ],
      ),
    );
  }
}

// =================================================================
// PRESS BUTTON
// =================================================================

class _PressButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _PressButton({
    required this.onPressed,
  });

  @override
  State<_PressButton> createState() => _PressButtonState();
}

class _PressButtonState extends State<_PressButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = 0.12 + (_controller.value * 0.10);

        return GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.32,
                ),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(
                    alpha: glow,
                  ),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF20242A),
                      Color(0xFF0D0F12),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.12,
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PRESS',
                    style: TextStyle(
                      color: Color(0xFFE8E5DE),
                      fontSize: 12,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}