import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profile/profile_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../web/about/about_team.dart';
import '../web/animated_button/expandable_sectional_card.dart';
import '../web/navigation/mega_menu_models.dart';
import '../web/navigation/mega_menu_navbar.dart';
import '../web/pricing/pricing.dart';
import '../web/sign_in_page.dart';
import '../web/widgets/hover_scale_button.dart';
import '../web/widgets/reverse_typing_headline.dart';
import '../web/widgets/typing_texts.dart';
import '../web_app_theme/web_app_theme.dart';
import '../web_app_widget/web_app_widget.dart';
import '../widgets/loading_skeleton.dart';

final webHomeLoadingProvider = StateProvider<bool>((ref) => true);
final webThemeStyleProvider =
StateProvider<WebHomeStyle>((ref) => WebHomeStyle.hybrid);
final webThemeModeProvider =
StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class WebHomeScreen extends ConsumerStatefulWidget {
  const WebHomeScreen({super.key});

  @override
  ConsumerState<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends ConsumerState<WebHomeScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  final GlobalKey teamKey = GlobalKey();
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey downloadKey = GlobalKey();
  final GlobalKey pricingKey = GlobalKey();
  final GlobalKey resourcesKey = GlobalKey();

  late final AnimationController pageAnimController;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    pageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: pageAnimController,
      curve: Curves.easeOutCubic,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: pageAnimController,
        curve: Curves.easeOutCubic,
      ),
    );

    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    ref.read(webHomeLoadingProvider.notifier).state = false;
    pageAnimController.forward();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageAnimController.dispose();
    super.dispose();
  }

  void toggleThemeMode() {
    final current = ref.read(webThemeModeProvider);
    ref.read(webThemeModeProvider.notifier).state =
    current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void cycleThemeStyle() {
    final current = ref.read(webThemeStyleProvider);
    final next = switch (current) {
      WebHomeStyle.claude => WebHomeStyle.antigravity,
      WebHomeStyle.antigravity => WebHomeStyle.hybrid,
      WebHomeStyle.hybrid => WebHomeStyle.claude,
    };
    ref.read(webThemeStyleProvider.notifier).state = next;
  }

  void navigateToSignIn(BuildContext context) {
    final style = ref.read(webThemeStyleProvider);
    final mode = ref.read(webThemeModeProvider);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WebAppTheme(
          data: WebAppThemeData.of(style, mode),
          child: const SignInPage(),
        ),
      ),
    );
  }

  void navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings');
  }

  void navigateToHistory(BuildContext context) {
    Navigator.of(context).pushNamed('/history');
  }

  void navigateToChat(BuildContext context) {
    Navigator.of(context).pushNamed('/chat');
  }

  void navigateToPricing(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PricingScreen(),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  void navigateToAbout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AboutTeamPage(),
      ),
    );
  }

  void switchToMobileView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
        reverseTransitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) =>
        const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubicEmphasized,
            reverseCurve: Curves.easeOutCubic,
          );

          final slide = Tween<Offset>(
            begin: const Offset(0.12, 0),
            end: Offset.zero,
          ).animate(curved);

          final fade = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.82, curve: Curves.easeOut),
            ),
          );

          final scale = Tween<double>(
            begin: 0.985,
            end: 1.0,
          ).animate(curved);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: ScaleTransition(
                scale: scale,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  void scrollToSection(GlobalKey key) {
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;

    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  void showComingSoon(BuildContext context, String label) {
    final palette = context.palette;
    final text = context.webText;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label is coming soon for QuantSpace.ai.',
          style: text.body.copyWith(color: palette.textPrimary),
        ),
        backgroundColor: palette.surfaceStrong,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Future<void> showChatWarningDialog(BuildContext context) async {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;

    final signInSelected = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radiusLg),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: palette.accent.withValues(alpha: 0.22),
                  ),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: palette.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Continue in guest mode',
                  style: text.title.copyWith(
                    color: palette.textPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Guest chat works normally, but conversations are not saved. Sign in to sync chat history, preferences, and future tools across devices.',
            style: text.body.copyWith(color: palette.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Stay guest',
                style: text.button.copyWith(color: palette.textSecondary),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.login_rounded, size: 18),
              label: Text(
                'Sign in',
                style: text.button,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.accent,
                foregroundColor: bestOnColor(palette.accent),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (signInSelected == true) {
      navigateToSignIn(context);
    } else {
      navigateToChat(context);
    }
  }

  Color bestOnColor(Color background) {
    return background.computeLuminance() > 0.45
        ? Colors.black
        : Colors.white;
  }

  IconData sectionIconForTitle(String title) {
    switch (title) {
      case 'The QuantSpace team':
        return Icons.groups_rounded;
      case 'Capabilities':
        return Icons.auto_awesome_rounded;
      case 'Desktop companion':
        return Icons.download_rounded;
      case 'Access plans':
        return Icons.workspace_premium_rounded;
      case 'Learning resources':
        return Icons.menu_book_rounded;
      default:
        return Icons.dashboard_customize_rounded;
    }
  }

  List<MegaMenuTabData> buildMegaMenuTabs(BuildContext context) {
    return [
      MegaMenuTabData(
        label: 'QuantSpace',
        sections: [
          MegaMenuSection(
            heading: 'Team',
            items: [
              MegaMenuItem(
                title: 'About',
                onTap: () => navigateToAbout(context),
              ),
              MegaMenuItem(
                title: 'Vision',
                onTap: () => scrollToSection(teamKey),
              ),
              MegaMenuItem(
                title: 'Support',
                onTap: () => scrollToSection(teamKey),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Workspace',
            items: [
              MegaMenuItem(
                title: 'AI chat',
                onTap: () => showChatWarningDialog(context),
              ),
              MegaMenuItem(
                title: 'Profile hub',
                onTap: () => navigateToProfile(context),
              ),
              MegaMenuItem(
                title: 'Settings',
                onTap: () => navigateToSettings(context),
              ),
              MegaMenuItem(
                title: 'Mobile app view',
                onTap: () => switchToMobileView(context),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Explore',
            items: [
              MegaMenuItem(
                title: 'Capabilities',
                onTap: () => scrollToSection(featuresKey),
              ),
              MegaMenuItem(
                title: 'Prompt ideas',
                onTap: () => scrollToSection(resourcesKey),
              ),
              MegaMenuItem(
                title: 'Sign in flow',
                onTap: () => navigateToSignIn(context),
              ),
            ],
          ),
        ],
      ),
      MegaMenuTabData(
        label: 'Platform',
        sections: [
          MegaMenuSection(
            heading: 'Navigation',
            items: [
              MegaMenuItem(
                title: 'Team section',
                onTap: () => scrollToSection(teamKey),
              ),
              MegaMenuItem(
                title: 'Features section',
                onTap: () => scrollToSection(featuresKey),
              ),
              MegaMenuItem(
                title: 'Resources section',
                onTap: () => scrollToSection(resourcesKey),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Account',
            items: [
              MegaMenuItem(
                title: 'Profile',
                onTap: () => navigateToProfile(context),
              ),
              MegaMenuItem(
                title: 'History',
                onTap: () => navigateToHistory(context),
              ),
              MegaMenuItem(
                title: 'Settings',
                onTap: () => navigateToSettings(context),
              ),
              MegaMenuItem(
                title: 'Mobile home',
                onTap: () => switchToMobileView(context),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Desktop',
            items: [
              MegaMenuItem(
                title: 'Desktop companion',
                onTap: () => scrollToSection(downloadKey),
              ),
              MegaMenuItem(
                title: 'Windows download',
                onTap: () => showComingSoon(context, 'Windows download'),
              ),
            ],
          ),
        ],
      ),
      MegaMenuTabData(
        label: 'Solutions',
        sections: [
          MegaMenuSection(
            heading: 'For use cases',
            items: [
              MegaMenuItem(
                title: 'Students',
                onTap: () => showComingSoon(context, 'Students workflow'),
              ),
              MegaMenuItem(
                title: 'Developers',
                onTap: () => showChatWarningDialog(context),
              ),
              MegaMenuItem(
                title: 'Researchers',
                onTap: () => showComingSoon(context, 'Researchers workflow'),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Core flows',
            items: [
              MegaMenuItem(
                title: 'Debugging help',
                onTap: () => showChatWarningDialog(context),
              ),
              MegaMenuItem(
                title: 'Summaries',
                onTap: () => showChatWarningDialog(context),
              ),
              MegaMenuItem(
                title: 'Learning support',
                onTap: () => showChatWarningDialog(context),
              ),
            ],
          ),
        ],
      ),
      MegaMenuTabData(
        label: 'Pricing',
        sections: [
          MegaMenuSection(
            heading: 'Plans',
            items: [
              MegaMenuItem(
                title: 'Access plans',
                onTap: () => navigateToPricing(context),
              ),
              MegaMenuItem(
                title: 'Classic plan',
                onTap: () => navigateToPricing(context),
              ),
              MegaMenuItem(
                title: 'Pro plan',
                onTap: () => navigateToPricing(context),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Compare',
            items: [
              MegaMenuItem(
                title: 'Plan highlights',
                onTap: () => scrollToSection(pricingKey),
              ),
              MegaMenuItem(
                title: 'Premium upgrades',
                onTap: () => navigateToPricing(context),
              ),
            ],
          ),
        ],
      ),
      MegaMenuTabData(
        label: 'Resources',
        sections: [
          MegaMenuSection(
            heading: 'Learn',
            items: [
              MegaMenuItem(
                title: 'Getting started',
                onTap: () => scrollToSection(resourcesKey),
              ),
              MegaMenuItem(
                title: 'Prompt library',
                onTap: () => scrollToSection(resourcesKey),
              ),
              MegaMenuItem(
                title: 'Workflow guides',
                onTap: () => showComingSoon(context, 'Workflow guides'),
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Information',
            items: [
              MegaMenuItem(
                title: 'About QuantSpace',
                onTap: () => navigateToAbout(context),
              ),
              MegaMenuItem(
                title: 'Privacy and trust',
                onTap: () => showComingSoon(context, 'Privacy and trust'),
              ),
              MegaMenuItem(
                title: 'Support',
                onTap: () => showComingSoon(context, 'Support'),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(webHomeLoadingProvider);
    final style = ref.watch(webThemeStyleProvider);
    final mode = ref.watch(webThemeModeProvider);

    return WebAppTheme(
      data: WebAppThemeData.of(style, mode),
      child: Builder(
        builder: (context) {
          final palette = context.palette;

          return Scaffold(
            backgroundColor: palette.background,
            body: isLoading
                ? const DashboardLoadingSkeleton()
                : WebShell(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: buildBackgroundAura(context),
                  ),
                  SafeArea(
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation,
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: buildTopNavigation(
                                context,
                                style,
                                mode,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  32,
                                  24,
                                  32,
                                  40,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    buildHeroSection(
                                      context,
                                      style,
                                      mode,
                                    ),
                                    const SizedBox(height: 24),
                                    buildModeStrip(
                                      context,
                                      style,
                                      mode,
                                    ),
                                    const SizedBox(height: 28),
                                    buildWorkspaceAndActions(context),
                                    const SizedBox(height: 28),
                                    buildSectionCard(
                                      context,
                                      sectionKey: teamKey,
                                      title: 'The QuantSpace team',
                                      description:
                                      'Meet the founders, moderation support, and the shared vision behind QuantSpace.ai.',
                                      onTap: () => navigateToAbout(
                                        context,
                                      ),
                                      child: buildTwoColumnInfo(
                                        context,
                                        leftTitle:
                                        'Founded by first-year B.Tech students',
                                        left:
                                        'QuantSpace.ai is being developed by Anubhav Singh Rajput, Chetan Verma, and Kanishk Verma as an AI-driven platform shaped by shared ambition, creativity, and product vision.',
                                        rightTitle: 'Shared vision',
                                        right:
                                        'The platform reflects innovation, teamwork, and technical dedication, with each team member contributing to development, execution, moderation, and long-term growth.',
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    buildSectionCard(
                                      context,
                                      sectionKey: featuresKey,
                                      title: 'Capabilities',
                                      description:
                                      'The web experience extends your mobile workflow into a cleaner and wider AI workspace with clearer navigation and stronger sectioning.',
                                      onTap: () =>
                                          scrollToSection(featuresKey),
                                      child: buildFeaturesGrid(context),
                                    ),
                                    const SizedBox(height: 24),
                                    buildSectionCard(
                                      context,
                                      sectionKey: downloadKey,
                                      title: 'Desktop companion',
                                      description:
                                      'Install QuantSpace on Windows for a focused desktop workflow with fast access to chat, tools, prompts, and future productivity features.',
                                      onTap: () => showComingSoon(
                                        context,
                                        'Windows download',
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AnimatedWindowsDownloadButton(
                                          onPressed: () => showComingSoon(
                                            context,
                                            'Windows download',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    buildSectionCard(
                                      context,
                                      sectionKey: pricingKey,
                                      title: 'Access plans',
                                      description:
                                      'Browse pricing tiers built for daily use, premium access, and advanced AI workflows.',
                                      onTap: () =>
                                          navigateToPricing(context),
                                      child: buildPricingCards(context),
                                    ),
                                    const SizedBox(height: 24),
                                    buildSectionCard(
                                      context,
                                      sectionKey: resourcesKey,
                                      title: 'Learning resources',
                                      description:
                                      'Explore onboarding paths, prompts, workflow guides, and product context designed for new users and future members.',
                                      onTap: () =>
                                          scrollToSection(resourcesKey),
                                      child: buildResourceList(context),
                                    ),
                                    const SizedBox(height: 24),
                                    buildPromptIdeasSection(context),
                                    const SizedBox(height: 24),
                                    buildInformationMenuSection(context),
                                    const SizedBox(height: 24),
                                    buildSignInCard(context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTopNavigation(
      BuildContext context,
      WebHomeStyle style,
      ThemeMode mode,
      ) {
    final palette = context.palette;
    final text = context.webText;
    final visuals = context.webVisuals;
    final isDark = mode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MegaMenuNavbar(
              brand: 'Q.Ai',
              tabs: buildMegaMenuTabs(context),
              onTryQuantSpace: () => navigateToSignIn(context),
              onContactSales: () => showComingSoon(context, 'Contact sales'),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: visuals.useGlassNav ? visuals.blurSigma : 0,
                sigmaY: visuals.useGlassNav ? visuals.blurSigma : 0,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: palette.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: palette.border.withValues(alpha: 0.50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.shadow,
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HoverScaleButton(
                      onTap: () => navigateToSignIn(context),
                      hoverScale: 1.06,
                      pressedScale: 0.97,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: () => navigateToSignIn(context),
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: palette.accentSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.login_rounded,
                                size: 18,
                                color: palette.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sign In',
                                style: text.button.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverScaleButton(
                      onTap: () => switchToMobileView(context),
                      hoverScale: 1.06,
                      pressedScale: 0.97,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: () => switchToMobileView(context),
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: palette.accentSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 18,
                                color: palette.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mobile App View',
                                style: text.button.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverScaleButton(
                      onTap: () => navigateToAbout(context),
                      hoverScale: 1.06,
                      pressedScale: 0.97,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: () => navigateToAbout(context),
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: palette.accentSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 18,
                                color: palette.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'About',
                                style: text.button.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverScaleButton(
                      onTap: toggleThemeMode,
                      hoverScale: 1.06,
                      pressedScale: 0.97,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: toggleThemeMode,
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: palette.accentSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                size: 18,
                                color: palette.accent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isDark ? 'Light' : 'Dark',
                                style: text.button.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverScaleButton(
                      onTap: cycleThemeStyle,
                      hoverScale: 1.05,
                      pressedScale: 0.97,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: cycleThemeStyle,
                        borderRadius: BorderRadius.circular(999),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Text(
                            switch (style) {
                              WebHomeStyle.claude => 'Claude',
                              WebHomeStyle.antigravity => 'Antigravity',
                              WebHomeStyle.hybrid => 'Hybrid',
                            },
                            style: text.button.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeroSection(
      BuildContext context,
      WebHomeStyle style,
      ThemeMode mode,
      ) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;
    final visuals = context.webVisuals;
    final isDark = mode == ThemeMode.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: EdgeInsets.all(metrics.pagePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: visuals.heroGradient,
          begin: visuals.heroBegin,
          end: visuals.heroEnd,
        ),
        borderRadius: BorderRadius.circular(metrics.radiusXl),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: isDark ? 42 : 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTag(
                  context,
                  icon: Icons.groups_rounded,
                  label: 'Meet the QuantSpace.ai team',
                ),
                const SizedBox(height: 18),
                ReverseTypingHeadline(
                  texts: const [
                    'An AI Workspace being Shaped By Young Founders With Strong Product Vision',
                    'An AI Workspace Built With Innovation, Teamwork, And Technical Dedication',
                    'QuantSpace.ai Reflects The Shared Vision Of Its Founding Team',
                  ],
                  typingSpeed: const Duration(milliseconds: 40),
                  deletingSpeed: const Duration(milliseconds: 20),
                  pauseAfterTyped: const Duration(milliseconds: 1500),
                  pauseAfterDeleted: const Duration(milliseconds: 280),
                  style: text.hero.copyWith(
                    color: palette.textPrimary,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 12),
                TypingTexts(
                  texts: const [
                    'Explore the founders, team roles, vision, and AI workspace journey.',
                    'Built as an AI-driven platform by first-year B.Tech students.',
                    'A cleaner web home connected directly to the About team page.',
                  ],
                  style: text.body.copyWith(
                    color: palette.accent,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'QuantSpace.ai is being developed by Anubhav Singh Rajput, Chetan Verma, and Kanishk Verma, with support from Mohnish Gaur. The platform reflects their shared vision of building a modern, intelligent, and impactful technology product.',
                  style: text.body.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    HoverScaleButton(
                      onTap: () => navigateToSignIn(context),
                      hoverScale: 1.05,
                      pressedScale: 0.98,
                      borderRadius:
                      BorderRadius.circular(context.webMetrics.radiusMd),
                      child: ElevatedButton.icon(
                        onPressed: () => navigateToSignIn(context),
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Sign In'),
                        style: primaryButtonStyle(context),
                      ),
                    ),
                    HoverScaleButton(
                      onTap: () => switchToMobileView(context),
                      hoverScale: 1.05,
                      pressedScale: 0.98,
                      borderRadius:
                      BorderRadius.circular(context.webMetrics.radiusMd),
                      child: ElevatedButton.icon(
                        onPressed: () => switchToMobileView(context),
                        icon: const Icon(Icons.phone_android_rounded),
                        label: const Text('Mobile App View'),
                        style: primaryButtonStyle(context),
                      ),
                    ),
                    HoverScaleButton(
                      onTap: () => navigateToAbout(context),
                      hoverScale: 1.05,
                      pressedScale: 0.98,
                      borderRadius:
                      BorderRadius.circular(context.webMetrics.radiusMd),
                      child: OutlinedButton.icon(
                        onPressed: () => navigateToAbout(context),
                        icon: const Icon(Icons.info_outline_rounded),
                        label: const Text('About'),
                        style: outlineButtonStyle(context),
                      ),
                    ),
                    HoverScaleButton(
                      onTap: () => showChatWarningDialog(context),
                      hoverScale: 1.05,
                      pressedScale: 0.98,
                      borderRadius:
                      BorderRadius.circular(context.webMetrics.radiusMd),
                      child: OutlinedButton.icon(
                        onPressed: () => showChatWarningDialog(context),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Start AI chat'),
                        style: outlineButtonStyle(context),
                      ),
                    ),
                    HoverScaleButton(
                      onTap: () => navigateToPricing(context),
                      hoverScale: 1.05,
                      pressedScale: 0.98,
                      borderRadius:
                      BorderRadius.circular(context.webMetrics.radiusMd),
                      child: OutlinedButton.icon(
                        onPressed: () => navigateToPricing(context),
                        icon: const Icon(Icons.workspace_premium_rounded),
                        label: const Text('View pricing'),
                        style: outlineButtonStyle(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    const HeroMiniStat(
                      title: 'Founders',
                      value: '3 core founders',
                    ),
                    const HeroMiniStat(
                      title: 'Support',
                      value: 'Moderation team',
                    ),
                    HeroMiniStat(
                      title: 'Mode',
                      value: isDark ? 'Dark' : 'Light',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: visuals.primaryCardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(metrics.radiusLg),
                border: Border.all(
                  color: palette.accent.withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team',
                    style: text.sectionTitle.copyWith(
                      color: palette.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const StaticBullet(
                    text: 'Chetan Verma serves as Co-Founder & C.T.O.',
                  ),
                  const StaticBullet(
                    text: 'Anubhav Singh Rajput serves as Co-Founder & C.F.O.',
                  ),
                  const StaticBullet(
                    text: 'Kanishk Verma serves as Co-Founder & C.D.O.',
                  ),
                  const StaticBullet(
                    text: 'Mohnish Gaur contributes to moderation and team growth.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModeStrip(
      BuildContext context,
      WebHomeStyle style,
      ThemeMode mode,
      ) {
    final palette = context.palette;
    final isDark = mode == ThemeMode.dark;

    return Row(
      children: [
        Expanded(
          child: buildInfoChip(
            context,
            icon: isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            label: isDark ? 'Focused dark mode' : 'Calm light mode',
            color: palette.accent,
            highlighted: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildInfoChip(
            context,
            icon: Icons.groups_rounded,
            label: 'Founder-driven platform vision',
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildInfoChip(
            context,
            icon: Icons.phone_android_rounded,
            label: 'Mobile home view available',
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget buildInfoChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        bool highlighted = false,
      }) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;

    return HoverScaleButton(
      hoverScale: 1.04,
      pressedScale: 1.0,
      enableHoverLift: true,
      hoverTranslateY: -2,
      borderRadius: BorderRadius.circular(metrics.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: highlighted ? palette.surface : palette.surfaceSoft,
          borderRadius: BorderRadius.circular(metrics.radiusMd),
          border: Border.all(
            color: highlighted
                ? palette.accent
                : palette.border.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: highlighted ? palette.accent : color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: text.label.copyWith(
                color: palette.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWorkspaceAndActions(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: buildWorkspaceRow(context)),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 260,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.18,
              children: [
                buildQuickActionCard(
                  context,
                  icon: Icons.login_rounded,
                  title: 'Sign In',
                  subtitle: 'Open the web sign-in page instantly.',
                  onTap: () => navigateToSignIn(context),
                  isPrimary: true,
                ),
                buildQuickActionCard(
                  context,
                  icon: Icons.phone_android_rounded,
                  title: 'Mobile Home',
                  subtitle: 'Launch the mobile app home screen view.',
                  onTap: () => switchToMobileView(context),
                ),
                buildQuickActionCard(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'Open the founders, moderation, and vision page.',
                  onTap: () => navigateToAbout(context),
                ),
                buildQuickActionCard(
                  context,
                  icon: Icons.forum_rounded,
                  title: 'AI Chat',
                  subtitle: 'Start a fast answer session.',
                  onTap: () => showChatWarningDialog(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWorkspaceRow(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: buildWorkspacePanel(
            context,
            icon: Icons.account_circle_rounded,
            title: 'Profile hub',
            subtitle: 'Identity, preferences, and account details.',
            accent: palette.accent,
            onTap: () => navigateToProfile(context),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: buildWorkspacePanel(
            context,
            icon: Icons.phone_android_rounded,
            title: 'Mobile App',
            subtitle: 'Switch directly to home_screen.dart mobile view.',
            accent: palette.textPrimary,
            onTap: () => switchToMobileView(context),
          ),
        ),
      ],
    );
  }

  Widget buildWorkspacePanel(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color accent,
        required VoidCallback onTap,
      }) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;

    return HoverScaleButton(
      onTap: onTap,
      hoverScale: 1.03,
      pressedScale: 0.985,
      enableHoverLift: true,
      hoverTranslateY: -3,
      borderRadius: BorderRadius.circular(metrics.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(metrics.radiusLg),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(metrics.radiusLg),
            border: Border.all(
              color: accent.withValues(alpha: 0.14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: text.sectionTitle.copyWith(
                  color: palette.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: text.bodyMuted.copyWith(
                  color: palette.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuickActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        bool isPrimary = false,
      }) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;
    final visuals = context.webVisuals;

    return HoverScaleButton(
      onTap: onTap,
      hoverScale: 1.035,
      pressedScale: 0.985,
      enableHoverLift: true,
      hoverTranslateY: -4,
      borderRadius: BorderRadius.circular(metrics.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(metrics.radiusLg),
          gradient: LinearGradient(
            colors: isPrimary
                ? visuals.primaryCardGradient
                : visuals.cardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isPrimary
                ? palette.accent
                : palette.border.withValues(alpha: 0.20),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(metrics.radiusLg),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: isPrimary
                          ? palette.accent.withValues(alpha: 0.12)
                          : palette.surfaceStrong.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: isPrimary ? palette.accent : palette.textPrimary,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: text.sectionTitle.copyWith(
                      color: palette.textPrimary,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: text.bodyMuted.copyWith(
                      color: palette.textSecondary,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionCard(
      BuildContext context, {
        required GlobalKey sectionKey,
        required String title,
        required String description,
        required Widget child,
        VoidCallback? onTap,
        bool initiallyExpanded = false,
      }) {
    final metrics = context.webMetrics;

    return Container(
      key: sectionKey,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpandableSectionCard(
          title: title,
          subtitle: description,
          icon: sectionIconForTitle(title),
          initiallyExpanded: initiallyExpanded,
          onTap: onTap,
          openOnHover: true,
          closeOnExit: false,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(metrics.radiusLg),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget buildTwoColumnInfo(
      BuildContext context, {
        required String leftTitle,
        required String left,
        required String rightTitle,
        required String right,
      }) {
    return Row(
      children: [
        Expanded(
          child: infoPanel(
            context,
            Icons.groups_rounded,
            leftTitle,
            left,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: infoPanel(
            context,
            Icons.rocket_launch_rounded,
            rightTitle,
            right,
          ),
        ),
      ],
    );
  }

  Widget infoPanel(
      BuildContext context,
      IconData icon,
      String title,
      String body,
      ) {
    final palette = context.palette;
    final text = context.webText;

    return HoverScaleButton(
      hoverScale: 1.025,
      pressedScale: 1.0,
      enableHoverLift: true,
      hoverTranslateY: -2,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.surfaceSoft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: palette.border.withValues(alpha: 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: palette.accent, size: 22),
            const SizedBox(height: 14),
            Text(
              title,
              style: text.sectionTitle.copyWith(
                color: palette.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: text.bodyMuted.copyWith(
                color: palette.textSecondary,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeaturesGrid(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    final features = [
      (
      Icons.forum_rounded,
      'AI Chat',
      'Launch guided conversations with guest mode handling.'
      ),
      (
      Icons.groups_rounded,
      'About Team',
      'Open founder, moderator, and platform vision details quickly.'
      ),
      (
      Icons.person_rounded,
      'Profile Hub',
      'Access identity, preferences, and account details.'
      ),
      (
      Icons.phone_android_rounded,
      'Mobile View',
      'Jump directly into the mobile app home screen.'
      ),
      (
      Icons.settings_rounded,
      'Settings',
      'Customize your web workspace experience.'
      ),
      (
      Icons.login_rounded,
      'Sign-In Flow',
      'Unlock saved chats and future syncing features.'
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: features.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final item = features[index];
        final title = item.$2;

        return HoverScaleButton(
          onTap: title == 'Sign-In Flow'
              ? () => navigateToSignIn(context)
              : title == 'About Team'
              ? () => navigateToAbout(context)
              : title == 'Mobile View'
              ? () => switchToMobileView(context)
              : null,
          hoverScale: 1.025,
          pressedScale: 1.0,
          enableHoverLift: true,
          hoverTranslateY: -2,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: title == 'Sign-In Flow'
                ? () => navigateToSignIn(context)
                : title == 'About Team'
                ? () => navigateToAbout(context)
                : title == 'Mobile View'
                ? () => switchToMobileView(context)
                : null,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: palette.surfaceSoft,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: palette.border.withValues(alpha: 0.14),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.$1, color: palette.accent, size: 22),
                  const Spacer(),
                  Text(
                    item.$2,
                    style: text.sectionTitle.copyWith(
                      color: palette.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.$3,
                    style: text.bodyMuted.copyWith(
                      color: palette.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPricingCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: pricingPreviewCard(
            context,
            title: 'Classic',
            price: '199',
            badge: 'Most popular',
            subtitle:
            'Reliable daily usage for creators, students, and project workflows.',
            points: const [
              'Unlimited daily searches',
              'Longer memory',
              'More uploads',
            ],
            highlighted: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: pricingPreviewCard(
            context,
            title: 'Pro',
            price: '599',
            badge: 'Advanced',
            subtitle:
            'Built for deeper research, richer multimodal work, and faster output.',
            points: const [
              'Advanced reasoning models',
              'Faster image creation',
              'Early feature access',
            ],
            highlighted: false,
          ),
        ),
      ],
    );
  }

  Widget pricingPreviewCard(
      BuildContext context, {
        required String title,
        required String price,
        required String badge,
        required String subtitle,
        required List<String> points,
        required bool highlighted,
      }) {
    final palette = context.palette;
    final text = context.webText;
    final visuals = context.webVisuals;

    return HoverScaleButton(
      hoverScale: 1.025,
      pressedScale: 1.0,
      enableHoverLift: true,
      hoverTranslateY: -2,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: highlighted
              ? LinearGradient(
            colors: visuals.primaryCardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: highlighted ? null : palette.surfaceSoft,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: highlighted
                ? palette.accent
                : palette.border.withValues(alpha: 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTag(
              context,
              icon: Icons.workspace_premium_rounded,
              label: badge,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: text.sectionTitle.copyWith(
                color: palette.textPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$price / month',
              style: text.title.copyWith(
                color: palette.accent,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: text.body.copyWith(color: palette.textSecondary),
            ),
            const SizedBox(height: 16),
            ...points.map(
                  (point) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: palette.accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: text.bodyMuted.copyWith(
                          color: palette.textSecondary,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: HoverScaleButton(
                onTap: () => navigateToPricing(context),
                hoverScale: 1.04,
                pressedScale: 0.98,
                borderRadius: BorderRadius.circular(16),
                child: ElevatedButton(
                  onPressed: () => navigateToPricing(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlighted
                        ? palette.accent
                        : palette.surface,
                    foregroundColor: highlighted
                        ? bestOnColor(palette.accent)
                        : palette.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    highlighted ? 'Open pricing' : 'Compare plans',
                    style: text.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResourceList(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    final items = [
      'Getting started with QuantSpace.ai',
      'Meet the founders and team members',
      'Chat, profile, settings, and history workflow',
      'Understanding plans and premium upgrades',
      'Open mobile home screen',
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: HoverScaleButton(
            hoverScale: 1.02,
            pressedScale: 0.99,
            enableHoverLift: true,
            hoverTranslateY: -2,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (item == 'Meet the founders and team members') {
                  navigateToAbout(context);
                } else if (item == 'Open mobile home screen') {
                  switchToMobileView(context);
                } else {
                  showComingSoon(context, item);
                }
              },
              child: Ink(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.surfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: palette.border.withValues(alpha: 0.14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      item == 'Open mobile home screen'
                          ? Icons.phone_android_rounded
                          : Icons.menu_book_rounded,
                      color: palette.accent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: text.button.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: palette.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget buildPromptIdeasSection(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    final prompts = [
      'Summarize today\'s top tech updates',
      'Explain Flutter API integration simply',
      'Help me debug my Dart code',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: palette.accent, size: 22),
              const SizedBox(width: 10),
              Text(
                'Prompt ideas',
                style: text.sectionTitle.copyWith(
                  color: palette.textPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap a suggestion to jump into a smarter conversation.',
            style: text.body.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 16),
          ...prompts.map(
                (prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HoverScaleButton(
                onTap: () => showChatWarningDialog(context),
                hoverScale: 1.02,
                pressedScale: 0.99,
                enableHoverLift: true,
                hoverTranslateY: -2,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => showChatWarningDialog(context),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: palette.surfaceSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: palette.border.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: palette.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.north_east_rounded,
                            color: palette.accent,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            prompt,
                            style: text.body.copyWith(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInformationMenuSection(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    final items = [
      (
      Icons.info_outline_rounded,
      'About QuantSpace',
      'Open the team page and learn the purpose and direction of the platform.'
      ),
      (
      Icons.phone_android_rounded,
      'Mobile App View',
      'Jump from web home directly into the mobile app home screen.'
      ),
      (
      Icons.security_rounded,
      'Privacy and trust',
      'Understand how guest mode and future sync features work.'
      ),
      (
      Icons.support_agent_rounded,
      'Support',
      'Get help with account, chat, pricing, and workspace flows.'
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information',
            style: text.title.copyWith(
              color: palette.textPrimary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Helpful links and product context for new users.',
            style: text.body.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 18),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HoverScaleButton(
                hoverScale: 1.02,
                pressedScale: 0.99,
                enableHoverLift: true,
                hoverTranslateY: -2,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    if (item.$2 == 'About QuantSpace') {
                      navigateToAbout(context);
                    } else if (item.$2 == 'Mobile App View') {
                      switchToMobileView(context);
                    } else {
                      showComingSoon(context, item.$2);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: palette.surfaceSoft,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: palette.border.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(item.$1, color: palette.accent, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.$2,
                                style: text.button.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.$3,
                                style: text.bodyMuted.copyWith(
                                  color: palette.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: palette.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignInCard(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;
    final visuals = context.webVisuals;

    return HoverScaleButton(
      hoverScale: 1.02,
      pressedScale: 1.0,
      enableHoverLift: true,
      hoverTranslateY: -2,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: visuals.primaryCardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: palette.accent.withValues(alpha: 0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_open_rounded, color: palette.accent, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Unlock saved chats',
                  style: text.title.copyWith(
                    color: palette.textPrimary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Create an account to sync chat history, preserve preferences, and access future assistant tools across devices.',
              style: text.body.copyWith(color: palette.textSecondary),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: HoverScaleButton(
                onTap: () => navigateToSignIn(context),
                hoverScale: 1.04,
                pressedScale: 0.98,
                borderRadius:
                BorderRadius.circular(context.webMetrics.radiusMd),
                child: ElevatedButton.icon(
                  onPressed: () => navigateToSignIn(context),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Create account / sign in'),
                  style: primaryButtonStyle(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTag(
      BuildContext context, {
        required IconData icon,
        required String label,
      }) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: palette.accent.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: palette.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: text.label.copyWith(color: palette.accent),
          ),
        ],
      ),
    );
  }

  ButtonStyle primaryButtonStyle(BuildContext context) {
    final palette = context.palette;
    final metrics = context.webMetrics;

    return ElevatedButton.styleFrom(
      backgroundColor: palette.accent,
      foregroundColor: bestOnColor(palette.accent),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(metrics.radiusMd),
      ),
    );
  }

  ButtonStyle outlineButtonStyle(BuildContext context) {
    final palette = context.palette;
    final metrics = context.webMetrics;

    return OutlinedButton.styleFrom(
      foregroundColor: palette.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      side: BorderSide(
        color: palette.border.withValues(alpha: 0.38),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(metrics.radiusMd),
      ),
    );
  }

  Widget buildBackgroundAura(BuildContext context) {
    final palette = context.palette;
    final visuals = context.webVisuals;

    if (!visuals.useGlow) {
      return DecoratedBox(
        decoration: BoxDecoration(color: palette.background),
      );
    }

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -30,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accent.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: -70,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accentSoft.withValues(alpha: 0.24),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  palette.background,
                  palette.backgroundAlt.withValues(alpha: 0.92),
                  palette.background,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

class AnimatedWindowsDownloadButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedWindowsDownloadButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<AnimatedWindowsDownloadButton> createState() =>
      _AnimatedWindowsDownloadButtonState();
}

class _AnimatedWindowsDownloadButtonState
    extends State<AnimatedWindowsDownloadButton> {
  bool hovering = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    final scale = pressed
        ? 0.97
        : hovering
        ? 1.02
        : 1.0;
    final translateY = pressed
        ? 0.0
        : hovering
        ? -4.0
        : 0.0;
    final onAccent = bestOnColorStatic(palette.accent);

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() {
        hovering = false;
        pressed = false;
      }),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, translateY, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette.accent,
                palette.accent.withValues(alpha: 0.86),
                palette.accent.withValues(alpha: 0.94),
                palette.accent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: palette.accent.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: palette.accent.withValues(
                  alpha: hovering ? 0.28 : 0.18,
                ),
                blurRadius: hovering ? 28 : 18,
                offset: Offset(0, hovering ? 14 : 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onPressed,
              onTapDown: (_) => setState(() => pressed = true),
              onTapCancel: () => setState(() => pressed = false),
              onTapUp: (_) => setState(() => pressed = false),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedRotation(
                      turns: hovering ? -0.03 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        height: 42,
                        width: 42,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: const WindowsLogoIcon(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Download for Windows',
                          style: text.button.copyWith(
                            color: onAccent,
                            fontWeight: FontWeight.w800,
                            fontSize: 15.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Desktop build for QuantSpace',
                          style: text.label.copyWith(
                            color: onAccent.withValues(alpha: 0.78),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    AnimatedSlide(
                      offset: hovering
                          ? const Offset(0.14, 0)
                          : Offset.zero,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: onAccent,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WindowsLogoIcon extends StatelessWidget {
  const WindowsLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = constraints.maxWidth * 0.10;
        final tile = (constraints.maxWidth - gap) / 2;

        return Center(
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            child: Wrap(
              spacing: gap,
              runSpacing: gap,
              children: List.generate(
                4,
                    (_) => Container(
                  width: tile,
                  height: tile,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(tile * 0.10),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StaticBullet extends StatelessWidget {
  final String text;

  const StaticBullet({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final webText = context.webText;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: palette.accent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: webText.body.copyWith(
                color: palette.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroMiniStat extends StatelessWidget {
  final String title;
  final String value;

  const HeroMiniStat({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: text.label.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: text.button.copyWith(
              color: palette.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

Color bestOnColorStatic(Color background) {
  return background.computeLuminance() > 0.45
      ? Colors.black
      : Colors.white;
}