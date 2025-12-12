import 'dart:convert';

class CapturedPokemon {
  const CapturedPokemon({
    required this.name,
    required this.nickname,
    required this.notes,
    required this.capturedAt,
  });

  final String name;
  final String nickname;
  final String notes;
  final DateTime capturedAt;

  CapturedPokemon copyWith({String? nickname, String? notes}) =>
      CapturedPokemon(
        name: name,
        nickname: nickname ?? this.nickname,
        notes: notes ?? this.notes,
        capturedAt: capturedAt,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'nickname': nickname,
    'notes': notes,
    'capturedAt': capturedAt.toIso8601String(),
  };

  static CapturedPokemon fromJson(Map<String, dynamic> json) => CapturedPokemon(
    name: json['name'] as String,
    nickname: (json['nickname'] as String?) ?? '',
    notes: (json['notes'] as String?) ?? '',
    capturedAt: DateTime.parse(json['capturedAt'] as String),
  );

  static List<CapturedPokemon> decodeList(String raw) {
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(CapturedPokemon.fromJson).toList();
  }

  static String encodeList(List<CapturedPokemon> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }
}
