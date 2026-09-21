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
    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      decoration: InputDecoration(
        hintText: 'Search or Ask AI',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.camera_alt),
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