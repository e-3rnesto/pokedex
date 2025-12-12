import 'package:dio/dio.dart';

class PokemonApi {
  PokemonApi(this._dio);
  final Dio _dio;

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

  Future<Map<String, dynamic>> getPokemonDetail(String name) async {
    final res = await _dio.get<Map<String, dynamic>>('/pokemon/$name');
    return res.data ?? <String, dynamic>{};
  }
}
