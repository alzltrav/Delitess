import 'dart:async';
import 'dart:convert';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'recipe_detail_screen.dart';
import 'saved_screen.dart';
import 'screens/search_screen.dart';
import 'theme/app_spacing.dart';
import 'theme/theme_controller.dart';
import 'widgets/app_nav_bar.dart';
import 'widgets/ask_ai_composer.dart';
import 'widgets/recipe_card.dart';
import 'widgets/trending_recipe_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await ThemeController.loadTheme();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8EC7E3),
      brightness: Brightness.light,
      surface: Colors.white,
      onSurface: const Color(0xFF3A4750),
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8EC7E3),
      brightness: Brightness.dark,
      surface: const Color(0xFF242B30),
      onSurface: const Color(0xFFFAF6EF),
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'DELITESS',
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          themeMode: currentMode,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
            },
          ),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
            scaffoldBackgroundColor: const Color(0xFFFAF6EF),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Color(0xFF3A4750),
              elevation: 0,
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A4750),
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Color(0xFF3A4750),
              ),
              labelSmall: TextStyle(
                fontSize: 12,
                color: Color(0xA63A4750),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
            scaffoldBackgroundColor: const Color(0xFF181C1F),
            cardColor: const Color(0xFF242B30),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Color(0xFFFAF6EF),
              elevation: 0,
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFAF6EF),
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Color(0xFFFAF6EF),
              ),
              labelSmall: TextStyle(
                fontSize: 12,
                color: Color(0xB3FAF6EF),
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _carouselController = ScrollController();
  Timer? _autoScrollTimer;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_carouselController.hasClients) {
        double maxScroll = _carouselController.position.maxScrollExtent;
        double currentScroll = _carouselController.position.pixels;
        double scrollAmount = 166.0;

        if (currentScroll + scrollAmount <= maxScroll) {
          _carouselController.animateTo(
            currentScroll + scrollAmount,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _carouselController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _autoScrollTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  void _openRecipe({
    required String title,
    required String time,
    required String cuisine,
    required String imageUrl,
    required List<String> ingredients,
    required List<String> instructions,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          title: title,
          time: time,
          cuisine: cuisine,
          imageUrl: imageUrl,
          ingredients: ingredients,
          instructions: instructions,
        ),
      ),
    );
  }

  Future<void> _testGemini() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      debugPrint('API Key is missing.');
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final model = GenerativeModel(
        model: 'gemini-3.6-flash',
        apiKey: apiKey,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'),
      );

      const prompt = '''
      Analyze this food image. Return a JSON object with this exact structure:
      {
        "title": "Name of the dish",
        "time": "Estimated cooking time (e.g. 20 min)",
        "cuisine": "Cuisine type (e.g. Mediterranean, Filipino, Japanese)",
        "ingredients": ["ingredient 1", "ingredient 2"],
        "instructions": ["step 1", "step 2"]
      }
      ''';

      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ])
      ]);

      if (mounted) Navigator.pop(context);

      final data = jsonDecode(response.text!);

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
          const SnackBar(
            content: Text('AI is currently busy. Please try again later!'),
          ),
        );
      }

      debugPrint('Gemini Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(
                'DELITESS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  tooltip: 'Toggle Dark Mode',
                  icon: Icon(
                    ThemeController.isDark ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () {
                    ThemeController.toggleTheme();
                  },
                ),
              ],
            )
          : null,
      body: _selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AskAiComposer(
                    controller: _searchController,
                    onAttachPhoto: _testGemini,
                    onSubmit: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen(initialQuery: value),
                        ),
                      );
                      _searchController.clear();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Trending Recipes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      controller: _carouselController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        TrendingRecipeCard(
                          title: 'Chicken Adobo',
                          subtitle: '45 min',
                          imageUrl:
                              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
                          onTap: () => _openRecipe(
                            title: 'Chicken Adobo',
                            time: '45 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
                            ingredients: const [
                              '1 kg Chicken (cut into pieces)',
                              '1/2 cup Soy Sauce',
                              '1/4 cup White Vinegar',
                              '1 head Garlic (minced)',
                              '1 tsp Whole Peppercorns',
                              '3 Dried Bay Leaves',
                            ],
                            instructions: const [
                              'Combine chicken, soy sauce, and garlic in a large bowl. Marinate for at least 1 hour.',
                              'Heat a cooking pot. Put-in the marinated chicken. Cook for 5 minutes.',
                              'Pour in the remaining marinade, water, peppercorns, and bay leaves. Boil and simmer for 30 minutes.',
                              'Add vinegar. Stir and cook for 10 minutes. Serve hot with rice!',
                            ],
                          ),
                        ),
                        TrendingRecipeCard(
                          title: 'Pancit Canton',
                          subtitle: '30 min',
                          imageUrl:
                              'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                          onTap: () => _openRecipe(
                            title: 'Pancit Canton',
                            time: '30 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                            ingredients: const [
                              '250g Flour noodles (Pancit Canton)',
                              '150g Pork belly (sliced thinly)',
                              '1 cup Cabbage (shredded)',
                              '1 Carrot (julienned)',
                              '3 tbsp Soy sauce & 2 tbsp Oyster sauce',
                              '2 cups Chicken broth',
                            ],
                            instructions: const [
                              'Sauté garlic, onion, and pork slices in a hot wok until lightly browned.',
                              'Pour in the chicken broth, soy sauce, and oyster sauce and bring to a boil.',
                              'Toss in the vegetables and cook for 2 minutes until tender-crisp.',
                              'Add the flour noodles and toss continuously until the liquid is absorbed.',
                            ],
                          ),
                        ),
                        TrendingRecipeCard(
                          title: 'Chicken Inasal',
                          subtitle: '50 min',
                          imageUrl:
                              'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=500',
                          onTap: () => _openRecipe(
                            title: 'Chicken Inasal',
                            time: '50 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=500',
                            ingredients: const [
                              '1 kg Chicken leg quarters',
                              '2 stalks Lemongrass (chopped)',
                              '1/4 cup Calamansi juice',
                              '1/4 cup Cane vinegar',
                              '3 tbsp Annatto (Atsuete) oil',
                              '6 cloves Garlic & 1 thumb Ginger (minced)',
                            ],
                            instructions: const [
                              'Combine lemongrass, calamansi juice, vinegar, garlic, ginger, salt, and pepper to make the marinade.',
                              'Marinate the chicken for at least 1 hour.',
                              'Grill the chicken over hot charcoal or in an oven for 35–40 minutes, turning occasionally.',
                              'Baste generously with annatto oil while grilling until golden and cooked through.',
                            ],
                          ),
                        ),
                        TrendingRecipeCard(
                          title: 'Beef Tapa',
                          subtitle: '20 min',
                          imageUrl:
                              'https://images.unsplash.com/photo-1690214691494-b2cfa5fb7d7e?w=500',
                          onTap: () => _openRecipe(
                            title: 'Beef Tapa',
                            time: '20 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1690214691494-b2cfa5fb7d7e?w=500',
                            ingredients: const [
                              '500g Beef sirloin (thinly sliced)',
                              '1/3 cup Soy sauce',
                              '3 tbsp Calamansi juice',
                              '6 cloves Garlic (crushed)',
                              '2 tbsp Brown sugar',
                              '1/2 tsp Ground black pepper',
                            ],
                            instructions: const [
                              'Mix soy sauce, calamansi juice, garlic, sugar, and black pepper in a bowl.',
                              'Marinate the thinly sliced beef for at least 30 minutes.',
                              'Heat oil in a skillet over medium-high heat and pan-fry the beef slices until caramelized and tender.',
                              'Serve hot with garlic fried rice and a sunny-side-up egg.',
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: ListView(
                      children: [
                        RecipeCard(
                          title: 'Chicken Adobo',
                          subtitle: '45 min · Filipino',
                          thumbnailColor: const Color(0xFF8EC7E3),
                          imageUrl:
                              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
                          onTap: () => _openRecipe(
                            title: 'Chicken Adobo',
                            time: '45 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
                            ingredients: const [
                              '1 kg Chicken (cut into pieces)',
                              '1/2 cup Soy Sauce',
                              '1/4 cup White Vinegar',
                              '1 head Garlic (minced)',
                              '1 tsp Whole Peppercorns',
                              '3 Dried Bay Leaves',
                            ],
                            instructions: const [
                              'Combine chicken, soy sauce, and garlic in a large bowl. Marinate for at least 1 hour.',
                              'Heat a cooking pot. Put-in the marinated chicken. Cook for 5 minutes.',
                              'Pour in the remaining marinade, water, peppercorns, and bay leaves. Boil and simmer for 30 minutes.',
                              'Add vinegar. Stir and cook for 10 minutes. Serve hot with rice!',
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RecipeCard(
                          title: 'Pancit Canton',
                          subtitle: '30 min · Filipino',
                          thumbnailColor: const Color(0xFFC9E4EE),
                          imageUrl:
                              'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                          onTap: () => _openRecipe(
                            title: 'Pancit Canton',
                            time: '30 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                            ingredients: const [
                              '250g Flour noodles (Pancit Canton)',
                              '150g Pork belly (sliced thinly)',
                              '1 cup Cabbage (shredded)',
                              '1 Carrot (julienned)',
                              '3 tbsp Soy sauce & 2 tbsp Oyster sauce',
                              '2 cups Chicken broth',
                            ],
                            instructions: const [
                              'Sauté garlic, onion, and pork slices in a hot wok until lightly browned.',
                              'Pour in the chicken broth, soy sauce, and oyster sauce and bring to a boil.',
                              'Toss in the vegetables and cook for 2 minutes until tender-crisp.',
                              'Add the flour noodles and toss continuously until the liquid is absorbed.',
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RecipeCard(
                          title: 'Sinigang na Baboy',
                          subtitle: '1 hr 10 min · Filipino',
                          thumbnailColor: const Color(0xFF8EC7E3),
                          imageUrl:
                              'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500',
                          onTap: () => _openRecipe(
                            title: 'Sinigang na Baboy',
                            time: '1 hr 10 min',
                            cuisine: 'Filipino',
                            imageUrl:
                                'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500',
                            ingredients: const [
                              '1 kg Pork belly or ribs',
                              '1 pack Tamarind soup base (Sinigang mix)',
                              '2 Tomatoes (quartered) & 1 Onion',
                              '1 cup Radish (sliced) & String beans',
                              '1 bunch Kangkong (water spinach)',
                              '2 tbsp Fish sauce (Patis)',
                            ],
                            instructions: const [
                              'Boil pork with onion and tomatoes in water for 45–50 minutes until tender.',
                              'Add radish, string beans, and tamarind soup base. Simmer for 8 minutes.',
                              'Season with fish sauce and add green chili peppers.',
                              'Stir in kangkong leaves, turn off the heat, and cover for 2 minutes before serving.',
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RecipeCard(
                          title: 'Japanese Curry',
                          subtitle: '45 min · Japanese',
                          thumbnailColor: const Color(0xFFC9E4EE),
                          imageUrl:
                              'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500',
                          onTap: () => _openRecipe(
                            title: 'Japanese Curry',
                            time: '45 min',
                            cuisine: 'Japanese',
                            imageUrl:
                                'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500',
                            ingredients: const [
                              '500g Chicken thigh or Beef chuck (cubed)',
                              '2 Potatoes & 1 Carrot (chopped)',
                              '1 large Onion (wedged)',
                              '1 pack Japanese curry roux blocks',
                              '3 cups Water',
                            ],
                            instructions: const [
                              'Sauté onion and meat in a pot until browned.',
                              'Add chopped potatoes, carrots, and water. Bring to a boil and simmer covered for 20 minutes.',
                              'Turn off the heat, break in the curry roux blocks, and stir until completely dissolved.',
                              'Simmer on low heat for 10 minutes until thick and glossy. Serve over steamed rice.',
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const SavedScreen(),
      bottomNavigationBar: AppNavBar(
        activeIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}