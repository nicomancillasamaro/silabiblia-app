import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF3A86FF);
  static const Color secondaryGold = Color(0xFFFFBE0B);
  static const Color accentPink = Color(0xFFFF006E);
  static const Color accentPurple = Color(0xFF8338EC);
  static const Color emeraldGreen = Color(0xFF06D6A0);
  static const Color warmOrange = Color(0xFFFB5607);
  static const Color cloudWhite = Color(0xFFF8F9FA);
  static const Color darkSlate = Color(0xFF1E293B);

  // Gradient definitions
  static const LinearGradient skyGradient = LinearGradient(
    colors: [Color(0xFF70A1FF), Color(0xFF1E90FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient arkGradient = LinearGradient(
    colors: [Color(0xFF8D5B4C), Color(0xFF5C3A21)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFFFB703)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFEEF5FC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryGold,
        tertiary: emeraldGreen,
        background: const Color(0xFFEEF5FC),
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: darkSlate,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: darkSlate,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkSlate,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 6,
        shadowColor: primaryBlue.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
