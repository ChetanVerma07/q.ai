import 'dart:async';
import 'package:flutter/material.dart';

class TypingTexts extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;
  final bool repeat;

  const TypingTexts({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 35),
    this.pauseDuration = const Duration(milliseconds: 1200),
    this.repeat = true,
  });

  @override
  State<TypingTexts> createState() => _TypingTextsState();
}

class _TypingTextsState extends State<TypingTexts> {
  Timer? _timer;
  int _textIndex = 0;
  int _charIndex = 0;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    if (widget.texts.isNotEmpty) {
      _startTyping();
    }
  }

  void _startTyping() {
    _timer?.cancel();
    _timer = Timer(widget.typingSpeed, _typeNextCharacter);
  }

  void _typeNextCharacter() {
    if (!mounted || widget.texts.isEmpty) return;

    final currentText = widget.texts[_textIndex];

    if (_charIndex < currentText.length) {
      setState(() {
        _charIndex++;
        _displayText = currentText.substring(0, _charIndex);
      });
      _timer = Timer(widget.typingSpeed, _typeNextCharacter);
    } else {
      _timer = Timer(widget.pauseDuration, _moveToNextText);
    }
  }

  void _moveToNextText() {
    if (!mounted || widget.texts.isEmpty) return;

    setState(() {
      _charIndex = 0;
      _displayText = '';

      if (_textIndex < widget.texts.length - 1) {
        _textIndex++;
      } else if (widget.repeat) {
        _textIndex = 0;
      }
    });

    if (_textIndex < widget.texts.length || widget.repeat) {
      _startTyping();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}