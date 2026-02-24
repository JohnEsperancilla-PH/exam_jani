import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipes.dart';

class RecipesViewModel extends ChangeNotifier {
  List<Recipes> recipes = [];
  bool isLoading = false;
  final _supabase = Supabase.instance.client;

  Future<void> fetchRecipes() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase.from('recipesPurchase').select();
      recipes = (data as List)
          .map((item) => Recipes.fromMap(item))
          .toList();
    } catch (e) {
      debugPrint('Error fetching recipes: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addRecipe(Recipes recipe) async {
    try {
      await _supabase.from('recipesPurchase').insert(recipe.toMap());
      await fetchRecipes();
    } catch (e) {
      debugPrint('Error adding recipe: $e');
      rethrow;
    }
  }

  Future<void> updateRecipe(Recipes recipe) async {
    try {
      await _supabase
          .from('recipesPurchase')
          .update(recipe.toMap())
          .eq('id', recipe.id!);
      await fetchRecipes();
    } catch (e) {
      debugPrint('Error updating recipe: $e');
      rethrow;
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      await _supabase.from('recipesPurchase').delete().eq('id', id);
      await fetchRecipes();
    } catch (e) {
      debugPrint('Error deleting recipe: $e');
      rethrow;
    }
  }
}
