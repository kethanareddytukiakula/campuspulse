import 'package:flutter/material.dart';

/// Shared button widget placeholder.
class SharedButton extends StatelessWidget {
  const SharedButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
