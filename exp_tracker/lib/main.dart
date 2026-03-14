import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/navigation_service.dart';
import 'core/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initializing Firebase (Requires valid configuration generated via flutterfire configure)
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Note: It's expected to throw an error initially until `flutterfire configure` is run.
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Initialize your providers here, e.g.,
        // ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<String>(create: (_) => 'DummyProvider'),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: AppTheme.lightTheme,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: AppRoutes.onboarding,
        routes: AppRoutes.routes,
      ),
    );
  }
}
