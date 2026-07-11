//typing_text_pricing.dart
import 'dart:async';
import 'package:flutter/material.dart';

class TypingTextPricing extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;
  final bool repeat;
  final int maxLines;
  final TextOverflow overflow;
  final bool showCursor;
  final String cursorCharacter;
  final Duration cursorBlinkDuration;

  const TypingTextPricing({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 35),
    this.pauseDuration = const Duration(milliseconds: 1200),
    this.repeat = true,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.showCursor = true,
    this.cursorCharacter = '|',
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
  });

  @override
  State<TypingTextPricing> createState() => _TypingTextPricingState();
}

class _TypingTextPricingState extends State<TypingTextPricing> {
  Timer? _typingTimer;
  Timer? _cursorTimer;

  int _textIndex = 0;
  int _charIndex = 0;
  String _displayText = '';
  bool _showBlinkCursor = true;

  @override
  void initState() {
    super.initState();

    if (widget.texts.isNotEmpty) {
      _startCursorBlink();
      _startTyping();
    }
  }

  void _startCursorBlink() {
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(widget.cursorBlinkDuration, (_) {
      if (!mounted || !widget.showCursor) return;
      setState(() {
        _showBlinkCursor = !_showBlinkCursor;
      });
    });
  }

  void _startTyping() {
    _typingTimer?.cancel();
    _typingTimer = Timer(widget.typingSpeed, _typeNextCharacter);
  }

  void _typeNextCharacter() {
    if (!mounted || widget.texts.isEmpty) return;

    final currentText = widget.texts[_textIndex];

    if (_charIndex < currentText.length) {
      setState(() {
        _charIndex++;
        _displayText = currentText.substring(0, _charIndex);
      });
      _typingTimer = Timer(widget.typingSpeed, _typeNextCharacter);
    } else {
      _typingTimer = Timer(widget.pauseDuration, _moveToNextText);
    }
  }

  void _moveToNextText() {
    if (!mounted || widget.texts.isEmpty) return;

    if (_textIndex < widget.texts.length - 1) {
      setState(() {
        _textIndex++;
        _charIndex = 0;
        _displayText = '';
      });
      _startTyping();
      return;
    }

    if (widget.repeat) {
      setState(() {
        _textIndex = 0;
        _charIndex = 0;
        _displayText = '';
      });
      _startTyping();
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );

    final visibleText = widget.showCursor && _showBlinkCursor
        ? '$_displayText${widget.cursorCharacter}'
        : _displayText;

    return Text(
      visibleText,
      style: textStyle,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}