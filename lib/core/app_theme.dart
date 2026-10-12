import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors matching the UI design
  static const Color primaryOrange = Color(0xFFFA8427);
  static const Color primaryOrangeLight = Color(0xFFFF9E50);
  static const Color primaryOrangeDark = Color(0xFFE56F10);

  // Translation blue (matching the 'A' bubble in the design)
  static const Color translatorBlue = Color(0xFF1976D2);
  static const Color translatorBlueLight = Color(0xFF42A5F5);
  static const Color translatorBlueDark = Color(0xFF0D47A1);

  // Background tints
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSoft = Color(0xFFF8FAFD);
  static const Color worldMapTint = Color(0xFFE5EDF9);

  // Neutral dark and grey tones
  static const Color textDark = Color(0xFF1E2024);
  static const Color textMedium = Color(0xFF555B68);
  static const Color textLight = Color(0xFF8C93A0);
  static const Color linkBlue = Color(0xFF2E60C8);

  // Border & divider colors
  static const Color borderLight = Color(0xFFE2E6EE);
  static const Color checkboxBorder = Color(0xFF212529);

  // Card & surface colors
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceHover = Color(0xFFF1F5F9);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrange,
        primary: AppColors.primaryOrange,
        secondary: AppColors.translatorBlue,
        surface: AppColors.background,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        ),
      ),
    );
  }
}
