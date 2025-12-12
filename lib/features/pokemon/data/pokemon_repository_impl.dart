import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/config/constants/config.dart';

import '../../../core/dio/dio_provider.dart';
import '../domain/models/pokemon_detail.dart';
import '../domain/models/pokemon_list_item.dart';
import '../domain/repositories/pokemon_repository.dart';
import 'pokemon_api.dart';

final pokemonApiProvider = Provider<PokemonApi>((ref) {
  return PokemonApi(ref.read(dioProvider));
});

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepositoryImpl(ref.read(pokemonApiProvider));
});

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this._api);
  final PokemonApi _api;

  @override
  Future<(List<PokemonListItem> items, bool hasNext)> getList({
    required int limit,
    required int offset,
  }) async {
    final json = await _api.getPokemonList(limit: limit, offset: offset);

    final next = json['next'];
    final results = (json['results'] as List? ?? const [])
        .cast<Map<String, dynamic>>();

    final items = results.map((e) {
      final name = (e['name'] as String?) ?? '';
      final url = (e['url'] as String?) ?? '';
      final id = _parseIdFromUrl(url);

      final imageUrl = '${AppConfig.pokemonSpriteBaseUrl}/$id.png';

      return PokemonListItem(id: id, name: name, imageUrl: imageUrl);
    }).toList();

    return (items, next != null);
  }

  @override
  Future<PokemonDetail> getDetail(String name) async {
    final json = await _api.getPokemonDetail(name);

    final id = (json['id'] as int?) ?? 0;
    final height = (json['height'] as int?) ?? 0;
    final weight = (json['weight'] as int?) ?? 0;

    final sprites = (json['sprites'] as Map?)?.cast<String, dynamic>() ?? {};
    final other = (sprites['other'] as Map?)?.cast<String, dynamic>() ?? {};
    final official =
        (other['official-artwork'] as Map?)?.cast<String, dynamic>() ?? {};
    final imageUrl =
        (official['front_default'] as String?) ??
        (sprites['front_default'] as String?) ??
        '${AppConfig.pokemonSpriteBaseUrl}/$id.png';

    final typesRaw = (json['types'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    typesRaw.sort((a, b) {
      final sa = (a['slot'] as int?) ?? 0;
      final sb = (b['slot'] as int?) ?? 0;
      return sa.compareTo(sb);
    });
    final types = typesRaw
        .map((t) {
          final type = (t['type'] as Map?)?.cast<String, dynamic>() ?? {};
          return (type['name'] as String?) ?? '';
        })
        .where((x) => x.isNotEmpty)
        .toList();

    final statsRaw = (json['stats'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final stats = statsRaw.map((s) {
      final base = (s['base_stat'] as int?) ?? 0;
      final stat = (s['stat'] as Map?)?.cast<String, dynamic>() ?? {};
      final statName = (stat['name'] as String?) ?? '';
      return PokemonStat(name: statName, base: base);
    }).toList();

    return PokemonDetail(
      id: id,
      name: (json['name'] as String?) ?? name,
      imageUrl: imageUrl,
      types: types,
      height: height,
      weight: weight,
      stats: stats,
    );
  }

  int _parseIdFromUrl(String url) {
    final parts = url.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 0;
    final last = parts.last;
    return int.tryParse(last) ?? 0;
  }
}
