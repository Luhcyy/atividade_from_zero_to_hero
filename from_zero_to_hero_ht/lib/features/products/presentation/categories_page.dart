import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_to_hero_ht/features/products/presentation/providers/category_provider.dart';

import 'widgets/category_widget.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias de Produtos')),
      body: categories.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(categoriesProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final category = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: CategoryCard(category: category, indexColor: index),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Ocorreu um erro ao buscar as categorias.'),
                ),
                ElevatedButton(
                  onPressed: () => ref.invalidate(categoriesProvider),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
