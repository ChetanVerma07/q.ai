import 'package:flutter/material.dart';
import 'mega_menu_models.dart';

class MegaMenuDropdown extends StatelessWidget {
  final List<MegaMenuSection> sections;
  final double width;
  final double columnWidth;
  final EdgeInsets padding;

  const MegaMenuDropdown({
    super.key,
    required this.sections,
    this.width = 860,
    this.columnWidth = 220,
    this.padding = const EdgeInsets.fromLTRB(24, 22, 24, 22),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          color: const Color(0xFF171412),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.34),
              blurRadius: 38,
              offset: const Offset(0, 24),
            ),
          ],
        ),
        child: Wrap(
          spacing: 18,
          runSpacing: 18,
          children: sections.map((section) {
            return SizedBox(
              width: columnWidth,
              child: _MegaMenuSectionColumn(section: section),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MegaMenuSectionColumn extends StatelessWidget {
  final MegaMenuSection section;

  const _MegaMenuSectionColumn({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.heading,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        ...section.items.map(
              (item) => _MegaMenuLinkTile(item: item),
        ),
      ],
    );
  }
}

class _MegaMenuLinkTile extends StatefulWidget {
  final MegaMenuItem item;

  const _MegaMenuLinkTile({
    required this.item,
  });

  @override
  State<_MegaMenuLinkTile> createState() => _MegaMenuLinkTileState();
}

class _MegaMenuLinkTileState extends State<_MegaMenuLinkTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.item.onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    color: _hovered
                        ? Colors.white
                        : Colors.white.withOpacity(0.92),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
              if (widget.item.showExternalIcon)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.north_east_rounded,
                    color: Colors.white.withOpacity(0.82),
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}