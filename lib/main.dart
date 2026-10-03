import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_spacing.dart';
import 'widgets/ask_ai_composer.dart';
import 'widgets/recipe_card.dart';
import 'widgets/app_nav_bar.dart';
import 'widgets/trending_recipe_card.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'screens/search_screen.dart';
import 'recipe_detail_screen.dart';
import 'saved_screen.dart';
import 'dart:convert';
import 'theme/theme_controller.dart';

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
          // LIGHT THEME
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
          // DARK THEME
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
  int _taps = 0;

  @override
  void initState() {
    super.initState();
    _loadTaps();

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

  Future<void> _loadTaps() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final savedTaps = sharedPrefs.getInt('tap') ?? 0;
    setState(() {
      _taps = savedTaps;
    });
  }

  Future<void> _handleTap() async {
    setState(() {
      _taps++;
    });
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt('tap', _taps);
  }

  Future<void> _testGemini() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      print('API Key is missing.');
      return;
    }

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

      final prompt = '''
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
          DataPart('image/jpeg', bytes)
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
          const SnackBar(content: Text('AI is currently busy. Please try again later!')),
        );
      }

      print('Gemini Error: $e');
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
                          builder: (context) => SearchScreen(initialQuery: value),
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
                        TrendingRecipeCard(
                          title: 'Pancit Canton',
                          subtitle: '30 min',
                          imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecipeDetailScreen(
                                  title: 'Pancit Canton',
                                  imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                                  time: '30 min',
                                ),
                              ),
                            );
                          },
                        ),
                        TrendingRecipeCard(
                          title: 'Chicken Inasal',
                          subtitle: '50 min',
                          imageUrl: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=500',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecipeDetailScreen(
                                  title: 'Chicken Inasal',
                                  imageUrl: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=500',
                                  time: '50 min',
                                ),
                              ),
                            );
                          },
                        ),
                        TrendingRecipeCard(
                          title: 'Beef Tapa',
                          subtitle: '20 min',
                          imageUrl: 'https://images.unsplash.com/photo-1690214691494-b2cfa5fb7d7e?w=500',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecipeDetailScreen(
                                  title: 'Beef Tapa',
                                  imageUrl: 'https://images.unsplash.com/photo-1690214691494-b2cfa5fb7d7e?w=500',
                                  time: '20 min',
                                ),
                              ),
                            );
                          },
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
                          title: 'Pancit Canton',
                          subtitle: '30 min · Filipino',
                          thumbnailColor: const Color(0xFFC9E4EE),
                          imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                          onTap: () {},
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RecipeCard(
                          title: 'Sinigang na Baboy',
                          subtitle: '1 hr 10 min · Filipino',
                          thumbnailColor: const Color(0xFF8EC7E3),
                          imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500',
                          onTap: () {},
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RecipeCard(
                          title: 'Japanese Curry',
                          subtitle: '45 min · Japanese',
                          thumbnailColor: const Color(0xFFC9E4EE),
                          imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500',
                          onTap: () {},
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