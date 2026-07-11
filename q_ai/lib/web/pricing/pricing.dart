import 'dart:ui';
import 'package:flutter/material.dart';
import 'typing_text_pricing.dart';
import 'hover_pricing_button.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  int _activePlanIndex = 1;
  bool _isYearly = true;

  // -------------------------------------------------------------
  // CLAUDE-INSPIRED DARK PALETTE
  // -------------------------------------------------------------
  static const Color _bg = Color(0xFF171411);         // Deep charcoal/brown background
  static const Color _bg2 = Color(0xFF201C18);        // Slightly lighter background
  static const Color _surface = Color(0xFF1E1A16);    // Card surface
  static const Color _surface2 = Color(0xFF27221D);   // Lighter card surface
  static const Color _surface3 = Color(0xFF322C26);   // Active card surface
  static const Color _border = Color(0xFF494139);     // Warm grey border
  static const Color _accent = Color(0xFFD97757);     // Earthy Rust/Orange (Primary focus)
  static const Color _accent2 = Color(0xFFE2B089);    // Soft Sand/Peach (Secondary/Highlights)
  static const Color _accentSoft = Color(0x26D97757); // Transparent rust
  static const Color _textPrimary = Color(0xFFF6F1EA); // Warm cream text
  static const Color _textSecondary = Color(0xFFB7ADA0); // Sand text
  static const Color _textMuted = Color(0xFF8C8276);  // Deep sand text
  static const Color _success = Color(0xFF73A884);    // Earthy moss green
  static const Color _warning = Color(0xFFD49A57);    // Warm mustard gold

  final List<Map<String, dynamic>> _planData = [
    {
      'type': 'Starter',
      'name': 'Freebie Plan',
      'monthlyPrice': 0,
      'yearlyPrice': 0,
      'tag': 'Start free',
      'description':
      'Perfect for exploring QuantSpace.ai before you commit. Get a feel for chat, search, and essential creative tools at zero cost.',
      'idealFor':
      'Best for curious users, first-time learners, and light experimentation.',
      'features': [
        'Basic AI chat for everyday questions',
        'Limited search and memory access',
        'Entry-level image generation',
        'Standard model support',
        'Community usage limits',
      ],
      'buttonText': 'Start Free',
      'subCta': 'No payment required',
      'highlight': false,
    },
    {
      'type': 'Recommended',
      'name': 'Classic Plan',
      'monthlyPrice': 199,
      'yearlyPrice': 1990,
      'tag': 'Most popular',
      'description':
      'The smartest choice for most users. Unlock a smoother daily workflow with more searches, stronger memory, richer file handling, and unlimited image generation.',
      'idealFor':
      'Best for students, creators, developers, and everyday power users.',
      'features': [
        'Unlimited daily searches',
        'Full credit usage visibility',
        'Use on up to 2 devices',
        'Unlimited AI image generation',
        'Longer and more reliable memory',
        'More uploads and deeper file analysis',
        'Project and grid-task workflow support',
      ],
      'buttonText': 'Choose Classic',
      'subCta': 'Best value for regular use',
      'highlight': true,
    },
    {
      'type': 'Advanced',
      'name': 'Pro Plan',
      'monthlyPrice': 599,
      'yearlyPrice': 5990,
      'tag': 'Power users',
      'description':
      'Built for serious builders and advanced research. Get premium reasoning, faster workflows, multimodal power, and early access to the newest capabilities.',
      'idealFor':
      'Best for researchers, coders, teams, and advanced AI-heavy workflows.',
      'features': [
        'Advanced reasoning models',
        'Faster and more powerful memory',
        'Higher quality image creation',
        'Expanded deep search and study mode',
        'Custom voice training tools',
        'Voice recognition model access',
        'Priority access to experimental features',
      ],
      'buttonText': 'Upgrade to Pro',
      'subCta': 'For maximum capability',
      'highlight': false,
    },
  ];

  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700;

  int _resolvePrice(Map<String, dynamic> plan) {
    return _isYearly ? plan['yearlyPrice'] as int : plan['monthlyPrice'] as int;
  }

  String _priceLabel(Map<String, dynamic> plan) {
    final int price = _resolvePrice(plan);
    if (price == 0) return '₹0';
    return '₹$price';
  }

  String _periodLabel() => _isYearly ? '/year' : '/month';

  int _yearlySavings(Map<String, dynamic> plan) {
    final int monthly = plan['monthlyPrice'] as int;
    final int yearly = plan['yearlyPrice'] as int;

    if (monthly == 0 || yearly == 0) return 0;
    return (monthly * 12) - yearly;
  }

  String _annualSavingsText(Map<String, dynamic> plan) {
    final int savings = _yearlySavings(plan);
    if (savings <= 0) return 'Flexible billing';
    return 'Save ₹$savings yearly';
  }

  String _effectiveMonthly(Map<String, dynamic> plan) {
    final int yearlyPrice = plan['yearlyPrice'] as int;
    if (yearlyPrice == 0) return 'Free forever';

    final double monthlyEquivalent = yearlyPrice / 12;
    return 'Only ₹${monthlyEquivalent.toStringAsFixed(0)}/month when billed yearly';
  }

  void _updateSelectedPlan(int index) {
    setState(() {
      _activePlanIndex = index;
    });
  }

  void _showSelectionSnackBar(String selectedPlanName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _accent,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '$selectedPlanName selected',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool desktopView = _isDesktop(context);
    final bool tabletView = _isTablet(context);

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          _buildBackgroundDecor(),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, desktop: desktopView),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      desktopView ? 32 : 16,
                      12,
                      desktopView ? 32 : 16,
                      28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1380),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroSection(desktop: desktopView),
                            const SizedBox(height: 24),
                            _buildValueStrip(desktop: desktopView),
                            const SizedBox(height: 24),
                            _buildBillingToggle(),
                            const SizedBox(height: 24),
                            if (desktopView)
                              _buildDesktopPlans()
                            else if (tabletView)
                              _buildTabletPlans()
                            else
                              _buildMobilePlans(),
                            const SizedBox(height: 22),
                            _buildComparisonStrip(),
                            const SizedBox(height: 22),
                            _buildTrustRow(),
                            const SizedBox(height: 22),
                            _buildFooterNote(),
                            const SizedBox(height: 40),
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

  Widget _buildTopBar(BuildContext context, {required bool desktop}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(desktop ? 24 : 12, 14, desktop ? 24 : 12, 0),
      child: Row(
        children: [
          _glassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Plans & Pricing',
              style: TextStyle(
                color: _textPrimary,
                fontSize: desktop ? 22 : 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),
          if (desktop) ...[
            _miniNavPill('Free'),
            const SizedBox(width: 8),
            _miniNavPill('Classic'),
            const SizedBox(width: 8),
            _miniNavPill('Pro'),
          ],
        ],
      ),
    );
  }

  Widget _miniNavPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _textSecondary,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: Colors.white.withOpacity(0.045),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.07)),
              ),
              child: Icon(
                icon,
                color: _textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_bg, _bg2, _bg],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent.withOpacity(0.12),
            ),
          ),
        ),
        Positioned(
          top: 140,
          right: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent2.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: 160,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent.withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection({required bool desktop}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(desktop ? 30 : 20),
      // Muted hero section glow matching claude aesthetics
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            _surface2,
            _bg2,
            _surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: desktop
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: _heroCopy(desktop)),
          const SizedBox(width: 24),
          Expanded(flex: 4, child: _heroSignalCard()),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroCopy(desktop),
          const SizedBox(height: 18),
          _heroSignalCard(),
        ],
      ),
    );
  }

  Widget _heroCopy(bool desktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _accent.withOpacity(0.18)),
          ),
          child: const Text(
            'QuantSpace.ai Premium Access',
            style: TextStyle(
              color: _accent2,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Upgrade only when the value becomes obvious.',
          style: TextStyle(
            color: _textPrimary,
            fontSize: desktop ? 42 : 28,
            height: 1.08,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.3,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: desktop ? 34 : 56,
          // Using your integrated TypingTextPricing
          child: TypingTextPricing(
            texts: const [
              'Compare plans based on how deeply you search.',
              'Choose by how much memory and file power you need.',
              'Scale from free exploration to advanced AI workflows.',
              'Pay more only when your daily usage truly grows.',
            ],
            typingSpeed: const Duration(milliseconds: 32),
            pauseDuration: const Duration(milliseconds: 1400),
            repeat: true,
            style: const TextStyle(
              color: _accent2,
              fontSize: 16,
              height: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'From free exploration to advanced AI workflows, QuantSpace.ai gives you room to grow. Pick a plan based on how deeply you search, create, upload, reason, and build every day.',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 14.5,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 18),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _HeroChip(
              icon: Icons.flash_on_rounded,
              label: 'Fast AI workflows',
            ),
            _HeroChip(
              icon: Icons.workspace_premium_rounded,
              label: 'Clear value tiers',
            ),
            _HeroChip(
              icon: Icons.savings_rounded,
              label: 'Annual savings',
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroSignalCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why people upgrade',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            // Using your integrated TypingTextPricing
            child: TypingTextPricing(
              texts: const [
                'More search power for faster answers.',
                'Longer memory for better continuity.',
                'More image generation as your work scales.',
                'Advanced tools for serious AI workflows.',
              ],
              typingSpeed: const Duration(milliseconds: 30),
              pauseDuration: const Duration(milliseconds: 1100),
              repeat: true,
              style: const TextStyle(
                color: _warning,
                fontSize: 13.2,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _featureRow(
            icon: Icons.search_rounded,
            text: 'More searching power for faster answers and deeper discovery',
          ),
          _featureRow(
            icon: Icons.memory_rounded,
            text: 'Longer memory for more consistent and reliable workflows',
          ),
          _featureRow(
            icon: Icons.image_rounded,
            text: 'Unlimited or higher quality image generation as work scales',
          ),
          _featureRow(
            icon: Icons.graphic_eq_rounded,
            text:
            'Voice, multimodal, and advanced reasoning tools for serious users',
          ),
        ],
      ),
    );
  }

  Widget _featureRow({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _accent2, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 13.2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueStrip({required bool desktop}) {
    final List<Map<String, dynamic>> infoCards = [
      {
        'title': 'Simple 3-tier pricing',
        'subtitle': 'Easy to compare and choose confidently.',
        'icon': Icons.view_carousel_rounded,
      },
      {
        'title': 'Annual plans save more',
        'subtitle': 'See the discount clearly before buying.',
        'icon': Icons.currency_rupee_rounded,
      },
      {
        'title': 'Clear recommended plan',
        'subtitle': 'Classic is highlighted for most users.',
        'icon': Icons.local_fire_department_rounded,
      },
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: infoCards
          .map(
            (item) => Container(
          width: desktop ? 320 : double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: _accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['subtitle'] as String,
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildBillingToggle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _billingOption(
              label: 'Monthly',
              selected: !_isYearly,
              onTap: () => setState(() => _isYearly = false),
            ),
            _billingOption(
              label: 'Annual',
              trailing: 'Save more',
              selected: _isYearly,
              onTap: () => setState(() => _isYearly = true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    String? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? _accent : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : _textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.20)
                      : _accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  trailing,
                  style: TextStyle(
                    color: selected ? Colors.white : _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopPlans() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_planData.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index != _planData.length - 1 ? 18 : 0,
            ),
            child: _buildPlanCard(index: index, plan: _planData[index]),
          ),
        );
      }),
    );
  }

  Widget _buildTabletPlans() {
    return Column(
      children: List.generate(
        _planData.length,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildPlanCard(index: index, plan: _planData[index]),
        ),
      ),
    );
  }

  Widget _buildMobilePlans() {
    return Column(
      children: List.generate(
        _planData.length,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildPlanCard(index: index, plan: _planData[index]),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required Map<String, dynamic> plan,
  }) {
    final bool isSelected = _activePlanIndex == index;
    final bool isHighlighted = plan['highlight'] == true;

    return GestureDetector(
      onTap: () => _updateSelectedPlan(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: isSelected
                ? [_surface3, _surface2, _surface]
                : [_surface, _surface2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isSelected || isHighlighted ? _accent : _border,
            width: isSelected || isHighlighted ? 1.4 : 1.0,
          ),
          boxShadow: [
            if (isSelected || isHighlighted)
              BoxShadow(
                color: _accent.withOpacity(isSelected ? 0.08 : 0.04), // Softer glow for Claude
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlanTopRow(
              plan: plan,
              isSelected: isSelected,
              isHighlighted: isHighlighted,
            ),
            const SizedBox(height: 16),
            Text(
              plan['name'] as String,
              style: TextStyle(
                color: isHighlighted ? _accent2 : _textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _priceLabel(plan),
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 38,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.1,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    _periodLabel(),
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isYearly ? _effectiveMonthly(plan) : _annualSavingsText(plan),
              style: const TextStyle(
                color: _warning,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              plan['description'] as String,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 14,
                height: 1.58,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                plan['idealFor'] as String,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 12.8,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Divider(color: Colors.white.withOpacity(0.04), height: 1),
            const SizedBox(height: 18),
            ...(plan['features'] as List<String>).map(
                  (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: _success,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (isHighlighted) ...[
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: _accentSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _accent.withOpacity(0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why Classic stands out',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 38,
                      // Using your integrated TypingTextPricing
                      child: TypingTextPricing(
                        texts: const [
                          'Best balance of price and capability.',
                          'Most practical plan for everyday power users.',
                          'Strong enough for students, creators, and developers.',
                          'The easiest upgrade choice for regular usage.',
                        ],
                        typingSpeed: const Duration(milliseconds: 28),
                        pauseDuration: const Duration(milliseconds: 1200),
                        repeat: true,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 12.6,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            // ----------------------------------------------------
            // HIGH INTENSITY HOVER BUTTON INTEGRATION BELOW
            // ----------------------------------------------------
            HoverPricingButton(
              onTap: () {
                _updateSelectedPlan(index);
                _showSelectionSnackBar(plan['name'] as String);
              },
              enableGlow: isSelected || isHighlighted,
              glowColor: _accent.withOpacity(0.4),
              child: IgnorePointer(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {}, // Keeps the active state UI visible for the button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected || isHighlighted
                          ? _accent
                          : Colors.white.withOpacity(0.04), // Stepping down opacity
                      foregroundColor: isSelected || isHighlighted ? Colors.white : _textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: BorderSide(
                        color: isSelected || isHighlighted
                            ? _accent
                            : Colors.white.withOpacity(0.06),
                      ),
                    ),
                    child: Text(
                      plan['buttonText'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ----------------------------------------------------
            const SizedBox(height: 10),
            Center(
              child: Text(
                plan['subCta'] as String,
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 12.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanTopRow({
    required Map<String, dynamic> plan,
    required bool isSelected,
    required bool isHighlighted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(
                text: plan['type'] as String,
                color: isSelected ? _textPrimary : _textSecondary,
                bgColor: isSelected
                    ? _accent.withOpacity(0.16)
                    : Colors.white.withOpacity(0.05),
              ),
              _pill(
                text: plan['tag'] as String,
                color: isHighlighted ? _success : _textSecondary,
                bgColor: isHighlighted
                    ? _success.withOpacity(0.12)
                    : Colors.white.withOpacity(0.04),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? _accent : _textMuted,
              width: 1.5,
            ),
            color: isSelected ? _accent : Colors.transparent,
          ),
          child: isSelected
              ? const Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          )
              : null,
        ),
      ],
    );
  }

  Widget _pill({
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildComparisonStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: const Wrap(
        spacing: 18,
        runSpacing: 18,
        children: [
          _ComparisonItem(
            title: 'Freebie',
            subtitle: 'A zero-cost entry point to understand the platform.',
          ),
          _ComparisonItem(
            title: 'Classic',
            subtitle:
            'The strongest balance of affordability and daily utility.',
          ),
          _ComparisonItem(
            title: 'Pro',
            subtitle:
            'Maximum depth for advanced users and serious workflows.',
          ),
        ],
      ),
    );
  }

  Widget _buildTrustRow() {
    final List<String> trustItems = [
      'Transparent pricing',
      'Clear feature progression',
      'No confusing plan overload',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 12,
        children: trustItems
            .map(
              (item) => Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF73A884), // Changed to _success moss green
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFFB7ADA0), // Changed to _textSecondary sand
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF8C8276), // Changed to _textMuted warm grey
            size: 18,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Prices are shown in Indian Rupees. The screen is designed to make buying easier with clearer plan positioning, visible annual value, stronger call-to-action wording, and a more persuasive upgrade experience.',
              style: TextStyle(
                color: Color(0xFF8C8276), // Changed to _textMuted warm grey
                fontSize: 12.8,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFE2B089), size: 17), // Changed to _accent2 Sand
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB7ADA0), // Changed to _textSecondary
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ComparisonItem({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF27221D), // Changed to _surface2 lighter card
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF6F1EA), // Changed to _textPrimary cream
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFB7ADA0), // Changed to _textSecondary sand
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
