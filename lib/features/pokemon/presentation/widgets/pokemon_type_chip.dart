import 'package:flutter/material.dart';
import '../../../../core/utils/string_utils.dart';

class PokemonTypeChip extends StatelessWidget {
  const PokemonTypeChip({super.key, required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(type.capitalized),
      visualDensity: VisualDensity.compact,
    );
  }
}
