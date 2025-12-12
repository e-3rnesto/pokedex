import '../models/pokemon_detail.dart';
import '../models/pokemon_list_item.dart';

abstract class PokemonRepository {
  Future<(List<PokemonListItem> items, bool hasNext)> getList({
    required int limit,
    required int offset,
  });

  Future<PokemonDetail> getDetail(String name);
}
