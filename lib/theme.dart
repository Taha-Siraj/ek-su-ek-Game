import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MidnightNeonTheme {
  // Core Premium Corporate Design System (Gold / Charcoal / Platinum)
  static const Color primary = Color(0xFFF9F6EE); // Warm Ivory
  static const Color primaryContainer = Color(0xFFD4AF37); // Champagne Gold Accent
  static const Color secondary = Color(0xFFE5E5E5); // Platinum
  static const Color secondaryContainer = Color(0xFF8E8E93); // Sleek Cool Grey
  static const Color bgPrimary = Color(0xFF121212); // Deep Graphite Base
  static const Color bgSecondary = Color(0xFF1C1C1E); // Matte Black / Dark Charcoal
  static const Color surface = Color(0xFF1C1C1E); // Card Surface
  static const Color surfaceContainerLow = Color(0xFF2C2C2E); // Inner Containers
  static const Color borderGlass = Color(0x1EFFFFFF); // Premium Border (12% White)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAEB8C4); // Muted Silver

  // Semantic Colors
  static const Color success = Color(0xFF34C759); // Premium Emerald Green
  static const Color danger = Color(0xFFFF3B30); // Crimson Ruby Red
  static const Color accentPurple = Color(0xFF5856D6); // Royal Indigo

  // Border Radius
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 10.0;
  static const double radiusLarge = 18.0;
  static const double radiusExtraLarge = 28.0;

  // Spacing
  static const double spacingUnit = 4.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 40.0;
  static const double containerMargin = 20.0;

  // Background Gradient Decoration
  static BoxDecoration get radialBackground {
    return const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [
          bgSecondary,
          bgPrimary,
        ],
      ),
    );
  }

  // Premium Modern Typography (Plus Jakarta Sans & JetBrains Mono)
  static TextStyle get displayLg => GoogleFonts.plusJakartaSans(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.96,
        color: textPrimary,
      );

  static TextStyle get displayDigit => GoogleFonts.jetBrainsMono(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
        color: textPrimary,
      );

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  static TextStyle get labelCaps => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: textSecondary,
      );

  static TextStyle get buttonText => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.32,
        color: bgPrimary,
      );
}
