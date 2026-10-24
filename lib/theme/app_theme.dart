import 'package:flutter/material.dart';
import '../design/app_design.dart';

class AppColors {
  AppColors._();

  static const Color navy = AppDesign.navy;
  static const Color navyLight = AppDesign.navyLight;
  static const Color blue = AppDesign.blue;
  static const Color blueLight = AppDesign.blueLight;
  static const Color coral = AppDesign.coral;
  static const Color background = AppDesign.backgroundLight;
  static const Color surface = AppDesign.surfaceLight;
  static const Color textMuted = AppDesign.textSecondaryLight;
  static const Color border = AppDesign.borderLight;
  static const Color success = AppDesign.success;
  static const Color warning = AppDesign.warning;
  static const Color error = AppDesign.error;
  static const Color info = AppDesign.info;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppDesign.blue,
        primary: AppDesign.blue,
        secondary: AppDesign.blueLight,
        surface: AppDesign.surfaceLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppDesign.backgroundLight,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppDesign.textPrimaryLight,
        displayColor: AppDesign.textPrimaryLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesign.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.blue, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDesign.blue,
          side: const BorderSide(color: AppDesign.blue),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppDesign.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppDesign.backgroundLight,
        foregroundColor: AppDesign.navy,
        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: const DividerThemeData(
        color: AppDesign.dividerLight,
        thickness: 1,
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppDesign.blue,
        primary: AppDesign.blueLight,
        secondary: AppDesign.blue,
        surface: AppDesign.surfaceDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppDesign.backgroundDark,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppDesign.textPrimaryDark,
        displayColor: AppDesign.textPrimaryDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppDesign.surfaceVariantDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.blueLight, width: 1.6),
        ),
        labelStyle: const TextStyle(color: AppDesign.textSecondaryDark),
        hintStyle: const TextStyle(color: AppDesign.textSecondaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.blueLight,
          foregroundColor: AppDesign.navy,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppDesign.blueLight,
          side: const BorderSide(color: AppDesign.blueLight),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppDesign.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppDesign.backgroundDark,
        foregroundColor: AppDesign.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: const DividerThemeData(
        color: AppDesign.dividerDark,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppDesign.textPrimaryDark,
      ),
    );
  }
}
