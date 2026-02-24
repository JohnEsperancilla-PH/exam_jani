import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipes.dart';
import '../view_models/recipes_view_model.dart';

class RecipeFormPage extends StatefulWidget {
  final Recipes? recipe;

  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.recipe?.productName ?? '');
  late final _qtyCtrl = TextEditingController(text: widget.recipe?.quantity.toString() ?? '');
  late final _priceCtrl = TextEditingController(text: widget.recipe?.price.toString() ?? '');

  bool get isEditing => widget.recipe != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final qty = int.parse(_qtyCtrl.text.trim());
    final price = double.parse(_priceCtrl.text.trim());

    final recipe = Recipes(
      id: widget.recipe?.id,
      productName: _nameCtrl.text.trim(),
      quantity: qty,
      price: price,
      totalPrice: qty * price,
    );

    final vm = context.read<RecipesViewModel>();

    try {
      if (isEditing) {
        await vm.updateRecipe(recipe);
      } else {
        await vm.addRecipe(recipe);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Recipe' : 'Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) return 'Enter a valid number';
                  if (int.parse(v.trim()) <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
                  if (double.parse(v.trim()) <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
