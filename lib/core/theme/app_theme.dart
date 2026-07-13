import 'package:flutter/material.dart';

/// Zawq Material 3 palette (tonal green / amber).
abstract final class Z {
  static const surface = Color(0xFFFAF9F4);
  static const surfaceContainer = Color(0xFFF1EFE6);
  static const surfaceHigh = Color(0xFFEBE8DD);
  static const primary = Color(0xFF2E6B4F);
  static const onPrimary = Colors.white;
  static const primaryContainer = Color(0xFFC9EAD3);
  static const onPrimaryContainer = Color(0xFF0A2818);
  static const secondaryContainer = Color(0xFFE4EAD5);
  static const onSecondaryContainer = Color(0xFF1A2E1C);
  static const tertiary = Color(0xFF8A5100);
  static const tertiaryContainer = Color(0xFFFFDCB8);
  static const outline = Color(0xFF74796F);
  static const outlineVariant = Color(0xFFC4C8BB);
  static const onSurface = Color(0xFF1A1C18);
  static const onSurfaceVariant = Color(0xFF44483F);
  static const error = Color(0xFFBA1A1A);

  /// Score → semantic color (green / amber / red).
  static Color rating(double r) => r >= 8.5
      ? const Color(0xFF1B7A3D)
      : r >= 7.0
          ? const Color(0xFFB26B00)
          : const Color(0xFFC4441C);
}

abstract final class AppTheme {
  static ThemeData light(bool arabic) {
    const scheme = ColorScheme.light(
      primary: Z.primary,
      onPrimary: Z.onPrimary,
      primaryContainer: Z.primaryContainer,
      onPrimaryContainer: Z.onPrimaryContainer,
      secondaryContainer: Z.secondaryContainer,
      onSecondaryContainer: Z.onSecondaryContainer,
      tertiary: Z.tertiary,
      tertiaryContainer: Z.tertiaryContainer,
      surface: Z.surface,
      onSurface: Z.onSurface,
      onSurfaceVariant: Z.onSurfaceVariant,
      outline: Z.outline,
      outlineVariant: Z.outlineVariant,
      error: Z.error,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final text = arabic
        ? base.textTheme.apply(fontFamily: 'Cairo')
        : base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: Z.surface,
      textTheme: text,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Z.surfaceContainer,
        indicatorColor: Z.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: StadiumBorder(),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Z.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}
