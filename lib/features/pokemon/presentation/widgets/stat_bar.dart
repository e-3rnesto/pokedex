import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  const StatBar({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0, 200);
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
        Expanded(
          child: LinearProgressIndicator(value: v / 200.0, minHeight: 8),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text('$value', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
