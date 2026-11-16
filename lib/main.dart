import 'package:flutter/material.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahmoud Ezzat | Mid-Level Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.buildTheme(AppThemes.cyberIndigo),
      home: const PortfolioScreen(),
    );
  }
}
