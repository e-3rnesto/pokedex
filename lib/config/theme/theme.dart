import 'package:flutter/material.dart';

const Color pokeRed = Color(0xFFDD2525);
const Color pokeDarkRed = Color(0xFFC63030);

const _textTheme = TextTheme(bodyMedium: TextStyle(height: 1.25));

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: pokeRed,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: _textTheme,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: pokeDarkRed,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: _textTheme,
);

enum AppThemeMode {
  system,
  light,
  dark;

  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  String get storageValue {
    switch (this) {
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }

  static AppThemeMode fromStorage(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }
}
