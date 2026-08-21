import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFFFBF7EE);
  static const plum = Color(0xFF3B2145);
  static const gold = Color(0xFFA8935F);
  static const goldMuted = Color(0xFF9C8A6E);
  static const orange = Color(0xFFE4572E);
  static const lime = Color(0xFFA8C93F);
  static const cardWhite = Color(0xFFFFFFFF);
  static const dashDivider = Color(0xFFE7DFCB);
  static const shadow = Color(0x33000000);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.plum,
    scaffoldBackgroundColor: AppColors.background,
  );

  // Generates Space Grotesk TextTheme with default plum body/display colors
  final spaceGroteskTextTheme = GoogleFonts.spaceGroteskTextTheme(
    base.textTheme.apply(
      bodyColor: AppColors.plum,
      displayColor: AppColors.plum,
    ),
  );

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.plum,
      secondary: AppColors.lime,
      surface: AppColors.cardWhite,
      error: AppColors.orange,
    ),
    textTheme: spaceGroteskTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.plum,
      centerTitle: false,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: AppColors.gold,
        letterSpacing: 0.5,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lime,
      foregroundColor: AppColors.plum,
      elevation: 6,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lime,
        foregroundColor: AppColors.plum,
        textStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardWhite,
      labelStyle: GoogleFonts.spaceGrotesk(
        color: AppColors.goldMuted,
        fontSize: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.dashDivider),
  );
}
