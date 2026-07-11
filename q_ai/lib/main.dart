import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';

import 'screens/boot_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

import 'web/web_home_screen.dart';
import 'web/sign_in_page.dart';

import 'profile/credit_usage_screen.dart';
import 'profile/edit_profile_screen.dart';
import 'profile/payments_screen.dart';
import 'profile/profile_screen.dart';
import 'profile/subscription_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(
    const ProviderScope(
      child: QAiApp(),
    ),
  );
}

class QAiApp extends StatelessWidget {
  const QAiApp({super.key});

  static const String _initialRoute = kIsWeb ? '/web-home' : '/splash';
  static const String _defaultHomeRoute = kIsWeb ? '/web-home' : '/home';

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: AppTheme.backgroundBlack,
        child: Scaffold(
          backgroundColor: AppTheme.backgroundBlack,
          appBar: AppBar(
            title: const Text(
              'App Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppTheme.primaryRed,
            foregroundColor: AppTheme.textPrimary,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: AppTheme.textPrimary,
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bug_report_rounded,
                      size: 72,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Something went wrong!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tap the button below to restart the app.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
                        _initialRoute,
                            (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppTheme.textPrimary,
                    ),
                    label: const Text(
                      'Restart App',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: AppTheme.textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };

    return MaterialApp(
      title: 'Q.Ai',
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      initialRoute: _initialRoute,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/boot': (context) => const BootScreen(),

        '/home': (context) => const HomeScreen(),
        '/web-home': (context) => const WebHomeScreen(),

        '/signin': (context) => kIsWeb
            ? const SignInPage()
            : const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),

        '/settings': (context) => const SettingsScreen(),
        '/history': (context) => const HistoryScreen(),
        '/chat': (context) => const ChatScreen(),

        '/profile': (context) => const ProfileScreen(),
        '/payments': (context) => const PaymentsScreen(),
        '/credit-usage': (context) => const CreditUsageScreen(),
        '/subscription': (context) => const SubscriptionScreen(),

        '/edit-profile': (context) => const EditProfileScreen(
          currentEmail: '',
          currentPhone: '',
        ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/signin') {
          return MaterialPageRoute(
            builder: (_) => kIsWeb
                ? const SignInPage()
                : const SignInScreen(),
            settings: settings,
          );
        }

        if (settings.name == '/edit-profile') {
          final args = settings.arguments;

          if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (_) => EditProfileScreen(
                currentEmail: args['currentEmail']?.toString() ?? '',
                currentPhone: args['currentPhone']?.toString() ?? '',
              ),
              settings: settings,
            );
          }

          return MaterialPageRoute(
            builder: (_) => const EditProfileScreen(
              currentEmail: '',
              currentPhone: '',
            ),
            settings: settings,
          );
        }

        if (settings.name == '/chat') {
          return MaterialPageRoute(
            builder: (_) => const ChatScreen(),
            settings: settings,
          );
        }

        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: AppTheme.backgroundBlack,
            appBar: AppBar(
              title: const Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: AppTheme.textPrimary,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: AppTheme.textPrimary,
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 72,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Page Not Found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      settings.name ?? 'Unknown route',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          _defaultHomeRoute,
                              (route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.home_rounded,
                        color: AppTheme.textPrimary,
                      ),
                      label: const Text(
                        'Go to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: AppTheme.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          settings: settings,
        );
      },
    );
  }
}