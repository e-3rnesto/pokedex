import '../models/pokemon_detail.dart';
import '../models/pokemon_list_item.dart';

// Repositorio abstracto para los pokemones
abstract class PokemonRepository {
  // Obtiene la lista de pokemones con paginación
  Future<(List<PokemonListItem> items, bool hasNext)> getList({
    required int limit,
    required int offset,
  });
  // Obtiene el detalle de un pokemon por su nombre
  Future<PokemonDetail> getDetail(String name);
}
