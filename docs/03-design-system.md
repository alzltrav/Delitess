# Design system

Paste in the design system you submitted, and replace it with the final version when the project is done[cite: 69]. It is also the reference you open every time you build a new screen, so keeping it current helps you more than it helps anyone reading[cite: 69].


![Design system](assets/home.png)
[Design system (PDF)](assets/DELITESS_Design_System_v2.pdf)[cite: 69]

---

## Palette

DELITESS supports both a warm Light Mode and an inverted Dark Mode. Rather than a full-black dark theme, the light mode's navy and cream relationship is inverted: navy becomes the background (`#232D35`, a deepened version of the navy, not pure black) and cream becomes the text (`#FAF6EF`). The primary (`#8EC7E3`) and accent (`#C9E4EE`) colors are unchanged in dark mode since they are light enough to read clearly against a dark surface.

| Role / Token | Light Mode Hex | Dark Mode Hex | Usage | Contrast Verification |
| :--- | :--- | :--- | :--- | :--- |
| **`background`** | `#FAF6EF`[cite: 8] | `#232D35`[cite: 8] | Screen background across all routes | Base canvas[cite: 8] |
| **`surface`** | `#FFFFFF`[cite: 8] | `#2D3740`[cite: 8] | Card surfaces, search composer, bottom bar | Elevated container[cite: 8] |
| **`primary`** | `#8EC7E3`[cite: 8] | `#8EC7E3`[cite: 8] | Accent seed, active nav icon, bullet points | Primary accent[cite: 8] |
| **`accent`** | `#C9E4EE`[cite: 8] | `#C9E4EE`[cite: 8] | Numbered step badges, image placeholder box | Secondary accent[cite: 8] |
| **`text`** | `#3A4750`[cite: 8] | `#FAF6EF`[cite: 8] | Primary headings, recipe titles, body copy | **Light:** 8.87:1 (AAA) · **Dark:** 13:1 (AAA)[cite: 8] |
| **`text-secondary`** | `#3A4750` (65%)[cite: 8] | `#FAF6EF` (65%)[cite: 8] | Subtitles, prep time, tags (`45 min · Filipino`) | Reduced visual weight[cite: 8, 11] |

### Step A: Palette, as a ColorScheme

```dart
final lightScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF8EC7E3),
  brightness: Brightness.light,
);

final darkScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF8EC7E3),
  brightness: Brightness.dark,
).copyWith(
  surface: const Color(0xFF232D35),
);
```

Figma, Canva, Excalidraw, Google Slides or Docs exported to PDF all work. A
reader should be able to see your app's look in one glance, without reading a
table.


## Type scale

The type scale establishes typographic hierarchy across screen titles, recipe titles, body lines, and metadata tags:   
- **`headlineSmall`**: `20sp` Bold — screen and recipe titles (e.g., *"Chicken Adobo"*).   
- **Hero Title**: `28sp` Bold — main dish title on `RecipeDetailScreen`.   
- **Card Title**: `16sp` Bold — dish titles inside `RecipeCard` and `TrendingRecipeCard`.   
- **`bodyMedium`**: `16sp` Regular — ingredients and instruction steps (e.g., *"Marinate chicken in soy sauce and garlic."*).   
- **`labelSmall`**: `12sp` Regular — captions, prep time, and cuisine tags, using `text-secondary` (e.g., *"45 min · Filipino"*).   

### Step B: Type scale, as a TextTheme

```dart
textTheme: const TextTheme(
  headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  bodyMedium: TextStyle(fontSize: 16),
  labelSmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
)
## Spacing

class AppSpacing {
  static const double xs = 8;  // space/1
  static const double sm = 16; // space/2
  static const double md = 24; // space/3
  static const double lg = 32; // space/4
}
```

## Components

One row per reusable widget: what it is, which file it lives in, what parameters
it takes, which screens use it[cite: 68].

| Component | File | Parameters | Appears on |
| :--- | :--- | :--- | :--- |
| **RecipeCard** | `lib/widgets/recipe_card.dart`[cite: 10, 66] | `String title`, `String subtitle`, `Color thumbnailColor`, `String? imageUrl`, `Uint8List? imageBytes`, `VoidCallback onTap`[cite: 10, 66] | Home, Search Results, Saved[cite: 10, 66] |
| **AskAiComposer** | `lib/widgets/ask_ai_composer.dart`[cite: 10, 66] | `TextEditingController controller`, `VoidCallback onAttachPhoto`, `ValueChanged<String> onSubmit`[cite: 10, 66] | Home, Search Results[cite: 10, 66] |
| **AppNavBar** | `lib/widgets/app_nav_bar.dart`[cite: 10, 66] | `int activeIndex`, `ValueChanged<int> onTap`[cite: 10, 66] | All 4 screens[cite: 10, 66] |
| **NumberedListItem** | `lib/widgets/numbered_list_item.dart`[cite: 10, 66] | `int index`, `String text`[cite: 10, 66] | Recipe Detail (ingredients, steps)[cite: 10, 66] |
| **EmptyState** | `lib/widgets/empty_state.dart`[cite: 10, 66] | `String message`, `IconData icon`[cite: 10, 66] | Saved (empty state)[cite: 10, 66] |
| **SaveButton** | `lib/widgets/save_button.dart`[cite: 10, 66] | `bool isSaved`, `VoidCallback onTap`[cite: 10, 66] | Recipe Detail[cite: 10, 66] |
| **TrendingRecipeCard** | `lib/widgets/trending_recipe_card.dart` | `String title`, `String subtitle`, `String imageUrl`, `VoidCallback onTap` | Home (horizontal carousel) |
| **ThemeController** | `lib/theme/theme_controller.dart` | `ValueNotifier<ThemeMode> themeMode`, `loadTheme()`, `toggleTheme()` | App root & Home AppBar |

Every component takes data and callbacks, never setState directly; SaveButton reports isSaved and calls onTap, it does not own the saved/unsaved state itself[cite: 10, 66]. const is used wherever the constructor allows it[cite: 10, 66].

## Changes since the last version

| Element | Prelim said | Now says | Why it changed |
| :--- | :--- | :--- | :--- |
| **Dark mode** | Not addressed; the prelim palette assumed one light theme with no explicit decision[cite: 10, 67]. | Yes, decided now: a dark navy background (`#232D35`) with cream text (`#FAF6EF`), not full black, built by inverting the existing navy/cream relationship rather than inventing a new palette[cite: 10, 67]. | Page A of this worksheet asks for the decision explicitly now rather than as a retrofit; building it as an inversion of the existing palette meant no new colors were needed, just the two roles swapped[cite: 10, 67]. |
| **Text color** | One navy value covered all text, headings and captions alike[cite: 11, 67]. | Split into text and text-secondary (navy/cream at 65% opacity), with its own row in the palette and its own TextTheme slot (`labelSmall`)[cite: 11, 67]. | Building the Doc 2 mockups showed captions and titles need different visual weight; one flat navy value could not do both[cite: 11, 67]. |
| **Component image handling** | RecipeCard only accepted a flat Color thumbnailColor placeholder box[cite: 10, 66]. | Extended to accept network image URLs (`Image.network`) and Base64-decoded memory bytes (`Image.memory`). | Accommodates Unsplash food photography and allows saved AI gallery recipes to persist their thumbnails offline. |