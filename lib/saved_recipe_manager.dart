import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class SavedRecipeManager {
  static const String _storageKey = 'saved_recipes_list';

  
  static Future<List<Map<String, dynamic>>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList(_storageKey) ?? [];
    return rawList
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  
  static Future<bool> isRecipeSaved(String title) async {
    final recipes = await getSavedRecipes();
    return recipes.any((r) => r['title'] == title);
  }

  
  static Future<bool> toggleRecipe({
    required String title,
    required String time,
    String cuisine = 'Filipino',
    String? imageUrl,
    Uint8List? imageBytes,
    required List<String> ingredients,
    required List<String> instructions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = await getSavedRecipes();

    final existingIndex = recipes.indexWhere((r) => r['title'] == title);
    bool isNowSaved;

    if (existingIndex >= 0) {
      recipes.removeAt(existingIndex);
      isNowSaved = false;
    } else {
      recipes.add({
        'title': title,
        'time': time,
        'cuisine': cuisine,
        'imageUrl': imageUrl,
        'imageBase64': imageBytes != null ? base64Encode(imageBytes) : null,
        'ingredients': ingredients,
        'instructions': instructions,
      });
      isNowSaved = true;
    }

    final encodedList = recipes.map((r) => jsonEncode(r)).toList();
    await prefs.setStringList(_storageKey, encodedList);
    return isNowSaved;
  }
}