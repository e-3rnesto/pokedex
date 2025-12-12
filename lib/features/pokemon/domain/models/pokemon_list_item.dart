// Items de la lista de Pokémon
class PokemonListItem {
  const PokemonListItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String imageUrl;
}
