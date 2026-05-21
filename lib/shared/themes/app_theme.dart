import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7F56D9);
  static const Color primaryContainer = Color(0xFFEDE2FF);
  static const Color secondaryColor = Color(0xFF9B72F6);
  static const Color backgroundColor = Color(0xFFF6F0FF);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color onSurfaceColor = Color(0xFF1F1B39);
  static const Color errorColor = Color(0xFFB00020);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: Color(0xFF2E1B5F),
      secondary: secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF0E7FF),
      onSecondaryContainer: Color(0xFF2F1B70),
      background: backgroundColor,
      onBackground: onSurfaceColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      error: errorColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: onSurfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: onSurfaceColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2E9FF),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: TextStyle(
        color: Colors.indigo.shade900,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(color: Colors.indigo.shade300),
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    textTheme: Typography.blackMountainView.copyWith(
      bodyLarge: const TextStyle(
        fontSize: 16,
        height: 1.5,
        color: onSurfaceColor,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.45,
        color: onSurfaceColor,
      ),
      titleLarge: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: onSurfaceColor,
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurfaceColor,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: onSurfaceColor,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
