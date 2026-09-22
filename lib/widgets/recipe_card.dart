
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color thumbnailColor;
  final String? imageUrl; 
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.thumbnailColor,
    this.imageUrl, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: thumbnailColor,
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: thumbnailColor,
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),
              
              // The Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall, 
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}