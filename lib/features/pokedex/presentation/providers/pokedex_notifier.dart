import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/pokedex_repository_prefs.dart';
import '../../domain/models/captured_pokemon.dart';

final pokedexProvider =
    NotifierProvider<PokedexNotifier, AsyncValue<List<CapturedPokemon>>>(
      PokedexNotifier.new,
    );

final isCapturedProvider = Provider.family<bool, String>((ref, name) {
  final list = ref.watch(pokedexProvider).valueOrNull ?? [];
  return list.any((e) => e.name == name);
});

final capturedByNameProvider = Provider.family<CapturedPokemon?, String>((
  ref,
  name,
) {
  final list = ref.watch(pokedexProvider).valueOrNull ?? [];
  for (final e in list) {
    if (e.name == name) return e;
  }
  return null;
});

class PokedexNotifier extends Notifier<AsyncValue<List<CapturedPokemon>>> {
  @override
  AsyncValue<List<CapturedPokemon>> build() {
    _init();
    return const AsyncLoading();
  }

  Future<void> _init() async {
    final repo = ref.read(pokedexRepositoryProvider);
    state = await AsyncValue.guard(() async => repo.loadAll());
  }

  Future<void> capture({
    required String name,
    required String nickname,
    required String notes,
  }) async {
    final repo = ref.read(pokedexRepositoryProvider);
    final current = state.valueOrNull ?? [];

    if (current.any((e) => e.name == name)) return;

    final updated = [
      ...current,
      CapturedPokemon(
        name: name,
        nickname: nickname,
        notes: notes,
        capturedAt: DateTime.now(),
      ),
    ];

    state = AsyncData(updated);
    await repo.saveAll(updated);
  }

  Future<void> update({
    required String name,
    required String nickname,
    required String notes,
  }) async {
    final repo = ref.read(pokedexRepositoryProvider);
    final current = state.valueOrNull ?? [];

    final updated = current
        .map(
          (e) =>
              e.name == name ? e.copyWith(nickname: nickname, notes: notes) : e,
        )
        .toList();

    state = AsyncData(updated);
    await repo.saveAll(updated);
  }

  Future<void> release(String name) async {
    final repo = ref.read(pokedexRepositoryProvider);
    final current = state.valueOrNull ?? [];
    final updated = current.where((e) => e.name != name).toList();

    state = AsyncData(updated);
    await repo.saveAll(updated);
  }
}
