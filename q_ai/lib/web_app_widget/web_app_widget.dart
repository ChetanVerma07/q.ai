import 'dart:ui';
import 'package:flutter/material.dart';
import '../web_app_theme/web_app_theme.dart';

class WebShell extends StatelessWidget {

  final Widget child;
  final bool showGlow;

  const WebShell({
    super.key,
    required this.child,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {

    final palette = context.palette;
    final visuals = context.webVisuals;

    return Stack(
      children: [
        Container(color: palette.background),
        if (showGlow && visuals.useGlow) const WebBackgroundOrbs(),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  palette.background,
                  palette.backgroundAlt.withOpacity(0.72),
                  palette.background,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class WebBackgroundOrbs extends StatelessWidget {
  const WebBackgroundOrbs({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final visuals = context.webVisuals;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -20,
            child: _orb(
              color: palette.accent.withOpacity(0.16),
              size: 260,
              blur: visuals.blurSigma > 0 ? visuals.blurSigma * 2.8 : 50,
            ),
          ),
          Positioned(
            top: 220,
            left: -80,
            child: _orb(
              color: palette.accentSoft.withOpacity(0.30),
              size: 220,
              blur: visuals.blurSigma > 0 ? visuals.blurSigma * 2.4 : 50,
            ),
          ),
          Positioned(
            bottom: -70,
            right: 220,
            child: _orb(
              color: palette.success.withOpacity(0.08),
              size: 180,
              blur: visuals.blurSigma > 0 ? visuals.blurSigma * 2.2 : 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb({
    required Color color,
    required double size,
    required double blur,
  }) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class WebTopBar extends StatelessWidget {
  final List<WebNavItemData> items;
  final ValueChanged<int>? onTap;
  final int selectedIndex;
  final VoidCallback? onMobileToggle;
  final String title;
  final String subtitle;

  const WebTopBar({
    super.key,
    required this.items,
    this.onTap,
    this.selectedIndex = 0,
    this.onMobileToggle,
    this.title = 'QuantSpace.ai',
    this.subtitle = 'Search · Chat · Build · Analyze',
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;
    final visuals = context.webVisuals;

    final navChild = Container(
      height: metrics.navHeight,
      padding: EdgeInsets.symmetric(horizontal: metrics.pagePadding),
      decoration: BoxDecoration(
        color: visuals.useGlassNav
            ? palette.surface.withOpacity(0.60)
            : palette.surface,
        border: Border(
          bottom: BorderSide(
            color: palette.border.withOpacity(0.55),
          ),
        ),
      ),
      child: Row(
        children: [
          const WebBrandMark(),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: text.title.copyWith(
                  color: palette.textPrimary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: text.label.copyWith(
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            children: List.generate(
              items.length,
                  (index) => WebNavPill(
                label: items[index].label,
                isSelected: selectedIndex == index,
                onTap: () => onTap?.call(index),
              ),
            ),
          ),
          const SizedBox(width: 16),
          WebViewSwitch(
            onMobileTap: onMobileToggle,
          ),
        ],
      ),
    );

    if (!visuals.useGlassNav) return navChild;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: visuals.blurSigma,
          sigmaY: visuals.blurSigma,
        ),
        child: navChild,
      ),
    );
  }
}

class WebBrandMark extends StatelessWidget {
  const WebBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            palette.accent,
            palette.accentSoft,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: palette.textPrimary,
      ),
    );
  }
}

class WebNavItemData {
  final String label;

  const WebNavItemData(this.label);
}

class WebNavPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const WebNavPill({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? palette.accentSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? palette.accent.withOpacity(0.22)
                  : palette.border.withOpacity(0.45),
            ),
          ),
          child: Text(
            label,
            style: text.label.copyWith(
              color: isSelected ? palette.textPrimary : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class WebViewSwitch extends StatelessWidget {
  final VoidCallback? onMobileTap;

  const WebViewSwitch({
    super.key,
    this.onMobileTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: palette.border.withOpacity(0.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: palette.accent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Web View',
              style: text.label.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onMobileTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                'Mobile View',
                style: text.label.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}