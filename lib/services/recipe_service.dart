import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe_detail_model.dart';

class RecipeService {
  static const String apiKey = '5b83beb77df14b009238f4d090b12732';

  static Future<RecipeDetail?> fetchRecipeDetail(int id) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/$id/information?includeNutrition=false&apiKey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RecipeDetail.fromJson(data);
      } else {
        print('Chyba požadavku: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Chyba sítě: $e');
      return null;
    }
  }
}
