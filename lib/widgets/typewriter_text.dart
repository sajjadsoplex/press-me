import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final Duration characterDuration;
  final TextStyle? style;
  final TextAlign textAlign;
  final VoidCallback? onFinished;

  const TypewriterText({
    super.key,
    required this.text,
    this.characterDuration = const Duration(milliseconds: 32),
    this.style,
    this.textAlign = TextAlign.center,
    this.onFinished,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;

  int _visibleCharacters = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _timer?.cancel();

      setState(() {
        _visibleCharacters = 0;
      });

      _startTyping();
    }
  }

  void _startTyping() {
    if (widget.text.isEmpty) {
      widget.onFinished?.call();
      return;
    }

    _timer = Timer.periodic(
      widget.characterDuration,
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_visibleCharacters >= widget.text.length) {
          timer.cancel();
          widget.onFinished?.call();
          return;
        }

        setState(() {
          _visibleCharacters++;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleText =
        widget.text.substring(0, _visibleCharacters);

    return Text(
      visibleText,
      textAlign: widget.textAlign,
      style: widget.style,
    );
  }
}