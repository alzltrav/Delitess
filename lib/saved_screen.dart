import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'theme/app_spacing.dart';
import 'widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'saved_recipe_manager.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, dynamic>> _savedRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    final recipes = await SavedRecipeManager.getSavedRecipes();
    if (mounted) {
      setState(() {
        _savedRecipes = recipes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      appBar: AppBar(
        title: const Text(
          'Saved Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF3A4750),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _savedRecipes.isEmpty
                ? const Center(
                    child: Text(
                      'No saved recipes yet.\nTap the bookmark icon on any recipe to save it!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _savedRecipes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final recipe = _savedRecipes[index];
                      final String title = recipe['title'] ?? 'Untitled Recipe';
                      final String time = recipe['time'] ?? '30 min';
                      final String cuisine = recipe['cuisine'] ?? 'Filipino';
                      final String? imageUrl = recipe['imageUrl'];
                      final String? base64Img = recipe['imageBase64'];

                      Uint8List? imageBytes;
                      if (base64Img != null) {
                        imageBytes = base64Decode(base64Img);
                      }

                      return RecipeCard(
                        title: title,
                        subtitle: '$time · $cuisine',
                        thumbnailColor: index.isEven
                            ? const Color(0xFF8EC7E3)
                            : const Color(0xFFC9E4EE),
                        imageUrl: imageUrl ?? '',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                title: title,
                                time: time,
                                cuisine: cuisine,
                                imageUrl: imageUrl,
                                imageBytes: imageBytes,
                                ingredients: recipe['ingredients'] != null
                                    ? List<String>.from(recipe['ingredients'])
                                    : null,
                                instructions: recipe['instructions'] != null
                                    ? List<String>.from(recipe['instructions'])
                                    : null,
                              ),
                            ),
                          );
                          
                          _loadSavedRecipes();
                        },
                      );
                    },
                  ),
      ),
    );
  }
}