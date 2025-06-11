import 'package:flutter/material.dart';
import 'package:from_zero_to_hero_ht/features/products/domain/product.dart';

class ProductDetail extends StatefulWidget {
  // Alteração: Adicionado parâmetro de cor
  const ProductDetail({super.key, required this.product, required this.color});

  final Product product;
  final MaterialColor color; // Propriedade de cor adicionada

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted &&
          _pageController.hasClients &&
          _pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newTheme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: widget.color,
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
        appBar: AppBar(title: Text(widget.product.title)),
        body: Builder(
          builder: (themedContext) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImageCarousel(themedContext),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndBrand(themedContext),
                        const SizedBox(height: 16),
                        _buildPriceSection(themedContext),
                        const SizedBox(height: 16),
                        _buildRatingAndStock(themedContext),
                        const Divider(height: 32, thickness: 1),
                        _buildDescription(themedContext),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${widget.product.title} adicionado ao carrinho!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Adicionar ao Carrinho'),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndBrand(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.product.brand != null)
          Text(
            'Marca: ${widget.product.brand}',
            style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.grey[200],
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.product.images.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.product.images[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.product.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final originalPrice = widget.product.price;
    final discount = widget.product.discountPercentage;
    final finalPrice = originalPrice * (1 - discount / 100);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'R\$ ${finalPrice.toStringAsFixed(2)}',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        if (discount > 0)
          Text(
            'R\$ ${originalPrice.toStringAsFixed(2)}',
            style: textTheme.titleMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
        const SizedBox(width: 8),
        if (discount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${discount.toStringAsFixed(0)}% OFF',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingAndStock(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(widget.product.rating.toString(), style: textTheme.titleMedium),
        const SizedBox(width: 16),
        const Icon(Icons.inventory_2_outlined, color: Colors.grey, size: 20),
        const SizedBox(width: 4),
        Text(
          '${widget.product.stock} em estoque',
          style: textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(widget.product.description, style: textTheme.bodyLarge),
      ],
    );
  }
}
