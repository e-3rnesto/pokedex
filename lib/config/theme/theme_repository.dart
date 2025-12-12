import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/core/local/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

const _themeKey = 'app_theme_mode';

final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepository(ref.read(sharedPrefsProvider));
});

class ThemeRepository {
  ThemeRepository(this._prefs);

  final SharedPreferences _prefs;

  AppThemeMode loadTheme() {
    final raw = _prefs.getString(_themeKey);
    return AppThemeMode.fromStorage(raw ?? AppThemeMode.system.storageValue);
  }

  Future<void> saveTheme(AppThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.storageValue);
  }
}
