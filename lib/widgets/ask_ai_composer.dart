import 'package:flutter/material.dart';

class AskAiComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAttachPhoto;
  final ValueChanged<String> onSubmit;

  const AskAiComposer({
    super.key,
    required this.controller,
    required this.onAttachPhoto,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      style: TextStyle(color: onSurface),
      decoration: InputDecoration(
        hintText: 'Search or Ask AI',
        hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.6)),
        fillColor: Theme.of(context).cardColor,
        prefixIcon: Icon(Icons.search, color: onSurface),
        suffixIcon: IconButton(
          icon: Icon(Icons.camera_alt, color: onSurface),
          onPressed: onAttachPhoto,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}