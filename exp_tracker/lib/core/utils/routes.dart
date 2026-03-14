import 'package:flutter/material.dart';
import '../../views/screens/home_screen.dart';
import '../../views/screens/onboarding_screen.dart';
import '../../views/screens/login_screen.dart';
import '../../views/screens/register_screen.dart';
import '../../views/screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const HomeScreen(),
      };
}
