// lib/core/theme/app_colours.dart
import 'package:flutter/material.dart';


class AppColours {
  AppColours._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryUltraLight = Color(0xFFE1E5FF);

  // Success / Accent
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF6EE7B7);

  // Warning / Attention
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFCD34D);

  // Error Colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);

  // Neutral Grays
  static const Color grey50 = Color(0xFFFCFDFE);
  static const Color grey100 = Color(0xFFF8FAFC);
  static const Color grey200 = Color(0xFFF1F5F9);
  static const Color grey300 = Color(0xFFE2E8F0);
  static const Color grey400 = Color(0xFFCBD5E1);
  static const Color grey500 = Color(0xFF94A3B8);
  static const Color grey600 = Color(0xFF64748B);
  static const Color grey700 = Color(0xFF475569);
  static const Color grey800 = Color(0xFF334155);
  static const Color grey900 = Color(0xFF1E293B);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xFF8B5CF6);
  static const Color darkSurface = Color(0xFF0F0F23);
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1F1F3D);

  // Chat Specific
  static const Color chatBubbleUser = Color(0xFF6366F1);
  static const Color chatBubbleAI = Color(0xFFF8FAFC);
  static const Color chatBubbleAIDark = Color(0xFF1F1F3D);

  // Loading / Status
  static const Color loadingGradientStart = Color(0xFF667EEA);
  static const Color loadingGradientEnd = Color(0xFF764BA2);

  // Shadows & Borders
  static const Color shadowLight = Color(0xFFCBD5E1);
  static const Color shadowDark = Color(0xFF1E293B);

  // Selection / Hover
  static const Color hoverLight = Color(0xFFF1F5F9);
  static const Color hoverDark = Color(0xFF1F1F3D);
  static const Color active = Color(0xFF4F46E5);

  // Semantic aliases for easy reuse
  static const Color textPrimary = grey100;
  static const Color textSecondary = grey400;
  static const Color textMuted = grey500;

  static const Color surfaceBackground = darkBackground;
  static const Color surfacePrimary = darkSurface;
  static const Color surfaceCard = darkCard;

  static const Color border = grey800;
  static const Color divider = grey700;

  // Gradient Presets
  static LinearGradient primaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
  );

  static LinearGradient successGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successLight, success],
  );

  static LinearGradient splashGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark, darkBackground],
  );

  static LinearGradient loadingShimmer() => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      loadingGradientStart,
      loadingGradientEnd,
      loadingGradientStart,
    ],
    stops: [0.1, 0.5, 0.9],
  );
}

// Color Extensions for Convenience
extension AppColoursExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get primaryColor => AppColours.primary;
  Color get backgroundColor => AppColours.surfaceBackground;
  Color get cardColor => AppColours.surfaceCard;
  Color get textPrimary => AppColours.textPrimary;
  Color get textSecondary => AppColours.textSecondary;
  Color get borderColor => AppColours.border;
}