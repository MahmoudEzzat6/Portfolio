import 'package:flutter/material.dart';

enum ThemePalette {
  cyberIndigo,
  emeraldMint,
  midnightCobalt,
  crimsonRose,
}

class PortfolioThemeData {
  final ThemePalette palette;
  final String name;
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color surfaceHover;
  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderGlow;
  final LinearGradient primaryGradient;
  final LinearGradient accentGradient;

  const PortfolioThemeData({
    required this.palette,
    required this.name,
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.surfaceHover,
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.accent,
    this.textPrimary = const Color(0xFFF8FAFC),
    this.textSecondary = const Color(0xFF94A3B8),
    this.textMuted = const Color(0xFF64748B),
    required this.border,
    required this.borderGlow,
    required this.primaryGradient,
    required this.accentGradient,
  });
}

class AppThemes {
  static const PortfolioThemeData cyberIndigo = PortfolioThemeData(
    palette: ThemePalette.cyberIndigo,
    name: 'Cyber Indigo',
    background: Color(0xFF090D16),
    surface: Color(0xFF101726),
    surfaceLight: Color(0xFF192238),
    surfaceHover: Color(0xFF232E4A),
    primary: Color(0xFF6366F1),
    primaryLight: Color(0xFF818CF8),
    secondary: Color(0xFF8B5CF6),
    accent: Color(0xFF06B6D4),
    border: Color(0xFF1E293B),
    borderGlow: Color(0xFF334155),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const PortfolioThemeData emeraldMint = PortfolioThemeData(
    palette: ThemePalette.emeraldMint,
    name: 'Emerald Matrix',
    background: Color(0xFF061210),
    surface: Color(0xFF0C1F1B),
    surfaceLight: Color(0xFF14302A),
    surfaceHover: Color(0xFF1B4038),
    primary: Color(0xFF10B981),
    primaryLight: Color(0xFF34D399),
    secondary: Color(0xFF059669),
    accent: Color(0xFF38BDF8),
    border: Color(0xFF13362E),
    borderGlow: Color(0xFF1D4D42),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF059669)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF34D399), Color(0xFF38BDF8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const PortfolioThemeData midnightCobalt = PortfolioThemeData(
    palette: ThemePalette.midnightCobalt,
    name: 'Midnight Cobalt',
    background: Color(0xFF080D1A),
    surface: Color(0xFF0F172A),
    surfaceLight: Color(0xFF1E293B),
    surfaceHover: Color(0xFF293548),
    primary: Color(0xFF3B82F6),
    primaryLight: Color(0xFF60A5FA),
    secondary: Color(0xFF6366F1),
    accent: Color(0xFFA855F7),
    border: Color(0xFF1E293B),
    borderGlow: Color(0xFF334155),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFF60A5FA), Color(0xFFA855F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const PortfolioThemeData crimsonRose = PortfolioThemeData(
    palette: ThemePalette.crimsonRose,
    name: 'Crimson Titanium',
    background: Color(0xFF100A10),
    surface: Color(0xFF1A111A),
    surfaceLight: Color(0xFF291B29),
    surfaceHover: Color(0xFF3B253B),
    primary: Color(0xFFF43F5E),
    primaryLight: Color(0xFFFB7185),
    secondary: Color(0xFFE11D48),
    accent: Color(0xFFF59E0B),
    border: Color(0xFF331E33),
    borderGlow: Color(0xFF4A2B4A),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [Color(0xFFFB7185), Color(0xFFF59E0B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static PortfolioThemeData getTheme(ThemePalette palette) {
    switch (palette) {
      case ThemePalette.cyberIndigo:
        return cyberIndigo;
      case ThemePalette.emeraldMint:
        return emeraldMint;
      case ThemePalette.midnightCobalt:
        return midnightCobalt;
      case ThemePalette.crimsonRose:
        return crimsonRose;
    }
  }

  static ThemeData buildTheme(PortfolioThemeData t) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: t.background,
      primaryColor: t.primary,
      cardColor: t.surface,
      dividerColor: t.border,
      colorScheme: ColorScheme.dark(
        primary: t.primary,
        secondary: t.secondary,
        surface: t.surface,
      ),
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
          color: t.textPrimary,
          height: 1.15,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: t.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: t.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: t.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: t.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: t.textSecondary,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: t.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }
}
