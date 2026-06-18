import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color ivory = Color(0xFFF4F1E9);
  static const Color warmWhite = Color(0xFFFDFBF5);
  static const Color ink = Color(0xFF3A2E1F);
  static const Color tan = Color(0xFF8C7F63);
  static const Color sand = Color(0xFFE5DEC7);
  static const Color sand2 = Color(0xFFD8CBA8);
  static const Color forest = Color(0xFF3C5E47);
  static const Color gold = Color(0xFFD4A33E);
  static const Color rose = Color(0xFFB4716E);
  static const Color clay = Color(0xFFC76B3C);
  static const Color brick = Color(0xFF8C2F22);
  static const Color bronze = Color(0xFFA87B4F);

  // Status tiers matching the CSS prototype
  static const Color tierCrossVerifiedBg = Color(0x1F3C5E47); // 12% opacity
  static const Color tierDocumentConsistentBg = Color(0x29D4A33E); // 16% opacity
  static const Color tierPartialMatchBg = Color(0x24C76B3C); // 14% opacity
  static const Color tierNeedsProofBg = Color(0x24B4716E); // 14% opacity
  static const Color tierFlaggedBg = Color(0x198C2F22); // 10% opacity
}

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        primary: AppColors.forest,
        secondary: AppColors.rose,
        surface: AppColors.warmWhite,
        background: AppColors.ivory,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.poppins(
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.ink,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.ink,
        ),
        bodySmall: GoogleFonts.poppins(
          color: AppColors.tan,
        ),
        labelLarge: GoogleFonts.poppins(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.poppins(
          color: AppColors.tan,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Get stylized heading text style
  static TextStyle headingStyle({double fontSize = 24, FontWeight fontWeight = FontWeight.bold, Color color = AppColors.ink}) {
    return GoogleFonts.fraunces(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Get Poppins body style
  static TextStyle bodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.ink,
    String? fontFamily,
  }) {
    if (fontFamily != null) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Button text style
  static TextStyle buttonTextStyle({double fontSize = 15, Color color = Colors.white}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
