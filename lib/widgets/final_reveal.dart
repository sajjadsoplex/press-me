import 'package:flutter/material.dart';

import 'typewriter_text.dart';

class FinalReveal extends StatefulWidget {
  const FinalReveal({super.key});

  @override
  State<FinalReveal> createState() => _FinalRevealState();
}

class _FinalRevealState extends State<FinalReveal>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _glowController;

  bool _showMessage = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _beginReveal();
  }

  Future<void> _beginReveal() async {
    // Give the screen a moment of complete darkness.
    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    if (!mounted) return;

    await _fadeController.forward();

    if (!mounted) return;

    setState(() {
      _showMessage = true;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050403),

      body: Stack(
        fit: StackFit.expand,
        children: [
          // ============================================================
          // WARM ATMOSPHERIC LIGHT
          // ============================================================

          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              final glow =
                  0.035 + (_glowController.value * 0.035);

              return Center(
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFC28B62)
                            .withValues(alpha: glow),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ============================================================
          // FINAL CONTENT
          // ============================================================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 70,
                ),
                child: AnimatedOpacity(
                  opacity: _showMessage ? 1.0 : 0.0,
                  duration: const Duration(
                    milliseconds: 1800,
                  ),
                  curve: Curves.easeInOut,
                  child: const _LiteraryMessage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// LITERARY MESSAGE
// ======================================================================

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
          // ============================================================
          // GREETING
          // ============================================================

          TypewriterText(
            text: 'Dear Ms. Hafsa,',
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

          // ============================================================
          // MESSAGE
          // ============================================================

          TypewriterText(
            text:
                'And perhaps, after all the wandering, '
                'there was never really a destination.\n\n'
                'Perhaps it was only about following the little '
                'lights along the way—\n'
                'through the sound of rain,\n'
                'past distant mountains,\n'
                'beneath skies full of unanswered questions,\n'
                'and toward whatever waits beyond the next horizon.\n\n'
                'Some journeys are planned.\n'
                'Others simply begin with a little curiosity\n'
                'and a willingness to press one more time.\n\n'
                'So, before this little journey comes to an end,\n'
                'there is only one thing left to say:\n\n'
                'I hope, somewhere along the way,\n'
                'I managed to leave a little smile behind.\n\n'
                'And if I did…\n'
                'then perhaps this small adventure\n'
                'was worth creating after all.',
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

          // ============================================================
          // END
          // ============================================================

          TypewriterText(
            text: '— The End, for now.',
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