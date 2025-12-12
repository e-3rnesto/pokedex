import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_app/features/pokedex/presentation/widgets/pokedex_captured_card.dart';

import '../providers/pokedex_notifier.dart';

class PokedexPage extends ConsumerWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene la lista de pokemones capturados
    final asyncList = ref.watch(pokedexProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pokédex')),

      body: asyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.catching_pokemon_rounded,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You haven\'t captured any Pokémon yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Find and capture some on the main list.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return PokedexCapturedCard(
                item: item,
                onTapDetail: () => context.go('/pokemon/${item.name}'),
                onEdit: () => context.go('/pokedex/edit/${item.name}'),
                onRelease: () =>
                    ref.read(pokedexProvider.notifier).release(item.name),
              );
            },
          );
        },
      ),
    );
  }
}
