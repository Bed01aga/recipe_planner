import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoritesKey = 'favorite_recipes';

  // Получить список id избранных рецептов
  static Future<List<int>> getFavoriteRecipeIds() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((idStr) => int.tryParse(idStr) ?? 0).where((id) => id != 0).toList();
  }

  // Проверка, является ли рецепт избранным
  static Future<bool> isFavorite(int recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(recipeId.toString());
  }

  // Добавить рецепт в избранное
  static Future<void> addFavorite(int recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(recipeId.toString())) {
      favorites.add(recipeId.toString());
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // Удалить рецепт из избранного
  static Future<void> removeFavorite(int recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(recipeId.toString());
    await prefs.setStringList(_favoritesKey, favorites);
  }
}
