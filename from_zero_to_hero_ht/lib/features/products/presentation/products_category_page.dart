import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_to_hero_ht/features/products/presentation/providers/product_provider.dart';
import 'package:from_zero_to_hero_ht/features/products/presentation/widgets/product_card_widget.dart';

class ProductByCategoryConsumer extends ConsumerWidget {
  const ProductByCategoryConsumer(
    this.category, {
    required this.color,
    super.key,
  });

  final String category;
  final MaterialColor color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsByCategoryProvider(category: category));
    final newTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      ),
    );

    return Theme(
      data: newTheme.copyWith(
        appBarTheme: newTheme.appBarTheme.copyWith(
          backgroundColor: newTheme.colorScheme.primary,
          foregroundColor: newTheme.colorScheme.onPrimary,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.replaceAll('-', ' ').toUpperCase()),
        ),
        body: products.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(
                child: Text('Nenhum produto encontrado nesta categoria.'),
              );
            }
            return RefreshIndicator(
              onRefresh:
                  () => ref.refresh(
                    productsByCategoryProvider(category: category).future,
                  ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final product = data[index];
                  return ProductCardWidget(product: product, color: color);
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
                    child: Text('Ocorreu um erro ao buscar os produtos.'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => ref.invalidate(
                          productsByCategoryProvider(category: category),
                        ),
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
      ),
    );
  }
}
