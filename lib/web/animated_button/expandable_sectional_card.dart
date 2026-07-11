import 'package:flutter/material.dart';

class ExpandableSectionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final bool initiallyExpanded;
  final Duration duration;
  final VoidCallback? onTap;
  final bool openOnHover;
  final bool closeOnExit;

  const ExpandableSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 280),
    this.onTap,
    this.openOnHover = true,
    this.closeOnExit = true,
  });

  @override
  State<ExpandableSectionCard> createState() => _ExpandableSectionCardState();
}

class _ExpandableSectionCardState extends State<ExpandableSectionCard>
    with TickerProviderStateMixin {
  late bool _isExpanded;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant ExpandableSectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  void _expand() {
    if (!_isExpanded && mounted) {
      setState(() => _isExpanded = true);
    }
  }

  void _collapse() {
    if (_isExpanded && mounted) {
      setState(() => _isExpanded = false);
    }
  }

  void _toggle() {
    if (!mounted) return;
    setState(() => _isExpanded = !_isExpanded);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = _isExpanded || _isHovered;
    final double scale = _isExpanded
        ? 1.025
        : (_isHovered ? 1.012 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!mounted) return;
        setState(() => _isHovered = true);
        if (widget.openOnHover) _expand();
      },
      onExit: (_) {
        if (!mounted) return;
        setState(() => _isHovered = false);
        if (widget.closeOnExit) _collapse();
      },
      child: AnimatedScale(
        scale: scale,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(
            vertical: active ? 14 : 10,
            horizontal: active ? 4 : 0,
          ),
          padding: EdgeInsets.fromLTRB(
            active ? 22 : 18,
            active ? 22 : 18,
            active ? 22 : 18,
            active ? 22 : 18,
          ),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF131D2B) : const Color(0xFF0D1522),
            borderRadius: BorderRadius.circular(active ? 26 : 22),
            border: Border.all(
              color: active
                  ? const Color(0xFF4F8CFF).withOpacity(0.40)
                  : Colors.white.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: active
                    ? const Color(0xFF4F8CFF).withOpacity(0.16)
                    : Colors.black.withOpacity(0.10),
                blurRadius: active ? 34 : 12,
                spreadRadius: active ? 1.4 : 0,
                offset: Offset(0, active ? 18 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: widget.duration,
                        curve: Curves.easeOutCubic,
                        height: active ? 54 : 50,
                        width: active ? 54 : 50,
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF4F8CFF).withOpacity(0.18)
                              : Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          widget.icon,
                          color: active
                              ? const Color(0xFF82B1FF)
                              : Colors.white70,
                          size: active ? 28 : 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: widget.duration,
                              curve: Curves.easeOutCubic,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: active ? 18 : 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: widget.duration,
                              curve: Curves.easeOutCubic,
                              style: TextStyle(
                                color: Colors.white.withOpacity(
                                  active ? 0.78 : 0.68,
                                ),
                                fontSize: active ? 14 : 13.5,
                                height: 1.4,
                              ),
                              child: Text(
                                widget.subtitle,
                                maxLines: _isExpanded ? 6 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: widget.duration,
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: active ? Colors.white : Colors.white70,
                          size: active ? 32 : 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: widget.duration,
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _isExpanded
                    ? Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: AnimatedOpacity(
                    duration: widget.duration,
                    curve: Curves.easeOutCubic,
                    opacity: _isExpanded ? 1 : 0,
                    child: widget.child,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}