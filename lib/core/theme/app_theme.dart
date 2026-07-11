// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {                                           // shades niche mention hai boss
  // Q.Ai RED THEME custom made
  static const Color primaryRed = Color(0xFFE61919);           // Main red
  static const Color redDark = Color(0xFF8B0000);             // Red shade900
  static const Color redBorder = Color(0xFF660000);           // Red shade800
  static const Color redGradientEnd = Color(0xFFCC0000);      // Red shade700
  static const Color red600 = Color(0xFFE61919);              // Red shade600

  static const Color surfaceDark = Color(0xFF212121);         // Grey shade900
  static const Color surfaceMedium = Color(0xFF424242);       // Grey shade800
  static const Color surfaceLight = Color(0xFF616161);        // Grey shade700
  static const Color backgroundBlack = Color(0xFF000000);     // Pure black

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3FFFFFF);     // white70
  static const Color iconRed = Color(0xFFE61919);

  /// Dark Theme - Q.Ai SignIn/HomeScreen custom made
  ///designed by Anubhav Singh Rajput
  ///
  ///
  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Primary Colors - RED theme
    colorScheme: ColorScheme.dark(
      primary: primaryRed,
      secondary: primaryRed,
      surface: surfaceDark,
      background: backgroundBlack,
      onPrimary: textPrimary,
      onSecondary: textPrimary,
      onSurface: textPrimary,
      onBackground: textPrimary,
    ),

    // Scaffold & Background
    scaffoldBackgroundColor: backgroundBlack,

    // AppBar - Transparent
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryRed,
        shadows: [
          Shadow(
            color: redDark,
            offset: Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      iconTheme: IconThemeData(color: primaryRed),
      foregroundColor: primaryRed,
    ),

    // Typography
    textTheme: _textTheme(),

    // Cards
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: redBorder, width: 1),
      ),
      shadowColor: redDark,
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: red600,
        foregroundColor: textPrimary,
        elevation: 12,
        shadowColor: redDark,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),

    // FAB - Matches HomeScreen FAB style
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: surfaceMedium,
      foregroundColor: textPrimary,
      elevation: 15,
    ),

    // TextField
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceMedium,
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: surfaceLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: surfaceLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryRed, width: 2),
      ),
      labelStyle: TextStyle(color: textSecondary),
    ),

    // Icons - Red theme (Global icon theme)
    iconTheme: IconThemeData(color: iconRed, size: 24),

    // Drawer styling
    drawerTheme: DrawerThemeData(
      backgroundColor: surfaceDark,
      elevation: 0,
    ),
  );

  // Typography matching HomeScreen + SignIn
  static TextTheme _textTheme() {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: primaryRed,
        letterSpacing: 3,
        shadows: const [
          Shadow(offset: Offset(2, 2), blurRadius: 10, color: Colors.black54),
        ],
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryRed,
        letterSpacing: 1,
        shadows: const [
          Shadow(offset: Offset(2, 2), blurRadius: 10, color: Colors.black54),
        ],
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        shadows: [
          Shadow(offset: Offset(1, 2), blurRadius: 8, color: Colors.black45),
        ],
      ),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: textSecondary),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondary),
      labelSmall: TextStyle(fontSize: 12, color: textSecondary),
    );
  }
}
