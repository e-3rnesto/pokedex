import '../models/captured_pokemon.dart';

// Repositorio abstracto para la pokedex
abstract class PokedexRepository {
  // Carga todos los pokemones capturados
  Future<List<CapturedPokemon>> loadAll();
  // Guarda todos los pokemones capturados
  Future<void> saveAll(List<CapturedPokemon> items);
}
