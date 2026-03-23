import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Blue & White palette
  static const Color primary      = Color(0xFF1A73E8);
  static const Color primaryDark  = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF4FC3F7);
  static const Color primarySoft  = Color(0xFFE8F1FD);
  static const Color bgPage       = Color(0xFFF4F7FC);
  static const Color bgSection    = Color(0xFFEBF2FF);
  static const Color cardWhite    = Color(0xFFFFFFFF);
  static const Color textDark     = Color(0xFF0D1B3E);
  static const Color textBody     = Color(0xFF2C3E6B);
  static const Color textMuted    = Color(0xFF7A90B8);
  static const Color textHint     = Color(0xFFB0C0D8);
  static const Color borderBlue   = Color(0xFFC2D8F5);
  static const Color success      = Color(0xFF00C07B);
  static const Color warning      = Color(0xFFF59E0B);
  static const Color error        = Color(0xFFEF4444);
  static const Color cancelled    = Color(0xFF94A3B8);

  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft, end: Alignment.bottomRight);

  static LinearGradient get heroGradient => const LinearGradient(
    colors: [primaryDark, primary, Color(0xFF2196F3)],
    begin: Alignment.topLeft, end: Alignment.bottomRight);

  static LinearGradient get bgGradient => const LinearGradient(
    colors: [Color(0xFFEBF3FF), Color(0xFFF4F7FC), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary, secondary: primaryLight, surface: cardWhite,
        error: error, onPrimary: Colors.white, onSurface: textDark),
      scaffoldBackgroundColor: bgPage,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge:  GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: textDark),
        displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: textDark),
        titleLarge:    GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
        titleMedium:   GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: textDark),
        bodyLarge:     GoogleFonts.poppins(fontSize: 16, color: textBody),
        bodyMedium:    GoogleFonts.poppins(fontSize: 14, color: textMuted),
        bodySmall:     GoogleFonts.poppins(fontSize: 12, color: textMuted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: cardWhite,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: borderBlue)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: borderBlue)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: error)),
        labelStyle: GoogleFonts.poppins(color: textMuted, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: textHint, fontSize: 14),
        prefixIconColor: primary, suffixIconColor: textMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: primary, foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600), elevation: 0)),
      cardTheme: CardThemeData(color: cardWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0),
      appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0,
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
        iconTheme: const IconThemeData(color: textDark)),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardWhite, indicatorColor: primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith((s) => GoogleFonts.poppins(
          fontSize: 11, fontWeight: FontWeight.w500,
          color: s.contains(WidgetState.selected) ? primary : textMuted)),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? primary : textMuted, size: 22))),
      dialogTheme: DialogThemeData(backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: textDark),
        contentTextStyle: GoogleFonts.poppins(fontSize: 14, color: textMuted)),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28)))),
      snackBarTheme: SnackBarThemeData(backgroundColor: primaryDark,
        contentTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }
}
