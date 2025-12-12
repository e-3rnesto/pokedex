import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'theme_repository.dart';

final themeControllerProvider = NotifierProvider<ThemeController, AppThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<AppThemeMode> {
  // Carga el tema guardado al iniciar la app
  @override
  AppThemeMode build() {
    final repo = ref.read(themeRepositoryProvider);
    // Carga sincronamente desde SharedPreferences
    return repo.loadTheme();
  }

  // Cambia el tema y lo guarda en SharedPreferences
  Future<void> setTheme(AppThemeMode mode) async {
    final repo = ref.read(themeRepositoryProvider);
    state = mode;
    await repo.saveTheme(mode);
  }
}
