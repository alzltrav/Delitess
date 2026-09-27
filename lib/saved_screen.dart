
import 'package:flutter/material.dart';
import 'theme/app_spacing.dart';
import 'widgets/recipe_card.dart';
import 'recipe_detail_screen.dart'; 
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

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
        child: ListView(
          children: [
            RecipeCard(
              title: 'Chicken Adobo',
              subtitle: '45 min · Filipino',
              thumbnailColor: const Color(0xFF8EC7E3),
              imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipeDetailScreen(
                      title: 'Chicken Adobo',
                      imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
                      time: '45 min',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            RecipeCard(
              title: 'Spicy Garlic Noodles',
              subtitle: '15 min · Asian',
              thumbnailColor: const Color(0xFFC9E4EE),
              imageUrl: 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=500',
              onTap: () {}, 
            ),
          ],
        ),
      ),
    );
  }
}