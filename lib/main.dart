import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokedex_app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local/shared_prefs_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa SharedPreferences antes de ejecutar la app
  final prefs = await SharedPreferences.getInstance();
  // Mantiene la pantalla de splash hasta que la app esté lista
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //para leer archivo de variables de entorno
  // await dotenv.load(fileName: '.env');

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const App(),
    ),
  );
}
