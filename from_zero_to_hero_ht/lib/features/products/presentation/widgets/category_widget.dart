import 'dart:math';

import 'package:flutter/material.dart';
import 'package:from_zero_to_hero_ht/features/products/presentation/products_category_page.dart';

MaterialColor getMaterialColor(int index) {
  final colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  return colors[index % colors.length];
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.indexColor,
  });

  final int indexColor;
  final String category;

  @override
  Widget build(BuildContext context) {
    MaterialColor color = getMaterialColor(indexColor);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: color.shade400,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: color.shade900.withValues(alpha: 0.4),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ProductByCategoryConsumer(category, color: color),
            ),
          );
        },
        child: SizedBox(
          width: 200,
          height: 150,
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: color.shade800.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              Positioned(
                top: -20,
                left: -20,
                child: Transform.rotate(
                  angle: pi / 4,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: color.shade900.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    category.replaceAll('-', ' ').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black54,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
