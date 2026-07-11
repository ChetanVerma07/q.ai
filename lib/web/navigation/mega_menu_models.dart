import 'package:flutter/material.dart';

class MegaMenuItem {
  final String title;
  final VoidCallback onTap;
  final bool showExternalIcon;

  const MegaMenuItem({
    required this.title,
    required this.onTap,
    this.showExternalIcon = false,
  });
}

class MegaMenuSection {
  final String heading;
  final List<MegaMenuItem> items;

  const MegaMenuSection({
    required this.heading,
    required this.items,
  });
}

class MegaMenuTabData {
  final String label;
  final List<MegaMenuSection> sections;

  const MegaMenuTabData({
    required this.label,
    required this.sections,
  });
}