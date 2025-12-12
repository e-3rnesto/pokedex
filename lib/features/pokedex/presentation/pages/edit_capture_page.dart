import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/pokedex_notifier.dart';

// Página para editar el apodo y notas de un Pokémon capturado
class EditCapturePage extends ConsumerStatefulWidget {
  const EditCapturePage({super.key, required this.name});
  final String name;

  @override
  ConsumerState<EditCapturePage> createState() => _EditCapturePageState();
}

class _EditCapturePageState extends ConsumerState<EditCapturePage> {
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
    final captured = ref.watch(capturedByNameProvider(widget.name));
    // Si el Pokémon no está capturado, muestra un mensaje
    if (captured == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Capture')),
        body: const Center(child: Text('This Pokémon is not captured.')),
      );
    }
    // Rellena los campos con los datos actuales si están vacíos
    _nicknameCtrl.text = _nicknameCtrl.text.isEmpty
        ? captured.nickname
        : _nicknameCtrl.text;
    _notesCtrl.text = _notesCtrl.text.isEmpty
        ? captured.notes
        : _notesCtrl.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Capture')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nicknameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  // Actualiza el Pokémon capturado con los nuevos datos
                  await ref
                      .read(pokedexProvider.notifier)
                      .update(
                        name: widget.name,
                        nickname: _nicknameCtrl.text.trim(),
                        notes: _notesCtrl.text.trim(),
                      );
                  if (context.mounted) context.pop();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
