import 'package:go_router/go_router.dart';

import 'package:pokedex_app/features/pokemon/presentation/pages/pokemon_detail_page.dart';
import 'package:pokedex_app/features/pokemon/presentation/pages/pokemon_list_page.dart';
import 'package:pokedex_app/features/pokedex/presentation/pages/pokedex_page.dart';
import 'package:pokedex_app/features/pokedex/presentation/pages/edit_capture_page.dart';
import 'package:pokedex_app/features/settings/presentation/settings_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      //ruta default a la lista de pokemones
      GoRoute(
        path: '/',
        builder: (context, state) => const PokemonListPage(),
        routes: [
          GoRoute(
            path: 'pokemon/:name',
            builder: (context, state) {
              final name = state.pathParameters['name']!;
              return PokemonDetailPage(name: name);
            },
          ),
          // detalle del pokemon
          GoRoute(
            path: 'pokedex',
            builder: (context, state) => const PokedexPage(),
            routes: [
              GoRoute(
                path: 'edit/:name',
                builder: (context, state) {
                  final name = state.pathParameters['name']!;
                  return EditCapturePage(name: name);
                },
              ),
            ],
          ),
          // pagina de configuraciones
          GoRoute(path: 'settings', builder: (_, __) => const SettingsPage()),
        ],
      ),
    ],
  );
}
