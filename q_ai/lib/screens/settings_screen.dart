// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/loading_skeleton.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'chat_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  bool _notifications = true;
  bool _darkMode = true;
  String _language = 'English';
  double _chatHistorySize = 50.0;

  final List<String> _languages = ['English', 'Hindi', 'Spanish', 'French'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryRed,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.primaryRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const HistoryLoadingSkeleton()
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.redBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.redDark,
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 35,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Guest User',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign In for Full Access',
                            style: TextStyle(color: AppTheme.primaryRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _navigateToProfile(context),
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryRed,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSettingsTile(
              context,
              title: 'Profile',
              icon: Icons.person_outline,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryRed,
              ),
              onTap: () => _navigateToProfile(context),
            ),

            const SizedBox(height: 32),

            const Text(
              'Account & Privacy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryRed,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),

            _buildSettingsTile(
              context,
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              trailing: Switch(
                value: _notifications,
                onChanged: (value) =>
                    setState(() => _notifications = value),
                activeColor: AppTheme.primaryRed,
                activeTrackColor: AppTheme.primaryRed.withOpacity(0.5),
              ),
            ),
            _buildSettingsTile(
              context,
              title: 'Dark Mode',
              icon: Icons.dark_mode,
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
                activeColor: AppTheme.primaryRed,
                activeTrackColor: AppTheme.primaryRed.withOpacity(0.5),
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryRed,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),

            _buildSettingsTile(
              context,
              title: 'Language',
              icon: Icons.language,
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _language,
                  iconEnabledColor: AppTheme.textSecondary,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  items: _languages
                      .map(
                        (lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    ),
                  )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _language = value!),
                ),
              ),
            ),

            _buildSettingsTile(
              context,
              title: 'AI Chat',
              icon: Icons.chat,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryRed,
              ),
              onTap: () => _navigateToChat(context),
            ),

            _buildSettingsTile(
              context,
              title: 'Chat History',
              icon: Icons.history,
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryRed,
              ),
              onTap: () => _navigateToHistory(context),
            ),

            _buildSettingsTile(
              context,
              title: 'Chat History Size (MB)',
              icon: Icons.storage,
              trailing: SizedBox(
                width: 140,
                child: Slider(
                  value: _chatHistorySize,
                  min: 10,
                  max: 200,
                  divisions: 19,
                  label: '${_chatHistorySize.round()} MB',
                  activeColor: AppTheme.primaryRed,
                  inactiveColor: AppTheme.surfaceLight,
                  onChanged: (value) =>
                      setState(() => _chatHistorySize = value),
                ),
              ),
            ),

            const SizedBox(height: 48),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMedium.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.redDark, width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.redDark.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete_forever,
                          color: AppTheme.redDark,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Clear All Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _showClearDataDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.redDark,
                            foregroundColor: AppTheme.textPrimary,
                          ),
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSettingsTile(
              context,
              title: 'About Q.Ai',
              icon: Icons.info_outline,
              trailing: const Text(
                'v1.0.0',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, {
        required String title,
        required IconData icon,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceLight, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.primaryRed),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text(
          'Clear All Data',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'This will delete all chat history, settings, and cached data. This action cannot be undone.',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'All data cleared successfully!',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                  backgroundColor: AppTheme.primaryRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.redDark,
              foregroundColor: AppTheme.textPrimary,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Q.Ai',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppTheme.primaryRed,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.smart_toy, color: AppTheme.textPrimary),
      ),
      children: const [
        Text(
          'Your AI companion for smarter conversations.',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
      ],
    );
  }
}