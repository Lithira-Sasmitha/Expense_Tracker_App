import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_shell.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/add/presentation/pages/add_page.dart';
import '../../features/report/presentation/pages/report_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String add = '/add';
  static const String report = '/report';
  static const String profile = '/profile';

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: add, builder: (context, state) => const AddPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: report,
                builder: (context, state) => const ReportPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Global Navigator Key Helper if needed for older tools or popups
extension NavigatorKeyExtension on GlobalKey<NavigatorState> {
  // Add helper methods if needed
}
