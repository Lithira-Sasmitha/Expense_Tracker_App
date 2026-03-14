import 'package:flutter/material.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/login_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
      };
}
