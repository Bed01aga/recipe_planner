import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/recipe_service.dart';
import '../models/recipe_detail_model.dart';
import '../services/favorites_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  RecipeDetailScreen({required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeDetail? _recipeDetail;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadRecipeDetail();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    bool fav = await FavoritesService.isFavorite(widget.recipeId);
    setState(() {
      _isFavorite = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesService.removeFavorite(widget.recipeId);
    } else {
      await FavoritesService.addFavorite(widget.recipeId);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _loadRecipeDetail() async {
    final detail = await RecipeService.fetchRecipeDetail(widget.recipeId);
    setState(() {
      _recipeDetail = detail;
      _isLoading = false;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Chyba při otevírání odkazu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _recipeDetail == null
          ? Center(child: Text('Nepodařilo se načíst data'))
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _recipeDetail!.title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // zadáváme bílou barvu
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _recipeDetail!.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: _toggleFavorite,
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          '${_recipeDetail!.readyInMinutes} min',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.restaurant, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          '${_recipeDetail!.servings} porcí',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _launchUrl(_recipeDetail!.sourceUrl),
                      child: Text('Otevřít zdroj receptu'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
