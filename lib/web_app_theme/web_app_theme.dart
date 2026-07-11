import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// CORE WEB PALETTES AND STYLES

enum WebHomeStyle { claude, antigravity, hybrid }

@immutable
class WebThemePalette {
  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceSoft;
  final Color surfaceStrong;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color warning;
  final Color shadow;

  const WebThemePalette({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceSoft,
    required this.surfaceStrong,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.warning,
    required this.shadow,
  });
}

@immutable
class WebThemeMetrics {
  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double pagePadding;
  final double sectionGap;
  final double cardGap;
  final double navHeight;

  const WebThemeMetrics({
    this.radiusXs = 12,
    this.radiusSm = 16,
    this.radiusMd = 20,
    this.radiusLg = 24,
    this.radiusXl = 32,
    this.pagePadding = 28,
    this.sectionGap = 28,
    this.cardGap = 18,
    this.navHeight = 84,
  });
}

@immutable
class WebThemeTypography {
  final TextStyle hero;
  final TextStyle title;
  final TextStyle sectionTitle;
  final TextStyle body;
  final TextStyle bodyMuted;
  final TextStyle label;
  final TextStyle button;

  const WebThemeTypography({
    required this.hero,
    required this.title,
    required this.sectionTitle,
    required this.body,
    required this.bodyMuted,
    required this.label,
    required this.button,
  });
}

@immutable
class WebHomeVisuals {
  final List<Color> heroGradient;
  final List<Color> cardGradient;
  final List<Color> primaryCardGradient;
  final Alignment heroBegin;
  final Alignment heroEnd;
  final bool useGlow;
  final bool useGlassNav;
  final double blurSigma;
  final double borderOpacity;

  const WebHomeVisuals({
    required this.heroGradient,
    required this.cardGradient,
    required this.primaryCardGradient,
    this.heroBegin = Alignment.topLeft,
    this.heroEnd = Alignment.bottomRight,
    this.useGlow = false,
    this.useGlassNav = false,
    this.blurSigma = 0,
    this.borderOpacity = 0.16,
  });
}


// 2. THEME DATA ORCHESTRATOR


@immutable
class WebAppThemeData {
  final WebHomeStyle style;
  final ThemeMode themeMode;
  final WebThemePalette palette;
  final WebThemeMetrics metrics;
  final WebThemeTypography type;
  final WebHomeVisuals visuals;

  const WebAppThemeData({
    required this.style,
    required this.themeMode,
    required this.palette,
    required this.metrics,
    required this.type,
    required this.visuals,
  });


  // SHIFTED: Defaults firmly to Claude Dark Mode if not specified

  factory WebAppThemeData.of([
    WebHomeStyle style = WebHomeStyle.claude,
    ThemeMode mode = ThemeMode.dark,
  ]) {
    switch (style) {
      case WebHomeStyle.claude:
        return mode == ThemeMode.dark ? _claudeDark() : _claudeLight();
      case WebHomeStyle.antigravity:
        return mode == ThemeMode.dark
            ? _antigravityDark()
            : _antigravityLight();
      case WebHomeStyle.hybrid:
        return mode == ThemeMode.dark ? _hybridDark() : _hybridLight();
    }
  }

  SystemUiOverlayStyle get systemOverlayStyle {
    return themeMode == ThemeMode.dark
        ? SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: palette.background,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    )
        : SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: palette.background,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
  }

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;

  // --- Theme Definitions ---

  static WebAppThemeData _claudeLight() => WebAppThemeData(
    style: WebHomeStyle.claude,
    themeMode: ThemeMode.light,
    palette: const WebThemePalette(
      background: Color(0xFFF7F3EE),
      backgroundAlt: Color(0xFFEEE7DE),
      surface: Color(0xFFFFFCF8),
      surfaceSoft: Color(0xFFF4EEE6),
      surfaceStrong: Color(0xFFEAE1D5),
      border: Color(0xFFD8CCBC),
      textPrimary: Color(0xFF1F1A17),
      textSecondary: Color(0xFF6E6258),
      accent: Color(0xFFD97757),
      accentSoft: Color(0xFFF3D2C7),
      success: Color(0xFF3E7A57),
      warning: Color(0xFFA56A2A),
      shadow: Color(0x14000000),
    ),
    visuals: const WebHomeVisuals(
      heroGradient: [
        Color(0xFFFFFCF8),
        Color(0xFFF8F1E8),
        Color(0xFFF2E9DE),
      ],
      cardGradient: [
        Color(0xFFFFFCF8),
        Color(0xFFF7F1E9),
      ],
      primaryCardGradient: [
        Color(0xFFF7E2D7),
        Color(0xFFFFFCF8),
      ],
      useGlow: false,
      useGlassNav: false,
      blurSigma: 0,
      borderOpacity: 0.18,
    ),
    metrics: const WebThemeMetrics(),
    type: const WebThemeTypography(
      hero: TextStyle(
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      title: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      sectionTitle: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      bodyMuted: TextStyle(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
      label: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static WebAppThemeData _claudeDark() => WebAppThemeData(
    style: WebHomeStyle.claude,
    themeMode: ThemeMode.dark,
    palette: const WebThemePalette(
      background: Color(0xFF171411),
      backgroundAlt: Color(0xFF201C18),
      surface: Color(0xFF1E1A16),
      surfaceSoft: Color(0xFF27221D),
      surfaceStrong: Color(0xFF322C26),
      border: Color(0xFF494139),
      textPrimary: Color(0xFFF6F1EA),
      textSecondary: Color(0xFFB7ADA0),
      accent: Color(0xFFE2B089),
      accentSoft: Color(0x33D97757),
      success: Color(0xFF73A884),
      warning: Color(0xFFD49A57),
      shadow: Color(0x26000000),
    ),
    visuals: const WebHomeVisuals(
      heroGradient: [
        Color(0xFF26211C),
        Color(0xFF171411),
        Color(0xFF211C18),
      ],
      cardGradient: [
        Color(0xFF1F1B17),
        Color(0xFF181512),
      ],
      primaryCardGradient: [
        Color(0x26E2B089),
        Color(0xFF1E1A16),
      ],
      useGlow: true,
      useGlassNav: true,
      blurSigma: 12,
      borderOpacity: 0.22,
    ),
    metrics: const WebThemeMetrics(
      radiusSm: 16,
      radiusMd: 20,
      radiusLg: 24,
      radiusXl: 32,
    ),
    type: const WebThemeTypography(
      hero: TextStyle(
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      title: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      sectionTitle: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      bodyMuted: TextStyle(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
      label: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static WebAppThemeData _antigravityLight() => WebAppThemeData(
    style: WebHomeStyle.antigravity,
    themeMode: ThemeMode.light,
    palette: const WebThemePalette(
      background: Color(0xFFF7FAFF),
      backgroundAlt: Color(0xFFEAF1FF),
      surface: Color(0xFFFFFFFF),
      surfaceSoft: Color(0xFFF3F7FF),
      surfaceStrong: Color(0xFFE4ECFF),
      border: Color(0xFFC5D4F8),
      textPrimary: Color(0xFF101A2B),
      textSecondary: Color(0xFF5C6C88),
      accent: Color(0xFF5C58FF),
      accentSoft: Color(0xFFE1DDFF),
      success: Color(0xFF33B88A),
      warning: Color(0xFFF29A4A),
      shadow: Color(0x18000000),
    ),
    visuals: const WebHomeVisuals(
      heroGradient: [
        Color(0xFFF7FAFF),
        Color(0xFFEDF3FF),
        Color(0xFFE5EAFF),
      ],
      cardGradient: [
        Color(0xFFFFFFFF),
        Color(0xFFF6F9FF),
      ],
      primaryCardGradient: [
        Color(0x225C58FF),
        Color(0xFFFFFFFF),
      ],
      useGlow: true,
      useGlassNav: true,
      blurSigma: 14,
      borderOpacity: 0.18,
    ),
    metrics: const WebThemeMetrics(
      radiusSm: 18,
      radiusMd: 22,
      radiusLg: 28,
      radiusXl: 36,
      pagePadding: 30,
      sectionGap: 30,
      cardGap: 20,
      navHeight: 88,
    ),
    type: const WebThemeTypography(
      hero: TextStyle(
        fontSize: 42,
        height: 1.06,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.4,
      ),
      title: TextStyle(
        fontSize: 25,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      sectionTitle: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      bodyMuted: TextStyle(
        fontSize: 13.5,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
      label: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.3,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static WebAppThemeData _antigravityDark() => WebAppThemeData(
    style: WebHomeStyle.antigravity,
    themeMode: ThemeMode.dark,
    palette: const WebThemePalette(
      background: Color(0xFF0B1020),
      backgroundAlt: Color(0xFF121A30),
      surface: Color(0xFF11182A),
      surfaceSoft: Color(0xFF182134),
      surfaceStrong: Color(0xFF212C43),
      border: Color(0xFF2C3954),
      textPrimary: Color(0xFFF4F7FB),
      textSecondary: Color(0xFFAAB6CF),
      accent: Color(0xFF7C5CFF),
      accentSoft: Color(0x332A9DFF),
      success: Color(0xFF56D39B),
      warning: Color(0xFFFFB84D),
      shadow: Color(0x33000000),
    ),
    visuals: const WebHomeVisuals(
      heroGradient: [
        Color(0xFF131B31),
        Color(0xFF0B1020),
        Color(0xFF1A1140),
      ],
      cardGradient: [
        Color(0xFF141D31),
        Color(0xFF10182A),
      ],
      primaryCardGradient: [
        Color(0x337C5CFF),
        Color(0xFF11182A),
      ],
      useGlow: true,
      useGlassNav: true,
      blurSigma: 18,
      borderOpacity: 0.22,
    ),
    metrics: const WebThemeMetrics(
      radiusSm: 18,
      radiusMd: 22,
      radiusLg: 28,
      radiusXl: 36,
      pagePadding: 30,
      sectionGap: 30,
      cardGap: 20,
      navHeight: 88,
    ),
    type: const WebThemeTypography(
      hero: TextStyle(
        fontSize: 42,
        height: 1.06,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.4,
      ),
      title: TextStyle(
        fontSize: 25,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      sectionTitle: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      bodyMuted: TextStyle(
        fontSize: 13.5,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
      label: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.3,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static WebAppThemeData _hybridLight() => WebAppThemeData(
    style: WebHomeStyle.hybrid,
    themeMode: ThemeMode.light,
    palette: const WebThemePalette(
      background: Color(0xFFF5F1EA),
      backgroundAlt: Color(0xFFEAE5DD),
      surface: Color(0xFFFAF7F2),
      surfaceSoft: Color(0xFFF1EBE3),
      surfaceStrong: Color(0xFFDED6CC),
      border: Color(0xFFD4C7B9),
      textPrimary: Color(0xFF18181B),
      textSecondary: Color(0xFF64646F),
      accent: Color(0xFF7A5AF8),
      accentSoft: Color(0xFFE5DEFF),
      success: Color(0xFF3E8E63),
      warning: Color(0xFFB7791F),
      shadow: Color(0x16000000),
    ),
    visuals: const WebHomeVisuals(
      heroGradient: [
        Color(0xFFFAF7F2),
        Color(0xFFF2EBDD),
        Color(0xFFEAE4FF),
      ],
      cardGradient: [
        Color(0xFFFCFAF7),
        Color(0xFFF3EDE5),
      ],
      primaryCardGradient: [
        Color(0x1A7A5AF8),
        Color(0xFFFCFAF7),
      ],
      useGlow: true,
      useGlassNav: true,
      blurSigma: 10,
      borderOpacity: 0.18,
    ),
    metrics: const WebThemeMetrics(),
    type: const WebThemeTypography(
      hero: TextStyle(
        fontSize: 40,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
      ),
      title: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      sectionTitle: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      bodyMuted: TextStyle(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
      label: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static WebAppThemeData _hybridDark() => WebAppThemeData(
    style: WebHomeStyle.hybrid,
    themeMode: ThemeMode.dark,
    palette: const WebThemePalette(
      background: Color(0xFF0F0E12),
      backgroundAlt: Color(0xFF17151D),
      surface: Color(0xFF121118),
      surfaceSoft: Color(0xFF1C1A22),
      surfaceStrong: Color(0xFF252230),
      border: Color(0xFF363442),
      textPrimary: Color(0xFFF7F6FA),
      textSecondary: Color(0xFFB8B6C3),
      accent: Color(0xFFA78BFF),
      accentSoft: Color(0x337A5AF8),
      success: Color(0xFF59B591),
      warning: Color(0xFFECB565),
      shadow: Color(0x26000000),
    ),
    visuals: const WebHomeVisuals(
      heroGradient: [
        Color(0xFF17151D),
        Color(0xFF0F0E12),
        Color(0xFF1C1A22),
      ],
      cardGradient: [
        Color(0xFF121118),
        Color(0xFF111017),
      ],
      primaryCardGradient: [
        Color(0x33A78BFF),
        Color(0xFF121118),
      ],
      useGlow: true,
      useGlassNav: true,
      blurSigma: 14,
      borderOpacity: 0.20,
    ),
    metrics: const WebThemeMetrics(),
    type: const WebThemeTypography(
      hero: TextStyle(
        fontSize: 40,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
      ),
      title: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      sectionTitle: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      body: TextStyle(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
      bodyMuted: TextStyle(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w500,
      ),
      label: TextStyle(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
      button: TextStyle(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class WebAppTheme extends InheritedWidget {
  final WebAppThemeData data;

  const WebAppTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static WebAppThemeData of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<WebAppTheme>();
    assert(inherited != null, 'Wrap your page with WebAppTheme');
    return inherited!.data;
  }

  @override
  bool updateShouldNotify(WebAppTheme oldWidget) => data != oldWidget.data;
}


// 3. PRICING THEME EXTENSION (Integrated)

@immutable
class PricingThemeData {
  final WebAppThemeData coreTheme;

  const PricingThemeData(this.coreTheme);

  double get desktopBreakpoint => 1100.0;
  double get tabletBreakpoint => 700.0;
  double get maxContentWidth => 1380.0;

  EdgeInsetsGeometry pagePadding(bool isDesktop) {
    return EdgeInsets.fromLTRB(
      isDesktop ? coreTheme.metrics.pagePadding : 16,
      12,
      isDesktop ? coreTheme.metrics.pagePadding : 16,
      28,
    );
  }

  Color get freeTierAccent => coreTheme.palette.success;
  Color get popularTierAccent => coreTheme.palette.accent;
  Color get proTierAccent => coreTheme.palette.warning;

  Color get tagBackgroundHighlighted => coreTheme.palette.success.withOpacity(0.15);
  Color get tagBackgroundDefault => coreTheme.palette.surfaceSoft;
  Color get checkmarkColor => coreTheme.palette.success;

  TextStyle get heroDisplay => coreTheme.type.hero.copyWith(
    color: coreTheme.palette.textPrimary,
  );

  TextStyle get planPriceText => coreTheme.type.hero.copyWith(
    color: coreTheme.palette.textPrimary,
    fontSize: 38,
    height: 1,
  );

  TextStyle get planPeriodText => coreTheme.type.button.copyWith(
    color: coreTheme.palette.textSecondary,
  );

  TextStyle get defaultPlanName => coreTheme.type.title.copyWith(
    color: coreTheme.palette.textPrimary,
  );

  TextStyle get highlightedPlanName => coreTheme.type.title.copyWith(
    color: popularTierAccent,
  );

  BoxDecoration defaultPlanDecoration(bool isHovered) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(coreTheme.metrics.radiusLg),
      gradient: LinearGradient(
        colors: coreTheme.visuals.cardGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: coreTheme.palette.border),
      boxShadow: [
        BoxShadow(
          color: coreTheme.palette.shadow,
          blurRadius: isHovered ? 16 : 10,
          offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
        )
      ],
    );
  }

  BoxDecoration highlightedPlanDecoration(bool isHovered) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(coreTheme.metrics.radiusLg),
      gradient: LinearGradient(
        colors: coreTheme.visuals.primaryCardGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: popularTierAccent, width: 1.4),
      boxShadow: [
        BoxShadow(
          color: popularTierAccent.withOpacity(isHovered ? 0.35 : 0.15),
          blurRadius: isHovered ? 40 : 30,
          offset: isHovered ? const Offset(0, 20) : const Offset(0, 14),
        )
      ],
    );
  }

  BoxDecoration get billingToggleDecoration => BoxDecoration(
    color: coreTheme.palette.surfaceStrong,
    borderRadius: BorderRadius.circular(999),
    border: Border.all(color: coreTheme.palette.border),
  );
}


// 4. GLOBAL CONTEXT EXTENSIONS


extension WebThemeX on BuildContext {
  // Core Data
  WebAppThemeData get webTheme => WebAppTheme.of(this);
  WebThemePalette get palette => webTheme.palette;
  WebThemeTypography get webText => webTheme.type;
  WebThemeMetrics get webMetrics => webTheme.metrics;
  WebHomeVisuals get webVisuals => webTheme.visuals;
  ThemeMode get themeMode => webTheme.themeMode;

  bool get isClaudeTheme => webTheme.style == WebHomeStyle.claude;
  bool get isAntigravityTheme => webTheme.style == WebHomeStyle.antigravity;
  bool get isHybridTheme => webTheme.style == WebHomeStyle.hybrid;
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;

  // Integrated Sub-Themes
  PricingThemeData get pricingTheme => PricingThemeData(webTheme);

  bool get isPricingDesktop => MediaQuery.of(this).size.width >= pricingTheme.desktopBreakpoint;
  bool get isPricingTablet => MediaQuery.of(this).size.width >= pricingTheme.tabletBreakpoint;
}
