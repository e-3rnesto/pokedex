import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/core/utils/string_utils.dart';

import '../../domain/models/pokemon_list_item.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.item, required this.onTap});

  final PokemonListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Color de fondo de la tarjeta
    final Color cardBackgroundColor = const Color.fromARGB(255, 214, 16, 16);
    // Formatea el ID del Pokémon con ceros a la izquierda
    final String pokemonId = item.id.toString().padLeft(3, '0');

    // Usamos el color de la tarjeta para definir el color del texto de contraste
    final Color textColor = Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardBackgroundColor, Colors.redAccent],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  // Marca de agua
                  Positioned(
                    bottom: -5,
                    right: 30,
                    child: Icon(
                      Icons.catching_pokemon_rounded,
                      size: 100,
                      color: textColor.withOpacity(0.1),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Imagen del Pokémon
                        Hero(
                          tag: 'pokemon-${item.id}',
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl,
                              placeholder: (c, _) => Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xFF1976D2),
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (c, _, __) => Icon(
                                Icons.catching_pokemon_rounded,
                                color: const Color(0xFF1976D2).withOpacity(0.9),
                                size: 80,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Nombre - ID
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '#$pokemonId',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.name.capitalized,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Ícono de Navegación
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: textColor.withOpacity(0.8),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
