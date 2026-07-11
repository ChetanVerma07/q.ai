import 'package:flutter/material.dart';

class QuantSpaceBrandLogo extends StatelessWidget {
  final double iconSize;
  final double textSize;
  final bool showTagline;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry iconPadding;
  final double spacing;
  final Color? textColor;
  final Color? accentColor;
  final Color? tileColor;
  final FontWeight fontWeight;

  const QuantSpaceBrandLogo({
    super.key,
    this.iconSize = 26,
    this.textSize = 24,
    this.showTagline = false,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.iconPadding = const EdgeInsets.all(6),
    this.spacing = 10,
    this.textColor,
    this.accentColor,
    this.tileColor,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor = textColor ?? Colors.white;
    final resolvedAccentColor = accentColor ?? const Color(0xFFD6A77A);
    final resolvedTileColor = tileColor ?? const Color(0xFF211915);
    final resolvedBorderColor = resolvedAccentColor.withOpacity(0.22);
    final resolvedSoftAccent = resolvedAccentColor.withOpacity(0.16);

    return Row(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Container(
          height: iconSize,
          width: iconSize,
          padding: iconPadding,
          decoration: BoxDecoration(
            color: resolvedTileColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: resolvedBorderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _QuantSpaceGlyphPainter(
              accent: resolvedAccentColor,
              softAccent: resolvedSoftAccent,
            ),
          ),
        ),
        SizedBox(width: spacing),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QuantSpace',
              style: TextStyle(
                color: resolvedTextColor,
                fontSize: textSize,
                fontWeight: fontWeight,
                letterSpacing: 0.15,
                height: 1.0,
              ),
            ),
            if (showTagline) ...[
              const SizedBox(height: 4),
              Text(
                'AI workspace',
                style: TextStyle(
                  color: resolvedTextColor.withOpacity(0.70),
                  fontSize: textSize * 0.42,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  height: 1.0,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _QuantSpaceGlyphPainter extends CustomPainter {
  final Color accent;
  final Color softAccent;

  const _QuantSpaceGlyphPainter({
    required this.accent,
    required this.softAccent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = softAccent;

    final qPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = accent;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = accent;

    final center = Offset(size.width * 0.48, size.height * 0.48);
    final radius = size.width * 0.25;

    canvas.drawCircle(center, radius, ringPaint);

    final qArc = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        0.9,
        4.75,
      );

    canvas.drawPath(qArc, qPaint);

    final tail = Path()
      ..moveTo(size.width * 0.58, size.height * 0.58)
      ..lineTo(size.width * 0.82, size.height * 0.82);

    canvas.drawPath(tail, qPaint);

    canvas.drawCircle(
      Offset(size.width * 0.73, size.height * 0.29),
      size.width * 0.055,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _QuantSpaceGlyphPainter oldDelegate) {
    return oldDelegate.accent != accent ||
        oldDelegate.softAccent != softAccent;
  }
}