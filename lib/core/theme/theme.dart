import 'package:flutter/material.dart';
import 'color.dart' as c;
import 'typography.dart';

final appTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: c.primary,
    primaryContainer: c.primaryContainer,
    onPrimaryContainer: c.onPrimaryContainer,
    secondaryContainer: c.secondaryContainer,
    onSecondaryContainer: c.onSecondaryContainer,
    tertiaryContainer: c.tertiaryContainer,
    onTertiaryContainer: c.onTertiaryContainer,
    surface: c.surface,
    surfaceContainerHighest: c.surfaceVariant,
    onSurface: c.onSurface,
    onSurfaceVariant: c.onSurfaceVariant,
    outline: c.outline,
    outlineVariant: c.outlineVariant,
    surfaceContainerHigh: c.surfaceContainerHigh,
  ),
  typography: appTypography,
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    insetPadding: EdgeInsets.only(top: 60, left: 16, right: 16),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
    floatingLabelStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
    hintStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
  ),
);
