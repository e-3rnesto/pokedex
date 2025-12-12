//Representa el detalle de un Pokémon
class PokemonDetail {
  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
  });

  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;
}

class PokemonStat {
  const PokemonStat({required this.name, required this.base});

  final String name;
  final int base;
}
