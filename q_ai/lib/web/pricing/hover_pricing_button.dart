import 'package:flutter/material.dart';

class HoverPricingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final double pressedScale;
  final double hoverTranslateY;
  final Duration duration;
  final Curve curve;

  // Premium Pricing specific features
  final bool enableGlow;
  final Color glowColor;
  final double glowBlurRadius;
  final double glowSpreadRadius;
  final Offset glowOffset;
  final BorderRadius borderRadius;

  const HoverPricingButton({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.08, // HIGHER INTENSITY (was 1.04)
    this.pressedScale = 0.94, // DEEPER PRESS (was 0.98)
    this.hoverTranslateY = -6.0, // HIGHER LIFT (was -2)
    this.duration = const Duration(milliseconds: 300), // Slightly longer for dynamic bounce
    this.curve = Curves.easeOutBack, // BOUNCY / OVERSHOOT FEEL (was easeOutCubic)
    this.enableGlow = true,
    this.glowColor = const Color(0x668B5CF6), // Muted purple glow by default
    this.glowBlurRadius = 24.0,
    this.glowSpreadRadius = 4.0,
    this.glowOffset = const Offset(0, 10),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)), // Matches your pricing buttons
  });

  @override
  State<HoverPricingButton> createState() => _HoverPricingButtonState();
}

class _HoverPricingButtonState extends State<HoverPricingButton> {
  bool _hovering = false;
  bool _pressed = false;

  double get _scale {
    if (_pressed) return widget.pressedScale;
    if (_hovering) return widget.hoverScale;
    return 1.0;
  }

  double get _translateY {
    if (!_hovering) return 0;
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
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: [
              if (widget.enableGlow)
                BoxShadow(
                  color: _hovering ? widget.glowColor : Colors.transparent,
                  blurRadius: _hovering ? widget.glowBlurRadius : 0.0,
                  spreadRadius: _hovering ? widget.glowSpreadRadius : 0.0,
                  offset: _hovering ? widget.glowOffset : Offset.zero,
                ),
            ],
          ),
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
