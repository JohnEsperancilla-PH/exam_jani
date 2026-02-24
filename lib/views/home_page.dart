import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/recipes_view_model.dart';
import 'recipe_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipesViewModel>().fetchRecipes();
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RecipesViewModel>().deleteRecipe(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes Purchase')),
      body: Consumer<RecipesViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.recipes.isEmpty) {
            return const Center(child: Text('No recipes yet.'));
          }
          return ListView.builder(
            itemCount: vm.recipes.length,
            itemBuilder: (context, index) {
              final r = vm.recipes[index];
              return ListTile(
                title: Text(r.productName),
                subtitle: Text(
                  'Qty: ${r.quantity} x ₱${r.price.toStringAsFixed(2)} = ₱${r.totalPrice.toStringAsFixed(2)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeFormPage(recipe: r),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(r.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecipeFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
