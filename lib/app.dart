import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/config/router/router.dart';
import 'package:pokedex_app/config/theme/theme.dart';
import 'package:pokedex_app/config/theme/theme_controller.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa el modo de tema actual
    final appThemeMode = ref.watch(themeControllerProvider);
    // Configura el router
    final router = buildRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appThemeMode.toThemeMode,
      routerConfig: router,
    );
  }
}
