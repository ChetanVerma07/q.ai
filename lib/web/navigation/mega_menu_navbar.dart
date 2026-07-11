import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../sign_in_page.dart';
import '../widgets/hover_scale_button.dart';
import '../../web_app_theme/web_app_theme.dart';
import 'mega_menu_models.dart';

class MegaMenuNavbar extends StatefulWidget {
  final String brand;
  final List<MegaMenuTabData> tabs;
  /// When set (e.g. on [SignInPage]), overrides default behavior of opening [SignInPage].
  final VoidCallback? onTryQuantSpace;
  final VoidCallback onContactSales;

  const MegaMenuNavbar({
    super.key,
    required this.brand,
    required this.tabs,
    this.onTryQuantSpace,
    required this.onContactSales,
  });

  @override
  State<MegaMenuNavbar> createState() => _MegaMenuNavbarState();
}

class _MegaMenuNavbarState extends State<MegaMenuNavbar> {
  int? _activeIndex;
  bool _showDropdown = false;
  Timer? _closeTimer;

  static const Duration _tabAnimDuration = Duration(milliseconds: 340);
  static const Duration _menuAnimDuration = Duration(milliseconds: 520);
  static const Duration _closeDelay = Duration(milliseconds: 170);

  void _cancelCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  void _setActiveIndex(int index) {
    _cancelCloseTimer();
    if (_activeIndex != index || !_showDropdown) {
      setState(() {
        _activeIndex = index;
        _showDropdown = true;
      });
    }
  }

  void _scheduleClose() {
    _cancelCloseTimer();
    _closeTimer = Timer(_closeDelay, () {
      if (!mounted) return;
      setState(() {
        _showDropdown = false;
      });
    });
  }

  void _closeNow() {
    _cancelCloseTimer();
    if (_showDropdown || _activeIndex != null) {
      setState(() {
        _showDropdown = false;
      });
    }
  }

  void _handleMenuAnimationEnd() {
    if (!_showDropdown && mounted && _activeIndex != null) {
      setState(() => _activeIndex = null);
    }
  }

  void _onTryQuantSpacePressed() {
    _closeNow();
    if (widget.onTryQuantSpace != null) {
      widget.onTryQuantSpace!();
      return;
    }
    final inherited = context.findAncestorWidgetOfExactType<WebAppTheme>();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => inherited != null
            ? WebAppTheme(
          data: inherited.data,
          child: const SignInPage(),
        )
            : const SignInPage(),
      ),
    );
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTab =
    _activeIndex != null ? widget.tabs[_activeIndex!] : null;
    final visible = _showDropdown && activeTab != null;

    return MouseRegion(
      onExit: (_) => _closeNow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            onEnter: (_) => _cancelCloseTimer(),
            onExit: (_) => _scheduleClose(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withOpacity(0.82),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(0.10)),
              ),
              child: Row(
                children: [
                  Text(
                    widget.brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 18),
                  ...List.generate(widget.tabs.length, (index) {
                    final tab = widget.tabs[index];
                    final active = _activeIndex == index && _showDropdown;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: MouseRegion(
                        onEnter: (_) => _setActiveIndex(index),
                        child: HoverScaleButton(
                          hoverScale: 1.03,
                          pressedScale: 0.992,
                          enableHoverLift: true,
                          hoverTranslateY: -1.5,
                          borderRadius: BorderRadius.circular(999),
                          child: AnimatedContainer(
                            duration: _tabAnimDuration,
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: active
                                    ? Colors.white.withOpacity(0.12)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: _tabAnimDuration,
                                  curve: Curves.easeOutCubic,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: active ? 16.25 : 16,
                                    fontWeight: active
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                  child: Text(tab.label),
                                ),
                                const SizedBox(width: 6),
                                AnimatedRotation(
                                  turns: active ? 0.5 : 0.0,
                                  duration: _tabAnimDuration,
                                  curve: Curves.easeOutCubic,
                                  child: AnimatedScale(
                                    scale: active ? 1.04 : 1.0,
                                    duration: _tabAnimDuration,
                                    curve: Curves.easeOutCubic,
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white.withOpacity(0.9),
                                      size: active ? 20 : 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  HoverScaleButton(
                    onTap: widget.onContactSales,
                    hoverScale: 1.01,
                    pressedScale: 0.995,
                    enableHoverLift: true,
                    hoverTranslateY: -1.5,
                    borderRadius: BorderRadius.circular(28),
                    child: AnimatedContainer(
                      duration: _tabAnimDuration,
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.24),
                            blurRadius: 34,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.support_agent_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Contact Sales',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  HoverScaleButton(
                    onTap: _onTryQuantSpacePressed,
                    hoverScale: 1.025,
                    pressedScale: 0.99,
                    enableHoverLift: true,
                    hoverTranslateY: -1.5,
                    borderRadius: BorderRadius.circular(999),
                    child: ElevatedButton(
                      onPressed: _onTryQuantSpacePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B30),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Try QuantSpace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          MouseRegion(
            onEnter: (_) => _cancelCloseTimer(),
            onExit: (_) => _scheduleClose(),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: visible ? 1.0 : 0.0),
              duration: _menuAnimDuration,
              curve: Curves.easeOutCubic,
              onEnd: _handleMenuAnimationEnd,
              builder: (context, value, child) {
                final opacity = value.clamp(0.0, 1.0);
                final translateY = lerpDouble(-18, 0, value)!;
                final scale = lerpDouble(0.985, 1.0, value)!;
                final blur = lerpDouble(8, 18, value)!;

                return IgnorePointer(
                  ignoring: opacity < 0.02,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.topCenter,
                        child: activeTab == null
                            ? const SizedBox.shrink()
                            : _MegaMenuDropdown(
                          tab: activeTab,
                          blurSigma: blur,
                          contentOpacity: opacity,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MegaMenuDropdown extends StatelessWidget {
  final MegaMenuTabData tab;
  final double blurSigma;
  final double contentOpacity;

  const _MegaMenuDropdown({
    required this.tab,
    required this.blurSigma,
    required this.contentOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          width: 860,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFF171717).withOpacity(0.82),
              const Color(0xFF171717).withOpacity(0.94),
              contentOpacity,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Color.lerp(
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.10),
                contentOpacity,
              )!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20 + (0.10 * contentOpacity)),
                blurRadius: lerpDouble(18, 38, contentOpacity)!,
                spreadRadius: lerpDouble(-2, 0, contentOpacity)!,
                offset: Offset(0, lerpDouble(10, 20, contentOpacity)!),
              ),
            ],
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutCubic,
            opacity: contentOpacity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tab.sections
                  .map(
                    (section) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _MegaMenuSectionView(
                      section: section,
                      revealAmount: contentOpacity,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MegaMenuSectionView extends StatelessWidget {
  final MegaMenuSection section;
  final double revealAmount;

  const _MegaMenuSectionView({
    required this.section,
    required this.revealAmount,
  });

  @override
  Widget build(BuildContext context) {
    final headingOffset = lerpDouble(8, 0, revealAmount)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(0, headingOffset),
          child: Opacity(
            opacity: revealAmount.clamp(0.0, 1.0),
            child: Text(
              section.heading,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...section.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final intervalStart = 0.08 + (index * 0.08);
          final localT = ((revealAmount - intervalStart) / 0.35)
              .clamp(0.0, 1.0)
              .toDouble();

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Transform.translate(
              offset: Offset(0, lerpDouble(12, 0, localT)!),
              child: Opacity(
                opacity: localT,
                child: _MegaMenuItemTile(item: item),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _MegaMenuItemTile extends StatefulWidget {
  final MegaMenuItem item;

  const _MegaMenuItemTile({
    required this.item,
  });

  @override
  State<_MegaMenuItemTile> createState() => _MegaMenuItemTileState();
}

class _MegaMenuItemTileState extends State<_MegaMenuItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.item.onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.05),
            ),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    color: _hovered
                        ? Colors.white
                        : Colors.white.withOpacity(0.96),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(widget.item.title),
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 240),
                offset: _hovered ? const Offset(0.08, 0) : Offset.zero,
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: _hovered ? 1.0 : 0.82,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white.withOpacity(0.82),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}