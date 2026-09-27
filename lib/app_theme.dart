import 'package:flutter/material.dart';

/// Shared color tokens and control styles for the viewport demo.
abstract final class AppPalette {
  static const blue = Color(0xFF07539A);
  static const orange = Color(0xFFF07126);
  static const orangeLight = Color(0xFFFEF5EE);
  static const textPrimary = Color(0xFF03213E);
  static const textSecondary = Color(0xFF66788A);
  static const textTertiary = Color(0xFFB3BCC5);
  static const white = Color(0xFFFFFFFF);
  static const neutral20 = Color(0xFFF8F9FA);
  static const neutral30 = Color(0xFFEBEDF0);
  static const border = Color(0xFFCED3D8);
  static const blueLight = Color(0xFFE6EEF5);
  static const blueMuted = Color(0xFF9CBAD7);
  static const error = Color(0xFFD70C24);
}

ThemeData appTheme() {
  const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppPalette.border, width: 2),
  );
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'Lato',
    primaryColor: AppPalette.orange,
    scaffoldBackgroundColor: AppPalette.white,
    canvasColor: AppPalette.neutral20,
    disabledColor: AppPalette.border,
    hintColor: AppPalette.textTertiary,
    dividerColor: AppPalette.neutral30,
    colorScheme: const ColorScheme.light(
      primary: AppPalette.blue,
      secondary: Color(0xFFD1E6FB),
      surface: AppPalette.white,
      onSurface: AppPalette.textPrimary,
      error: AppPalette.error,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppPalette.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppPalette.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppPalette.textPrimary,
      ),
      titleMedium: TextStyle(fontSize: 16, color: AppPalette.textPrimary),
      bodyLarge: TextStyle(fontSize: 14, color: AppPalette.textPrimary),
      bodyMedium: TextStyle(fontSize: 12, color: AppPalette.textPrimary),
      bodySmall: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.white,
      foregroundColor: AppPalette.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Lato',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppPalette.textPrimary,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppPalette.orange,
        foregroundColor: AppPalette.white,
        disabledBackgroundColor: AppPalette.border,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        shape: shape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppPalette.orange,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        side: const BorderSide(color: AppPalette.orange),
        shape: shape,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppPalette.orange
            : AppPalette.white,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? const Color(0xFFF8B893)
            : AppPalette.border,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppPalette.orange,
      selectionColor: AppPalette.blueLight,
      selectionHandleColor: AppPalette.orange,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(
        color: AppPalette.textSecondary,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(color: AppPalette.textTertiary, fontSize: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppPalette.orange, width: 2),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppPalette.error, width: 2),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPalette.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
  );
}
