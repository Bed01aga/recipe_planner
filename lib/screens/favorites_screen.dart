import 'package:flutter/material.dart';
import '../models/recipe_detail_model.dart';
import '../services/recipe_service.dart';
import '../services/favorites_service.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<RecipeDetail> _favoriteRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    // Получаем список ID избранных рецептов
    List<int> favoriteIds = await FavoritesService.getFavoriteRecipeIds();

    // Для каждого ID запрашиваем детали рецепта
    List<RecipeDetail> favorites = [];
    for (int id in favoriteIds) {
      RecipeDetail? detail = await RecipeService.fetchRecipeDetail(id);
      if (detail != null) {
        favorites.add(detail);
      }
    }

    setState(() {
      _favoriteRecipes = favorites;
      _isLoading = false;
    });
  }

  void _openRecipeDetail(int recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipeId: recipeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oblíbené recepty'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteRecipes.isEmpty
          ? Center(child: Text('Seznam oblíbených receptů je prázdný'))
          : ListView.builder(
        itemCount: _favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _favoriteRecipes[index];
          return GestureDetector(
            onTap: () => _openRecipeDetail(recipe.id),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Image.network(
                      recipe.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        recipe.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
