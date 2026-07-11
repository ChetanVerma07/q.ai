// lib/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'payments_screen.dart';
import 'credit_usage_screen.dart';
import 'edit_profile_screen.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _checkedInToday = false;

  final String _userName = 'Anubhav Singh';
  String _email = 'anubhav@quantspace.ai';
  String _phone = '+91 7290999906';
  final String _planName = 'Pro Plan';
  final int _creditsUsed = 128;
  final int _creditsTotal = 500;
  final int _dailyCheckins = 12;

  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFF1A1A1A);
  static const Color _card2 = Color(0xFF1F1F1F);
  static const Color _accent = Color(0xFFE57373);

  Future<void> _showEditInfoDialog() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentEmail: _email,
          currentPhone: _phone,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _email = result['email'] ?? _email;
        _phone = result['phone'] ?? _phone;
      });
    }
  }

  void _navigateToPayments() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PaymentsScreen()),
    );
  }

  void _navigateToCreditUsage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CreditUsageScreen()),
    );
  }

  void _navigateToSubscription() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
    );
  }

  void _openPaymentsFromBottomSheet() {
    Navigator.pop(context);
    Future.microtask(_navigateToPayments);
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Options',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select a payment mode, then continue to the payment screen.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _paymentTile(
                  Icons.credit_card,
                  'Credit / Debit Card',
                  onTap: _openPaymentsFromBottomSheet,
                ),
                _paymentTile(
                  Icons.account_balance_wallet,
                  'UPI',
                  onTap: _openPaymentsFromBottomSheet,
                ),
                _paymentTile(
                  Icons.account_balance,
                  'Net Banking',
                  onTap: _openPaymentsFromBottomSheet,
                ),
                _paymentTile(
                  Icons.receipt_long,
                  'Invoices & Billing History',
                  onTap: _openPaymentsFromBottomSheet,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openPaymentsFromBottomSheet,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      'Continue to Payments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _paymentTile(
      IconData icon,
      String title, {
        required VoidCallback onTap,
      }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: _accent),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right, color: _accent),
      onTap: onTap,
    );
  }

  void _toggleCheckIn() {
    setState(() => _checkedInToday = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily check-in complete. +10 credits awarded!'),
        backgroundColor: _accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double creditProgress =
    (_creditsUsed / _creditsTotal).clamp(0.0, 1.0);

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
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: _accent.withOpacity(0.2),
                    child: Text(
                      _userName.isNotEmpty ? _userName[0] : 'U',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: _accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _planName,
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _infoChip(Icons.phone, _phone),
                      _infoChip(Icons.mail_outline, _email),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showEditInfoDialog,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Credit Usage'),
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _navigateToCreditUsage,
                borderRadius: BorderRadius.circular(20),
                child: _cardBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Credits Used',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '$_creditsUsed / $_creditsTotal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: creditProgress,
                          minHeight: 10,
                          backgroundColor: Colors.white12,
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(_accent),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(creditProgress * 100).toStringAsFixed(1)}% of your plan used • ${_creditsTotal - _creditsUsed} credits remaining',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _navigateToCreditUsage,
                          icon: const Icon(Icons.bar_chart, size: 18),
                          label: const Text('View Detailed Usage'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Daily Check-In'),
            const SizedBox(height: 12),
            _cardBox(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      _checkedInToday
                          ? Icons.check_circle
                          : Icons.local_fire_department,
                      color: _accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _checkedInToday
                              ? 'Checked in today!'
                              : 'Check in for bonus credits',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Streak: $_dailyCheckins days',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _checkedInToday ? null : _toggleCheckIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _checkedInToday ? Colors.white24 : _accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(_checkedInToday ? 'Done' : 'Check In'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Payment & Billing'),
            const SizedBox(height: 12),
            _menuCard(
              icon: Icons.payment,
              title: 'Payment Options',
              subtitle: 'Cards, UPI, wallets',
              onTap: _showPaymentOptions,
            ),
            _menuCard(
              icon: Icons.workspace_premium,
              title: 'Subscription Plan',
              subtitle: 'Manage upgrades & renewals',
              onTap: _navigateToSubscription,
            ),
            const SizedBox(height: 24),

            _sectionTitle('Contact Info'),
            const SizedBox(height: 12),
            _menuCard(
              icon: Icons.phone,
              title: 'Phone Number',
              subtitle: _phone,
              onTap: () {},
            ),
            _menuCard(
              icon: Icons.mail_outline,
              title: 'Mail ID',
              subtitle: _email,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _accent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _cardBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _card2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _accent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _card2,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: _accent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: _accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
