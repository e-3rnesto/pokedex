import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../features/pokedex/presentation/providers/pokedex_notifier.dart';
import '../providers/pokemon_detail_provider.dart';
import '../widgets/pokemon_type_chip.dart';
import '../widgets/stat_bar.dart';

class PokemonDetailPage extends ConsumerWidget {
  const PokemonDetailPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(pokemonDetailProvider(name));
    final isCaptured = ref.watch(isCapturedProvider(name));

    return Scaffold(
      appBar: AppBar(title: Text(name.capitalized)),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error al cargar detalle: $e')),
        data: (d) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Hero(
                    tag: 'pokemon-${d.id}',
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1976D2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: d.imageUrl,
                        placeholder: (c, _) => Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xFF1976D2),
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (c, _, __) => Icon(
                          Icons.catching_pokemon_rounded,
                          color: const Color(0xFF1976D2).withOpacity(0.5),
                          size: 80,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  d.name.capitalized,

                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,

                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: d.types
                      .map((t) => PokemonTypeChip(type: t))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard(
                      context,
                      Icons.height,
                      'Height',
                      '${d.height / 10} m',
                      const Color.fromARGB(255, 66, 160, 248),
                    ),
                    _buildInfoCard(
                      context,
                      Icons.scale,
                      'Weight',
                      '${d.weight / 10} kg',
                      const Color.fromARGB(255, 64, 241, 58),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Stats', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 66, 66),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: d.stats
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: StatBar(label: s.name, value: s.base),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 250, 66, 66),
                  ),
                  onPressed: () async {
                    if (isCaptured) {
                      await ref.read(pokedexProvider.notifier).release(name);
                      return;
                    }
                    final result =
                        await showModalBottomSheet<_CaptureFormResult>(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => _CaptureSheet(name: name),
                        );
                    if (result == null) return;

                    await ref
                        .read(pokedexProvider.notifier)
                        .capture(
                          name: name,
                          nickname: result.nickname,
                          notes: result.notes,
                        );
                  },
                  icon: Icon(
                    isCaptured ? Icons.delete_outline : Icons.catching_pokemon,
                    color: Colors.white,
                  ),
                  label: Text(
                    isCaptured ? 'Release' : 'Capture',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildInfoCard(
  BuildContext context,
  IconData icon,
  String title,
  String value,
  Color color,
) {
  return Container(
    width: 140,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 250, 66, 66),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(221, 252, 252, 252),
          ),
        ),
      ],
    ),
  );
}

class _CaptureFormResult {
  const _CaptureFormResult({required this.nickname, required this.notes});
  final String nickname;
  final String notes;
}

class _CaptureSheet extends StatefulWidget {
  const _CaptureSheet({required this.name});
  final String name;

  @override
  State<_CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends State<_CaptureSheet> {
  final _nicknameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Capture ${widget.name.capitalized}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nicknameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nickname (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  _CaptureFormResult(
                    nickname: _nicknameCtrl.text.trim(),
                    notes: _notesCtrl.text.trim(),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
