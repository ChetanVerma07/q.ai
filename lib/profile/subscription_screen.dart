import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 1;

  static const Color _bg = Color(0xFF0B0B0F);
  static const Color _card = Color(0xFF17171C);
  static const Color _card2 = Color(0xFF1E1F25);
  static const Color _border = Color(0xFF2A2C35);
  static const Color _accent = Color(0xFFE57373);
  static const Color _textPrimary = Colors.white;
  static const Color _textSecondary = Color(0xFFB8BCC8);
  static const Color _textMuted = Color(0xFF8B90A0);
  static const Color _success = Color(0xFF7BD88F);

  final List<Map<String, dynamic>> _plans = [
    {
      'type': 'Type 1',
      'name': 'Freebie Plan',
      'price': '₹0',
      'period': '/month',
      'tag': 'Start here',
      'description':
      'Best for exploring QuantSpace.ai with basic access to core tools.',
      'features': [
        'Limited access to memory',
        'Limited access to models',
        'Limited access to image creation',
      ],
      'buttonText': 'Current Free Plan',
      'highlight': false,
    },
    {
      'type': 'Type 2',
      'name': 'Classic Plan',
      'price': '₹199',
      'period': '/month',
      'tag': 'Most popular',
      'description':
      'Great for regular users who want strong daily usage and project support.',
      'features': [
        'Unlimited daily searches',
        'Full credit usage breakdown',
        'Number of devices: 2',
        'Unlimited AI image generation',
        'Longer and more reliable memory',
        'More uploads',
        'Grid tasks and project works support',
      ],
      'buttonText': 'Choose Classic',
      'highlight': true,
    },
    {
      'type': 'Type 3',
      'name': 'Pro Plan',
      'price': '₹599',
      'period': '/month',
      'tag': 'Power users',
      'description':
      'Built for advanced workflows, deeper research, and next-level creation.',
      'features': [
        'Advanced reasoning models',
        'Better and faster memory',
        'Faster and better image creation',
        'Expanded deep search and study model',
        'Custom voice training',
        'Voice recognition model',
        'Early access to new features',
      ],
      'buttonText': 'Upgrade to Pro',
      'highlight': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 72,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: _textPrimary,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription',
          style: TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 22),
                  ...List.generate(
                    _plans.length,
                        (index) => _buildPlanCard(
                      index: index,
                      plan: _plans[index],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildFooterNote(),
                ],
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.10),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'QuantSpace.ai Premium',
              style: TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Choose the plan that matches your AI workflow.',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 24,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'From casual use to advanced research, image generation, memory, and voice tools — scale up when you need more power.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _statChip(
                  icon: Icons.flash_on,
                  label: 'AI-first plans',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statChip(
                  icon: Icons.psychology_alt_outlined,
                  label: 'Model upgrades',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Icon(icon, color: _accent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required Map<String, dynamic> plan,
  }) {
    final bool isSelected = _selectedPlanIndex == index;
    final bool isHighlighted = plan['highlight'] == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? _card2 : _card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected || isHighlighted ? _accent : _border,
            width: isSelected || isHighlighted ? 1.3 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _accent.withOpacity(0.16),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _pill(
                        text: plan['type'],
                        color: isSelected ? _accent : _textMuted,
                        bgColor: isSelected
                            ? _accent.withOpacity(0.14)
                            : Colors.white.withOpacity(0.05),
                      ),
                      _pill(
                        text: plan['tag'],
                        color: isHighlighted ? _accent : _textSecondary,
                        bgColor: isHighlighted
                            ? _accent.withOpacity(0.12)
                            : Colors.white.withOpacity(0.04),
                      ),
                    ],
                  ),
                ),
                Container(
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
            ),
            const SizedBox(height: 14),
            Text(
              plan['name'],
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan['price'],
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    plan['period'],
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plan['description'],
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 16),
            ...(plan['features'] as List<String>).map(
                  (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle,
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
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedPlanIndex = index;
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected ? _accent : Colors.transparent,
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? _accent : _border,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  plan['buttonText'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill({
    required String text,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: _textMuted,
            size: 18,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Plans are shown in Indian Rupees per month. Premium features are designed for faster workflows, deeper research, stronger memory, and richer multimodal creation.',
              style: TextStyle(
                color: _textMuted,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    final selectedPlan = _plans[_selectedPlanIndex];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: BoxDecoration(
        color: _card,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPlan['name'],
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selectedPlan['price']}${selectedPlan['period']}',
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _accent,
                      content: Text(
                        '${selectedPlan['name']} selected',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
