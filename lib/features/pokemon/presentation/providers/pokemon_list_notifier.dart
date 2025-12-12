import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/pokemon_repository_impl.dart';
import '../../domain/models/pokemon_list_item.dart';

class PokemonListState {
  const PokemonListState({
    required this.items,
    required this.offset,
    required this.hasNext,
    required this.isLoadingMore,
  });

  final List<PokemonListItem> items;
  final int offset;
  final bool hasNext;
  final bool isLoadingMore;

  PokemonListState copyWith({
    List<PokemonListItem>? items,
    int? offset,
    bool? hasNext,
    bool? isLoadingMore,
  }) => PokemonListState(
    items: items ?? this.items,
    offset: offset ?? this.offset,
    hasNext: hasNext ?? this.hasNext,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

final pokemonListProvider =
    AsyncNotifierProvider<PokemonListNotifier, PokemonListState>(
      PokemonListNotifier.new,
    );

class PokemonListNotifier extends AsyncNotifier<PokemonListState> {
  static const _pageSize = 20;

  @override
  Future<PokemonListState> build() async {
    final repo = ref.read(pokemonRepositoryProvider);
    final (items, hasNext) = await repo.getList(limit: _pageSize, offset: 0);
    return PokemonListState(
      items: items,
      offset: items.length,
      hasNext: hasNext,
      isLoadingMore: false,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(pokemonRepositoryProvider);
      final (items, hasNext) = await repo.getList(limit: _pageSize, offset: 0);
      return PokemonListState(
        items: items,
        offset: items.length,
        hasNext: hasNext,
        isLoadingMore: false,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (!current.hasNext || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final repo = ref.read(pokemonRepositoryProvider);
    final result = await AsyncValue.guard(() async {
      final (newItems, hasNext) = await repo.getList(
        limit: _pageSize,
        offset: current.offset,
      );

      return current.copyWith(
        items: [...current.items, ...newItems],
        offset: current.offset + newItems.length,
        hasNext: hasNext,
        isLoadingMore: false,
      );
    });

    state = result.hasError
        ? AsyncData(current.copyWith(isLoadingMore: false))
        : result;
  }
}
