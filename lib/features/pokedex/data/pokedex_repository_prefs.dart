import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/local/shared_prefs_provider.dart';
import '../domain/models/captured_pokemon.dart';
import '../domain/repositories/pokedex_repository.dart';

final pokedexRepositoryProvider = Provider<PokedexRepository>((ref) {
  return PokedexRepositoryPrefs(ref.read(sharedPrefsProvider));
});

class PokedexRepositoryPrefs implements PokedexRepository {
  PokedexRepositoryPrefs(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'captured_pokemon_v1';

  @override
  Future<List<CapturedPokemon>> loadAll() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    return CapturedPokemon.decodeList(raw);
  }

  @override
  Future<void> saveAll(List<CapturedPokemon> items) async {
    await _prefs.setString(_key, CapturedPokemon.encodeList(items));
  }
}
