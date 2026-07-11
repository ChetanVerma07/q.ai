import 'dart:async';
import 'package:flutter/material.dart';

class ReverseTypingHeadline extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration pauseAfterTyped;
  final Duration pauseAfterDeleted;
  final bool repeat;
  final String cursor;

  const ReverseTypingHeadline({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 42),
    this.deletingSpeed = const Duration(milliseconds: 22),
    this.pauseAfterTyped = const Duration(milliseconds: 1400),
    this.pauseAfterDeleted = const Duration(milliseconds: 350),
    this.repeat = true,
    this.cursor = '',
  });

  @override
  State<ReverseTypingHeadline> createState() => _ReverseTypingHeadlineState();
}

class _ReverseTypingHeadlineState extends State<ReverseTypingHeadline> {
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  String _displayText = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.texts.isNotEmpty) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _scheduleNextTick(widget.typingSpeed);
  }

  void _scheduleNextTick(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted || widget.texts.isEmpty) return;

    final currentText = widget.texts[_textIndex];

    if (!_isDeleting) {
      if (_charIndex < currentText.length) {
        setState(() {
          _charIndex++;
          _displayText = currentText.substring(0, _charIndex);
        });
        _scheduleNextTick(widget.typingSpeed);
      } else {
        _isDeleting = true;
        _scheduleNextTick(widget.pauseAfterTyped);
      }
    } else {
      if (_charIndex > 0) {
        setState(() {
          _charIndex--;
          _displayText = currentText.substring(0, _charIndex);
        });
        _scheduleNextTick(widget.deletingSpeed);
      } else {
        _isDeleting = false;

        if (_textIndex < widget.texts.length - 1) {
          _textIndex++;
        } else if (widget.repeat) {
          _textIndex = 0;
        } else {
          return;
        }

        _scheduleNextTick(widget.pauseAfterDeleted);
      }
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
      '$_displayText${widget.cursor}',
      style: widget.style,
      maxLines: 3,
      overflow: TextOverflow.visible,
    );
  }
}