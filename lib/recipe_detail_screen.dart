import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'saved_recipe_manager.dart';
import 'theme/app_spacing.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String title;
  final String time;
  final String? cuisine;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final List<String>? ingredients;
  final List<String>? instructions;

  const RecipeDetailScreen({
    super.key,
    required this.title,
    required this.time,
    this.cuisine,
    this.imageUrl,
    this.imageBytes,
    this.ingredients,
    this.instructions,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final saved = await SavedRecipeManager.isRecipeSaved(widget.title);
    if (mounted) {
      setState(() {
        isSaved = saved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    final displayIngredients = widget.ingredients ??
        [
          '1 kg Chicken (cut into pieces)',
          '1/2 cup Soy Sauce',
          '1/4 cup White Vinegar',
          '1 head Garlic (minced)',
          '1 tsp Whole Peppercorns',
          '3 Dried Bay Leaves',
        ];

    final displayInstructions = widget.instructions ??
        [
          'Combine chicken, soy sauce, and garlic in a large bowl. Marinate for at least 1 hour.',
          'Heat a cooking pot. Put-in the marinated chicken. Cook for 5 minutes.',
          'Pour in the remaining marinade, water, peppercorns, and bay leaves. Boil and simmer for 30 minutes.',
          'Add vinegar. Stir and cook for 10 minutes. Serve hot with rice!',
        ];

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? const Color(0xFF8EC7E3) : textColor,
                ),
                onPressed: () async {
                  final nowSaved = await SavedRecipeManager.toggleRecipe(
                    title: widget.title,
                    time: widget.time,
                    cuisine: widget.cuisine ?? 'Filipino',
                    imageUrl: widget.imageUrl,
                    imageBytes: widget.imageBytes,
                    ingredients: displayIngredients,
                    instructions: displayInstructions,
                  );
                  if (mounted) {
                    setState(() {
                      isSaved = nowSaved;
                    });
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.imageBytes != null
                  ? Image.memory(
                      widget.imageBytes!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.imageUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFC9E4EE),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.time,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.restaurant, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.cuisine ?? 'Filipino',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...displayIngredients
                      .map((item) => _buildIngredientItem(item, textColor)),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...displayInstructions.asMap().entries.map(
                        (entry) => _buildInstructionStep(
                          (entry.key + 1).toString(),
                          entry.value,
                          textColor,
                        ),
                      ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(String item, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 8, color: Color(0xFF8EC7E3)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              item,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String step, String instruction, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFFC9E4EE),
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              instruction,
              style: TextStyle(fontSize: 16, height: 1.5, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}