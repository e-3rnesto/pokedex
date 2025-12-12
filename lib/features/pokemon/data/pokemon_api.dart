import 'package:dio/dio.dart';

// API para interactuar con la PokeAPI
class PokemonApi {
  PokemonApi(this._dio);
  final Dio _dio;
  // Obtiene la lista de pokemones con paginación
  Future<Map<String, dynamic>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return res.data ?? <String, dynamic>{};
  }

  // Obtiene el detalle de un pokemon por su nombre
  Future<Map<String, dynamic>> getPokemonDetail(String name) async {
    final res = await _dio.get<Map<String, dynamic>>('/pokemon/$name');
    return res.data ?? <String, dynamic>{};
  }
}
