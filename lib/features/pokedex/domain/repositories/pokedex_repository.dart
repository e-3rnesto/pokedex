import '../models/captured_pokemon.dart';

abstract class PokedexRepository {
  Future<List<CapturedPokemon>> loadAll();
  Future<void> saveAll(List<CapturedPokemon> items);
}
