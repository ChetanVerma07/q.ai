import 'package:flutter/material.dart';

class HoverScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final double pressedScale;
  final bool enableHoverLift;
  final double hoverTranslateY;
  final Duration duration;
  final Curve curve;
  final BorderRadius? borderRadius;

  const HoverScaleButton({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.10,
    this.pressedScale = 1.00,
    this.enableHoverLift = false,
    this.hoverTranslateY = -2,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOutCubic,
    this.borderRadius,
  });

  @override
  State<HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<HoverScaleButton> {
  bool _hovering = false;
  bool _pressed = false;

  double get _scale {
    if (_pressed) return widget.pressedScale;
    if (_hovering) return widget.hoverScale;
    return 1.0;
  }

  double get _translateY {
    if (!_hovering || !widget.enableHoverLift) return 0;
    return widget.hoverTranslateY;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: widget.duration,
          curve: widget.curve,
          transform: Matrix4.identity()
            ..translate(0.0, _translateY)
            ..scale(_scale),
          transformAlignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}