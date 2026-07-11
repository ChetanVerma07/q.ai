import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; // Re-integrated our standard font!

import '../core/theme/app_theme.dart';
import '../widgets/loading_skeleton.dart';

// Import all screens directly to avoid `pushNamed` path crashing
import 'chat_screen.dart';
import 'history_screen.dart';
import 'incogonito_screen.dart';
import 'settings_screen.dart';
// Note: If you don't have these two in your folders yet, comment these out!
// import '../profile/profile_screen.dart';
// import '../web/web_home_screen.dart';

final homeLoadingProvider = StateProvider<bool>((ref) => true);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ref.read(homeLoadingProvider.notifier).state = false;
  }

  // --- FIXED ROUTING: Using direct MaterialPageRoute to prevent route crashes ---

  void navigateToSignIn(BuildContext context) {
    // If you have sign in, route here
  }

  void navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void navigateToHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  void navigateToChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChatScreen()), // Directly calls our newly synced ChatScreen!
    );
  }

  void navigateToIncognito(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const IncogonitoScreen(),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    showComingSoon(context, 'Profile');
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void navigateToWebHome(BuildContext context) {
    showComingSoon(context, 'Web Home');
    // Navigator.of(context).push(PageRouteBuilder(...));
  }

  void showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label is coming soon for Q.Ai.',
          style: GoogleFonts.outfit(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.surfaceMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void showChatWarningDialog(BuildContext context) {
    navigateToChat(context);
  }

  void showIncognitoDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.blueGrey.withOpacity(0.28),
                ),
              ),
              child: const Icon(
                Icons.visibility_off_rounded,
                color: Color(0xFFCFD8DC),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Open Incognito Mode',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Incognito mode opens a private and temporary chat session designed for sensitive prompts, hidden context, and quick clearing.',
          style: GoogleFonts.outfit(
            color: AppTheme.textSecondary,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.shield_moon_rounded, size: 18),
            label: Text(
              'Enter Incognito',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCFD8DC),
              foregroundColor: Colors.black,
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
      ),
    ).then((openIncognito) {
      if (openIncognito == true) {
        navigateToIncognito(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeLoadingProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      drawer: isLoading ? null : buildDrawer(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryRed)) // Replaced loading structure to strictly avoid skeleton mismatch class errors
          : Stack(
        children: [
          buildBackgroundGlow(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  elevation: 0,
                  backgroundColor: AppTheme.backgroundBlack.withOpacity(0.92),
                  surfaceTintColor: Colors.transparent,
                  titleSpacing: 20,
                  title: Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryRed,
                              AppTheme.redGradientEnd,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryRed.withOpacity(0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppTheme.textPrimary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'QuantSpace.Ai',
                            style: GoogleFonts.orbitron(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Search Chat Build',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    buildTopAction(
                      icon: Icons.visibility_off_rounded,
                      onTap: () => showIncognitoDialog(context),
                    ),
                    const SizedBox(width: 8),
                    buildTopAction(
                      icon: Icons.language_rounded,
                      onTap: () => navigateToWebHome(context),
                    ),
                    const SizedBox(width: 8),
                    buildTopAction(
                      icon: Icons.history_rounded,
                      onTap: () => navigateToHistory(context),
                    ),
                    const SizedBox(width: 8),
                    buildTopAction(
                      icon: Icons.person_outline_rounded,
                      onTap: () => navigateToProfile(context),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHeroCard(context),
                        const SizedBox(height: 22),
                        buildModeStrip(),
                        const SizedBox(height: 28),
                        Text(
                          'Workspace',
                          style: GoogleFonts.outfit(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        buildWorkspaceRow(context),
                        const SizedBox(height: 28),
                        Text(
                          'Quick Actions',
                          style: GoogleFonts.outfit(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1.08,
                          children: [
                            buildQuickActionCard(
                              context,
                              icon: Icons.forum_rounded,
                              title: 'AI Chat',
                              subtitle: 'Start a fast answer session',
                              onTap: () => navigateToChat(context),
                              isPrimary: true,
                            ),
                            buildQuickActionCard(
                              context,
                              icon: Icons.visibility_off_rounded,
                              title: 'Incognito',
                              subtitle: 'Private temporary session',
                              onTap: () => showIncognitoDialog(context),
                              accentColor: const Color(0xFFCFD8DC),
                            ),
                            buildQuickActionCard(
                              context,
                              icon: Icons.language_rounded,
                              title: 'Web Home',
                              subtitle: 'Open the web-first workspace',
                              onTap: () => navigateToWebHome(context),
                            ),
                            buildQuickActionCard(
                              context,
                              icon: Icons.person_rounded,
                              title: 'Profile',
                              subtitle: 'Manage your account space',
                              onTap: () => navigateToProfile(context),
                            ),
                            buildQuickActionCard(
                              context,
                              icon: Icons.tune_rounded,
                              title: 'Settings',
                              subtitle: 'Customize the experience',
                              onTap: () => navigateToSettings(context),
                            ),
                            buildQuickActionCard(
                              context,
                              icon: Icons.analytics_rounded,
                              title: 'Analytics',
                              subtitle: 'Usage insights and trends',
                              onTap: () => showComingSoon(context, 'Analytics'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        buildPromptIdeasSection(context),
                        const SizedBox(height: 28),
                        buildPrivacyCard(context),
                        const SizedBox(height: 28),
                        buildSignInCard(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackgroundGlow() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -30,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryRed.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: -70,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.redGradientEnd.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: -40,
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFCFD8DC).withOpacity(0.05),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.backgroundBlack,
                    AppTheme.surfaceDark.withOpacity(0.96),
                    AppTheme.backgroundBlack,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopAction({required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.surfaceLight.withOpacity(0.18),
        ),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: AppTheme.textPrimary,
          size: 20,
        ),
      ),
    );
  }

  Widget buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AppTheme.surfaceDark,
            AppTheme.surfaceMedium,
            AppTheme.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.primaryRed.withOpacity(0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.16),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppTheme.primaryRed.withOpacity(0.24),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.explore_rounded,
                      size: 16,
                      color: AppTheme.primaryRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Guest workspace active',
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCFD8DC).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFFCFD8DC).withOpacity(0.20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility_off_rounded,
                      size: 16,
                      color: Color(0xFFCFD8DC),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Incognito ready',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFCFD8DC),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Ask, search, explore, or switch into private incognito chat instantly.',
            style: GoogleFonts.outfit(
              color: AppTheme.textPrimary,
              fontSize: 30,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This Q.Ai home now supports both normal chat and a privacy-first incognito flow for temporary conversations, sensitive prompts, and fast clearing.',
            style: GoogleFonts.outfit(
              color: AppTheme.textSecondary,
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => navigateToChat(context),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    'Start AI Chat',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: AppTheme.textPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showIncognitoDialog(context),
                  icon: const Icon(Icons.visibility_off_rounded),
                  label: Text(
                    'Incognito',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: BorderSide(
                      color: const Color(0xFFCFD8DC).withOpacity(0.30),
                    ),
                    backgroundColor: const Color(0xFFCFD8DC).withOpacity(0.06),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => navigateToWebHome(context),
              icon: const Icon(Icons.language_rounded),
              label: Text(
                'Open Web Home',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: BorderSide(
                  color: AppTheme.primaryRed.withOpacity(0.30),
                ),
                backgroundColor: AppTheme.primaryRed.withOpacity(0.08),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModeStrip() {
    return Row(
      children: [
        Expanded(
          child: buildInfoChip(
            icon: Icons.bolt_rounded,
            label: 'Fast answers',
            color: AppTheme.primaryRed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildInfoChip(
            icon: Icons.visibility_off_rounded,
            label: 'Private mode',
            color: const Color(0xFFCFD8DC),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildInfoChip(
            icon: Icons.code_rounded,
            label: 'Tool-ready UI',
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWorkspaceRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildWorkspacePanel(
            icon: Icons.account_circle_rounded,
            title: 'Profile Hub',
            subtitle: 'Identity, preferences, and account details',
            accent: AppTheme.primaryRed,
            onTap: () => navigateToProfile(context),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: buildWorkspacePanel(
            icon: Icons.visibility_off_rounded,
            title: 'Incognito',
            subtitle: 'Private and temporary conversations',
            accent: const Color(0xFFCFD8DC),
            onTap: () => showIncognitoDialog(context),
          ),
        ),
      ],
    );
  }

  Widget buildWorkspacePanel({required IconData icon, required String title, required String subtitle, required Color accent, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: accent.withOpacity(0.16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickActionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap, bool isPrimary = false, Color? accentColor}) {
    final resolvedAccent = accentColor ?? AppTheme.textPrimary;
    final isCustomAccent = accentColor != null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isPrimary
            ? LinearGradient(
          colors: [
            AppTheme.primaryRed.withOpacity(0.18),
            AppTheme.surfaceDark,
            AppTheme.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : isCustomAccent
            ? LinearGradient(
          colors: [
            resolvedAccent.withOpacity(0.10),
            AppTheme.surfaceDark,
            AppTheme.surfaceMedium,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [
            AppTheme.surfaceDark,
            AppTheme.surfaceMedium,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isPrimary
              ? AppTheme.primaryRed.withOpacity(0.32)
              : isCustomAccent
              ? resolvedAccent.withOpacity(0.26)
              : AppTheme.surfaceLight.withOpacity(0.20),
        ),
        boxShadow: isPrimary
            ? [
          BoxShadow(
            color: AppTheme.primaryRed.withOpacity(0.14),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ]
            : isCustomAccent
            ? [
          BoxShadow(
            color: resolvedAccent.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
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
                        ? AppTheme.primaryRed.withOpacity(0.16)
                        : isCustomAccent
                        ? resolvedAccent.withOpacity(0.12)
                        : AppTheme.surfaceLight.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? AppTheme.primaryRed
                        : isCustomAccent
                        ? resolvedAccent
                        : AppTheme.textPrimary,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 12.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPromptIdeasSection(BuildContext context) {
    final prompts = [
      'Summarize today\'s top tech updates',
      'Explain Flutter API integration simply',
      'Help me debug my Dart code',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.surfaceLight.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: AppTheme.primaryRed,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Prompt Ideas',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap a suggestion to jump into a smarter conversation.',
            style: GoogleFonts.outfit(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ...prompts.map(
                (prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => navigateToChat(context),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMedium,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.surfaceLight.withOpacity(0.16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.north_east_rounded,
                          color: AppTheme.primaryRed,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          prompt,
                          style: GoogleFonts.outfit(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
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
        ],
      ),
    );
  }

  Widget buildPrivacyCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFCFD8DC).withOpacity(0.10),
            AppTheme.surfaceDark,
            AppTheme.surfaceMedium,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFCFD8DC).withOpacity(0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_moon_rounded,
                color: Color(0xFFCFD8DC),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Private Session Mode',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Open a separate incognito chat flow for temporary prompts, hidden context, and quick session clearing without mixing with your regular workspace.',
            style: GoogleFonts.outfit(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showIncognitoDialog(context),
              icon: const Icon(Icons.visibility_off_rounded),
              label: Text(
                'Open Incognito Chat',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCFD8DC),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignInCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryRed.withOpacity(0.16),
            AppTheme.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.primaryRed.withOpacity(0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_open_rounded,
                color: AppTheme.primaryRed,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Unlock Saved Chats',
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Create an account to sync chat history, preserve preferences, and access future assistant tools across devices.',
            style: GoogleFonts.outfit(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => navigateToSignIn(context),
              icon: const Icon(Icons.login_rounded),
              label: Text(
                'Create Account Sign In',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: AppTheme.textPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surfaceDark,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryRed.withOpacity(0.95),
                  AppTheme.redGradientEnd.withOpacity(0.88),
                  AppTheme.surfaceDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.textPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppTheme.textPrimary.withOpacity(0.16),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.textPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome, Guest',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore Q.Ai with chat, web tools, and a private incognito workspace.',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    navigateToProfile(context);
                  },
                  icon: const Icon(Icons.person_outline_rounded),
                  label: Text(
                    'Open Profile',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: BorderSide(
                      color: AppTheme.textPrimary.withOpacity(0.28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 20),
              children: [
                buildDrawerTile(
                  icon: Icons.forum_rounded,
                  title: 'AI Chat',
                  subtitle: 'Start a fresh conversation',
                  onTap: () {
                    Navigator.pop(context);
                    navigateToChat(context);
                  },
                  color: AppTheme.primaryRed,
                ),
                buildDrawerTile(
                  icon: Icons.visibility_off_rounded,
                  title: 'Incognito',
                  subtitle: 'Private temporary chat mode',
                  onTap: () {
                    Navigator.pop(context);
                    showIncognitoDialog(context);
                  },
                  color: const Color(0xFFCFD8DC),
                ),
                buildDrawerTile(
                  icon: Icons.language_rounded,
                  title: 'Web Home',
                  subtitle: 'Open the animated web workspace',
                  onTap: () {
                    Navigator.pop(context);
                    navigateToWebHome(context);
                  },
                  color: AppTheme.primaryRed,
                ),
                buildDrawerTile(
                  icon: Icons.history_rounded,
                  title: 'Chat History',
                  subtitle: 'Review older sessions',
                  onTap: () {
                    Navigator.pop(context);
                    navigateToHistory(context);
                  },
                  color: AppTheme.textPrimary,
                ),
                buildDrawerTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  subtitle: 'Your account and preferences',
                  onTap: () {
                    Navigator.pop(context);
                    navigateToProfile(context);
                  },
                  color: AppTheme.primaryRed,
                ),
                buildDrawerTile(
                  icon: Icons.analytics_rounded,
                  title: 'Analytics',
                  subtitle: 'Insights dashboard coming soon',
                  onTap: () {
                    Navigator.pop(context);
                    showComingSoon(context, 'Analytics');
                  },
                  color: AppTheme.textPrimary,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Colors.white10, height: 1),
                ),
                buildDrawerTile(
                  icon: Icons.login_rounded,
                  title: 'Sign In',
                  subtitle: 'Save chats and sync across devices',
                  onTap: () {
                    Navigator.pop(context);
                    navigateToSignIn(context);
                  },
                  color: AppTheme.primaryRed,
                ),
                buildDrawerTile(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  subtitle: 'Theme, controls, and preferences',
                  onTap: () {
                    Navigator.pop(context);
                    navigateToSettings(context);
                  },
                  color: AppTheme.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMedium,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: color.withOpacity(0.14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          color: AppTheme.textSecondary,
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
