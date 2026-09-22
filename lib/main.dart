// This is your app. It runs as it is: press run and you get the screen below.
//
// Nothing here is precious. Change the title, change the colors, delete the
// counter, add your own screens. It exists so that the repository is a working
// Flutter app from minute one instead of an empty folder.
//
// Everything in this file is Module 4 and 5 material: StatelessWidget,
// StatefulWidget, setState, Scaffold, AppBar, Column, Card, FilledButton.

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

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  
  runApp(
    // DevicePreview draws a phone frame around your app, so it is judged at the
    // size it was designed for instead of stretched across a laptop window.
    //
    // It is left ON in the deployed build on purpose: your live link is opened
    // on a desktop browser, and a phone layout at full desktop width looks
    // broken when it is not. The toolbar also lets a visitor switch device and
    // orientation.
    //
    // Want the clean app with no frame instead (for a portfolio, or because
    // you made the layout properly responsive)? Add
    //   import 'package:flutter/foundation.dart' show kReleaseMode;
    // and set `enabled: !kReleaseMode`, which drops the frame in release builds.
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
    );

    return MaterialApp(
      title: 'DELITESS',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

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
        textTheme: const TextTheme(
          // headlineSmall: 20sp, Bold (Screen and recipe titles)
          headlineSmall: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Color(0xFF3A4750), 
          ),
          // bodyMedium: 16sp, Regular (Ingredients and steps)
          bodyMedium: TextStyle(
            fontSize: 16, 
            color: Color(0xFF3A4750),
          ),
          // labelSmall: 12sp, Regular (Captions using text-secondary at 65% opacity)
          labelSmall: TextStyle(
            fontSize: 12, 
            color: Color(0xA63A4750), 
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// The first screen. Replace it with yours.
///
/// It is a StatefulWidget because it remembers something that changes: the
/// counter. A screen that never changes can be a StatelessWidget instead.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _carouselController = ScrollController();
  Timer? _autoScrollTimer;
  

  @override
  void initState() {
    super.initState();
    _loadTaps();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer){
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
  
  int _taps = 0;

  

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

    final model = GenerativeModel(model: 'gemini-3.6-flash', apiKey: apiKey);

    final response = await model.generateContent([
      Content.multi([
        TextPart('What dish is this? Give me a brief recipe.'),
        DataPart('image/jpeg', bytes)
      ])
    ]);

    print(response.text);


  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EF),
      appBar: AppBar(
        title: const Text(
          'DELITESS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3A4750),

      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AskAiComposer(
              controller: _searchController, 
              onAttachPhoto: _testGemini, 
              onSubmit: (value) {
                print('Searching for: $value');
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Section Title
            const Text(
              'Trending Recipes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A4750),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Swipable horizontal carousel
           SizedBox(
              height: 160, 
              child: ListView(
                controller: _carouselController,
                scrollDirection: Axis.horizontal, 
                children: [
                  TrendingRecipeCard(
                    title: 'Chicken Adobo',
                    subtitle: '45 min',
                    imageUrl: 'https://panlasangpinoy.com/wp-content/uploads/2009/08/Pork-Adobo-Recipe.jpg',
                    onTap: () {},
                  ),
                  TrendingRecipeCard(
                    title: 'Pancit Canton',
                    subtitle: '30 min',
                    imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=500',
                    onTap: () {},
                  ),
                  TrendingRecipeCard(
                    title: 'Chicken Inasal',
                    subtitle: '50 min',
                    imageUrl: 'https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?w=500',
                    onTap: () {},
                  ),
                  TrendingRecipeCard(
                    title: 'Beef Tapa',
                    subtitle: '20 min',
                    imageUrl: 'https://i.pinimg.com/1200x/94/4b/bd/944bbd7ea3cf3329ccab337f1a98f3ed.jpg',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            // Recipe List
            Expanded(
              child: ListView(
                children: [
                  RecipeCard(
                    title: 'Chicken Adobo',
                    subtitle: '45 min · Filipino',
                    thumbnailColor: const Color(0xFF8EC7E3),
                    imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=500',
                    onTap: () {},
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
                    imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500', // NEW
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  RecipeCard(
                    title: 'Japanese Curry',
                    subtitle: '45 min · Japanese',
                    thumbnailColor: const Color(0xFFC9E4EE),
                    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500', // NEW
                    onTap: () {},
                  
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: AppNavBar(
        activeIndex: 0, 
        onTap: (index) {
          print('Tapped nav index: $index');
        },
      ),
    );
  }
}
