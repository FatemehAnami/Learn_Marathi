import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MarathiMasterApp());
}

class MarathiMasterApp extends StatelessWidget {
  const MarathiMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Marathi Master",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}