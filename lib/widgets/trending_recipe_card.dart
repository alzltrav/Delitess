import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class TrendingRecipeCard extends StatelessWidget{
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const TrendingRecipeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 150,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: 150,
                    color: const Color(0xFFC9E4EE),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Title
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
  
            ),
            // Subtitle (Prep time)
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}