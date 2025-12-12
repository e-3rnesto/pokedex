import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/pokemon_repository_impl.dart';
import '../../domain/models/pokemon_detail.dart';

final pokemonDetailProvider = FutureProvider.family<PokemonDetail, String>((
  ref,
  name,
) async {
  final repo = ref.read(pokemonRepositoryProvider);
  return repo.getDetail(name);
});
