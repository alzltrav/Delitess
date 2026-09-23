
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    
    
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    
    
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });
    
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3A4750), // Navy back button
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            // The Search Bar
            AskAiComposer(
              controller: _searchController,
              onAttachPhoto: () {
                print('Camera tapped on Search Screen!');
              },
              onSubmit: _performSearch, 
            ),
            const SizedBox(height: AppSpacing.md),
            
            // The Results Area
            Expanded(
              child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8EC7E3), 
                    ),
                  )
                : !_hasSearched 
                  ? const Center(
                      child: Text(
                        'Type an ingredient or ask AI for a recipe!',
                        style: TextStyle(color: Color(0xFF3A4750), fontSize: 16),
                      ),
                    )
                  : ListView(
                      children: [
                        const Text(
                          'AI Suggestions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A4750),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Fake Search Result
                        RecipeCard(
                          title: 'Spicy Garlic Noodles',
                          subtitle: '15 min · Asian',
                          thumbnailColor: const Color(0xFF8EC7E3),
                          imageUrl: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=500',
                          onTap: () {},
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