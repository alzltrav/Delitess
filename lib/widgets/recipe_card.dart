import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color thumbnailColor;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.thumbnailColor,
    this.imageUrl,
    this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      color: Theme.of(context).cardColor,
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
                child: _buildThumbnail(),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
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

  Widget _buildThumbnail() {
    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
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
      );
    }
    return Container(
      width: 60,
      height: 60,
      color: thumbnailColor,
    );
  }
}