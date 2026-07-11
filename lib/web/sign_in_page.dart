import 'dart:ui';

import 'package:flutter/material.dart';

import 'navigation/mega_menu_models.dart';
import 'navigation/mega_menu_navbar.dart';
import 'navigation/quantspace_brand_logo.dart';
import 'widgets/hover_scale_button.dart';
import 'widgets/typing_texts.dart';
import '../web_app_theme/web_app_theme.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const String routeName = '/signin';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  List<MegaMenuTabData> _buildMegaMenuTabs(BuildContext context) {
    return [
      MegaMenuTabData(
        label: 'QuantSpace',
        sections: [
          MegaMenuSection(
            heading: 'Account',
            items: [
              MegaMenuItem(
                title: 'Sign in',
                onTap: () {},
              ),
              MegaMenuItem(
                title: 'Sign up',
                onTap: _goToSignUp,
              ),
            ],
          ),
          MegaMenuSection(
            heading: 'Explore',
            items: [
              MegaMenuItem(
                title: 'Back to home',
                onTap: _goBackHome,
              ),
              MegaMenuItem(
                title: 'Pricing',
                onTap: () => Navigator.of(context).pushNamed('/pricing'),
              ),
            ],
          ),
        ],
      ),
      MegaMenuTabData(
        label: 'Resources',
        sections: [
          MegaMenuSection(
            heading: 'Help',
            items: [
              MegaMenuItem(
                title: 'Support',
                onTap: () => _showSnackBar('Support is coming soon.'),
              ),
              MegaMenuItem(
                title: 'Forgot password',
                onTap: () =>
                    _showSnackBar('Forgot password flow coming soon.'),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  Future<void> _submitSignIn() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both email and password.');
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSnackBar('Signed in flow connected. Add your auth API here.');
  }

  void _goToSignUp() {
    Navigator.of(context).pushNamed('/signup');
  }

  void _showContactSales() {
    _showSnackBar('Contact sales is coming soon.');
  }

  void _goBackHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/web-home', (route) => false);
  }

  void _continueWithGoogle() {
    _showSnackBar('Google sign-in can be connected here.');
  }

  void _continueWithGitHub() {
    _showSnackBar('GitHub sign-in can be connected here.');
  }

  void _showSnackBar(String message) {
    final palette = context.palette;
    final text = context.webText;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: palette.surfaceStrong,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: text.body.copyWith(color: palette.textPrimary),
        ),
      ),
    );
  }

  ButtonStyle _primaryButtonStyle(BuildContext context) {
    final palette = context.palette;
    final metrics = context.webMetrics;

    return ElevatedButton.styleFrom(
      backgroundColor: palette.accent,
      foregroundColor: _bestOnColor(palette.accent),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(metrics.radiusMd),
      ),
    );
  }

  ButtonStyle _outlineButtonStyle(BuildContext context) {
    final palette = context.palette;
    final metrics = context.webMetrics;

    return OutlinedButton.styleFrom(
      foregroundColor: palette.textPrimary,
      backgroundColor: palette.surface.withValues(alpha: 0.65),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      side: BorderSide(
        color: palette.border.withValues(alpha: 0.34),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(metrics.radiusMd),
      ),
    );
  }

  Color _bestOnColor(Color background) {
    return background.computeLuminance() > 0.45 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 1100;
    final isMedium = width >= 780;

    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          Positioned.fill(child: _buildBackgroundAura(context)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MegaMenuNavbar(
                          brand: 'Q.Ai',
                          tabs: _buildMegaMenuTabs(context),
                          onTryQuantSpace: _goBackHome,
                          onContactSales: _showContactSales,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: isWide
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildLeftPanel(context),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 5,
                              child: _buildSignInCard(context),
                            ),
                          ],
                        )
                            : Column(
                          children: [
                            if (isMedium) _buildLeftPanel(context),
                            if (isMedium) const SizedBox(height: 24),
                            _buildSignInCard(context),
                            if (!isMedium) ...[
                              const SizedBox(height: 20),
                              _buildCompactTrustSection(context),
                            ],
                          ],
                        ),
                      ),
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

  Widget _buildLeftPanel(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;
    final visuals = context.webVisuals;

    return Container(
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
          color: palette.border.withValues(alpha: 0.50),
        ),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topProductPill(context),
          const SizedBox(height: 22),
          Text(
            'A calm sign-in flow for your AI workspace.',
            style: text.hero.copyWith(
              color: palette.textPrimary,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          TypingTexts(
            texts: const [
              'Resume chats, tools, and synced workflows.',
              'Access your saved preferences and workspace identity.',
              'Move from landing page to product access in one step.',
            ],
            style: text.body.copyWith(
              color: palette.accent,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Designed like a modern product sign-in page: focused, trustworthy, and fast to scan. QuantSpace keeps the form simple while reinforcing workspace access, saved history, and future cross-device sync.',
            style: text.body.copyWith(
              color: palette.textSecondary,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _miniInfoChip(context, Icons.history_rounded, 'Saved history'),
              _miniInfoChip(context, Icons.tune_rounded, 'Preferences'),
              _miniInfoChip(
                context,
                Icons.devices_rounded,
                'Cross-device access',
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildWorkspacePreviewCard(context),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  context,
                  'Access',
                  'Secure account flow',
                  Icons.verified_user_rounded,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _metricCard(
                  context,
                  'Speed',
                  'Cleaner onboarding',
                  Icons.bolt_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignInCard(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;

    return ClipRRect(
      borderRadius: BorderRadius.circular(metrics.radiusXl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: palette.surface.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(metrics.radiusXl),
            border: Border.all(
              color: palette.border.withValues(alpha: 0.38),
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(context),
              const SizedBox(height: 24),
              Text(
                'Welcome back',
                style: text.title.copyWith(
                  color: palette.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue to QuantSpace.',
                style: text.body.copyWith(
                  color: palette.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _socialButton(
                      context,
                      label: 'Google',
                      icon: Icons.public_rounded,
                      onTap: _continueWithGoogle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _socialButton(
                      context,
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      onTap: _continueWithGitHub,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _dividerWithText(context, 'or continue with email'),
              const SizedBox(height: 18),
              _fieldLabel(context, 'Email address'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: text.body.copyWith(color: palette.textPrimary),
                decoration: _inputDecoration(
                  context,
                  hintText: 'you@quantspace.ai',
                  prefixIcon: Icons.mail_outline_rounded,
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel(context, 'Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: text.body.copyWith(color: palette.textPrimary),
                decoration: _inputDecoration(
                  context,
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? true);
                    },
                  ),
                  Text(
                    'Remember me',
                    style: text.bodyMuted.copyWith(color: palette.textSecondary),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        _showSnackBar('Forgot password flow coming soon.'),
                    child: Text(
                      'Forgot password?',
                      style: text.button.copyWith(color: palette.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: HoverScaleButton(
                  onTap: _isSubmitting ? null : _submitSignIn,
                  hoverScale: 1.02,
                  pressedScale: 0.985,
                  borderRadius: BorderRadius.circular(metrics.radiusMd),
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitSignIn,
                    icon: _isSubmitting
                        ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _bestOnColor(palette.accent),
                      ),
                    )
                        : const Icon(Icons.login_rounded),
                    label: Text(
                      _isSubmitting ? 'Signing in...' : 'Sign in',
                    ),
                    style: _primaryButtonStyle(context),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: HoverScaleButton(
                  onTap: _goToSignUp,
                  hoverScale: 1.02,
                  pressedScale: 0.99,
                  borderRadius: BorderRadius.circular(metrics.radiusMd),
                  child: OutlinedButton.icon(
                    onPressed: _goToSignUp,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Create account'),
                    style: _outlineButtonStyle(context),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _trustStrip(context),
              const SizedBox(height: 18),
              Center(
                child: Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: text.bodyMuted.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToSignUp,
                      child: Text(
                        'Sign up here',
                        style: text.bodyMuted.copyWith(
                          color: palette.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    return Row(
      children: [
        const QuantSpaceBrandLogo(
          iconSize: 32,
          textSize: 22,
          showTagline: false,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: palette.accentSoft,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: palette.accent.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 15,
                color: palette.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Secure sign in',
                style: text.label.copyWith(color: palette.accent),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topProductPill(BuildContext context) {
    final palette = context.palette;

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
          Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: palette.accent,
          ),
          const SizedBox(width: 8),
          Text(
            'Welcome back to QuantSpace.ai',
            style: context.webText.label.copyWith(color: palette.accent),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspacePreviewCard(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workspace preview',
            style: text.sectionTitle.copyWith(
              color: palette.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 14),
          _previewRow(
            context,
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Saved chats',
            subtitle: 'Continue recent conversations faster.',
          ),
          const SizedBox(height: 12),
          _previewRow(
            context,
            icon: Icons.auto_awesome_rounded,
            title: 'Prompt flows',
            subtitle: 'Access smarter templates and workflows.',
          ),
          const SizedBox(height: 12),
          _previewRow(
            context,
            icon: Icons.settings_suggest_rounded,
            title: 'Account preferences',
            subtitle: 'Restore your interface and usage defaults.',
          ),
        ],
      ),
    );
  }

  Widget _previewRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {
    final palette = context.palette;
    final text = context.webText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: palette.accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: palette.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: text.button.copyWith(color: palette.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: text.bodyMuted.copyWith(
                  color: palette.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      ) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: palette.accent),
          const SizedBox(height: 12),
          Text(
            title,
            style: text.label.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: text.button.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;

    return HoverScaleButton(
      onTap: onTap,
      hoverScale: 1.015,
      pressedScale: 0.99,
      borderRadius: BorderRadius.circular(metrics.radiusMd),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          backgroundColor: palette.surfaceSoft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          side: BorderSide(
            color: palette.border.withValues(alpha: 0.28),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(metrics.radiusMd),
          ),
          textStyle: text.button,
        ),
      ),
    );
  }

  Widget _dividerWithText(BuildContext context, String label) {
    final palette = context.palette;
    final text = context.webText;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: palette.border.withValues(alpha: 0.28),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: text.label.copyWith(color: palette.textSecondary),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: palette.border.withValues(alpha: 0.28),
          ),
        ),
      ],
    );
  }

  Widget _trustStrip(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.18),
        ),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 10,
        children: [
          _trustItem(context, Icons.verified_user_rounded, 'Secure access'),
          _trustItem(context, Icons.history_toggle_off_rounded, 'Saved history'),
          _trustItem(context, Icons.sync_rounded, 'Future sync ready'),
        ],
      ),
    );
  }

  Widget _trustItem(BuildContext context, IconData icon, String label) {
    final palette = context.palette;
    final text = context.webText;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: palette.accent),
        const SizedBox(width: 8),
        Text(
          label,
          style: text.label.copyWith(color: palette.textPrimary),
        ),
      ],
    );
  }

  Widget _buildCompactTrustSection(BuildContext context) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why sign in?',
            style: text.sectionTitle.copyWith(
              color: palette.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          _trustItem(context, Icons.history_rounded, 'Resume saved chats'),
          const SizedBox(height: 10),
          _trustItem(context, Icons.tune_rounded, 'Keep your preferences'),
          const SizedBox(height: 10),
          _trustItem(context, Icons.devices_rounded, 'Access across devices'),
        ],
      ),
    );
  }

  Widget _miniInfoChip(BuildContext context, IconData icon, String label) {
    final palette = context.palette;
    final text = context.webText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: palette.border.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: palette.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: text.button.copyWith(color: palette.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String label) {
    final palette = context.palette;
    final text = context.webText;

    return Text(
      label,
      style: text.label.copyWith(
        color: palette.textSecondary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration(
      BuildContext context, {
        required String hintText,
        required IconData prefixIcon,
        Widget? suffix,
      }) {
    final palette = context.palette;
    final text = context.webText;
    final metrics = context.webMetrics;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(metrics.radiusMd),
      borderSide: BorderSide(
        color: palette.border.withValues(alpha: 0.28),
      ),
    );

    return InputDecoration(
      hintText: hintText,
      hintStyle: text.body.copyWith(color: palette.textSecondary),
      prefixIcon: Icon(prefixIcon, color: palette.textSecondary),
      suffixIcon: suffix,
      filled: true,
      fillColor: palette.surfaceSoft,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: palette.accent,
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Widget _buildBackgroundAura(BuildContext context) {
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
            top: -90,
            right: -20,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accent.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accentSoft.withValues(alpha: 0.22),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: 120,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accent.withValues(alpha: 0.06),
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