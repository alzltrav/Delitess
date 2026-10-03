import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../recipe_detail_screen.dart';
import '../theme/app_spacing.dart';
import '../widgets/ask_ai_composer.dart';
import '../widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  bool _isLoading = false;
  bool _hasSearched = false;
  Map<String, dynamic>? _searchResult;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);

    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  // Picks a matching Unsplash food photo based on the dish name or query
  String _getMatchingImageUrl(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('burger') || lower.contains('sandwich')) {
      return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500';
    } else if (lower.contains('pizza')) {
      return 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500';
    } else if (lower.contains('pasta') || lower.contains('spaghetti')) {
      return 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=500';
    } else if (lower.contains('noodle') || lower.contains('ramen') || lower.contains('pancit')) {
      return 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=500';
    } else if (lower.contains('chicken') || lower.contains('adobo') || lower.contains('inasal')) {
      return 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500';
    } else if (lower.contains('soup') || lower.contains('sinigang') || lower.contains('stew')) {
      return 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500';
    } else if (lower.contains('beef') || lower.contains('steak') || lower.contains('tapa')) {
      return 'https://images.unsplash.com/photo-1690214691494-b2cfa5fb7d7e?w=500';
    } else if (lower.contains('curry')) {
      return 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500';
    } else if (lower.contains('salad') || lower.contains('vegan') || lower.contains('vegetable')) {
      return 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500';
    } else if (lower.contains('cake') || lower.contains('dessert') || lower.contains('sweet')) {
      return 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500';
  }

  String _formatTitle(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return 'Custom Recipe';
    return trimmed
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
        .join(' ');
  }

  Map<String, dynamic> _buildFallbackRecipe(String query) {
    final cleanTitle = _formatTitle(query);
    return {
      'title': 'Homemade $cleanTitle',
      'time': '25 min',
      'cuisine': 'International',
      'imageUrl': _getMatchingImageUrl(query),
      'ingredients': [
        'Main ingredients for $cleanTitle (freshly prepped)',
        '2 tbsp Olive oil or butter',
        '3 cloves Garlic (minced) & 1 Onion (diced)',
        '1 tsp Salt & 1/2 tsp Ground black pepper',
        'House seasoning and fresh herbs to taste',
      ],
      'instructions': [
        'Prep and portion all ingredients for your $cleanTitle.',
        'Heat oil or butter in a skillet over medium-high heat and aromatic garlic and onions.',
        'Cook the main $cleanTitle components until golden brown and cooked through.',
        'Assemble, garnish with fresh herbs, and serve warm!',
      ],
    };
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      setState(() {
        _searchResult = _buildFallbackRecipe(query);
        _isLoading = false;
      });
      return;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-3.6-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final prompt = '''
      Create a delicious recipe for: "$query".
      Return a single JSON object (not a list) with this exact structure:
      {
        "title": "Specific name of the dish",
        "time": "Estimated cooking time (e.g. 25 min)",
        "cuisine": "Cuisine type (e.g. American, Filipino, Asian, Italian)",
        "ingredients": ["ingredient 1", "ingredient 2", "ingredient 3", "ingredient 4", "ingredient 5"],
        "instructions": ["step 1", "step 2", "step 3", "step 4"]
      }
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      final decoded = jsonDecode(response.text!);
      final Map<String, dynamic> data =
          decoded is List ? Map<String, dynamic>.from(decoded.first) : Map<String, dynamic>.from(decoded);

      final String dishTitle = data['title'] ?? 'Homemade ${_formatTitle(query)}';

      if (mounted) {
        setState(() {
          _searchResult = {
            'title': dishTitle,
            'time': data['time'] ?? '25 min',
            'cuisine': data['cuisine'] ?? 'International',
            'imageUrl': _getMatchingImageUrl('$query $dishTitle'),
            'ingredients': List<String>.from(data['ingredients'] ?? []),
            'instructions': List<String>.from(data['instructions'] ?? []),
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Search AI Error: $e');
      if (mounted) {
        setState(() {
          _searchResult = _buildFallbackRecipe(query);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickPhotoAndGenerate() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final model = GenerativeModel(
        model: 'gemini-3.6-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      const prompt = '''
      Analyze this food image. Return a single JSON object with this exact structure:
      {
        "title": "Name of the dish",
        "time": "Estimated cooking time (e.g. 20 min)",
        "cuisine": "Cuisine type (e.g. Mediterranean, Filipino, Japanese)",
        "ingredients": ["ingredient 1", "ingredient 2"],
        "instructions": ["step 1", "step 2"]
      }
      ''';

      final response = await model.generateContent([
        Content.multi([TextPart(prompt), DataPart('image/jpeg', bytes)])
      ]);

      if (mounted) Navigator.pop(context);
      final decoded = jsonDecode(response.text!);
      final Map<String, dynamic> data =
          decoded is List ? Map<String, dynamic>.from(decoded.first) : Map<String, dynamic>.from(decoded);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              title: data['title'] ?? 'Custom Recipe',
              time: data['time'] ?? 'Unknown time',
              cuisine: data['cuisine'] ?? 'International',
              imageBytes: bytes,
              ingredients: List<String>.from(data['ingredients'] ?? []),
              instructions: List<String>.from(data['instructions'] ?? []),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI is currently busy. Please try again later!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final result = _searchResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            AskAiComposer(
              controller: _searchController,
              onAttachPhoto: _pickPhotoAndGenerate,
              onSubmit: _performSearch,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8EC7E3),
                      ),
                    )
                  : !_hasSearched || result == null
                      ? Center(
                          child: Text(
                            'Type an ingredient or ask AI for a recipe!',
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        )
                      : ListView(
                          children: [
                            Text(
                              'AI Suggestions',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            RecipeCard(
                              title: result['title'],
                              subtitle: '${result['time']} · ${result['cuisine']}',
                              thumbnailColor: const Color(0xFF8EC7E3),
                              imageUrl: result['imageUrl'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailScreen(
                                      title: result['title'],
                                      time: result['time'],
                                      cuisine: result['cuisine'],
                                      imageUrl: result['imageUrl'],
                                      ingredients: List<String>.from(result['ingredients']),
                                      instructions: List<String>.from(result['instructions']),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}