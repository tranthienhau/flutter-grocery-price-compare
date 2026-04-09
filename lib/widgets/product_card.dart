import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _categoryColor(product.category).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _categoryIcon(product.category),
                  size: 20,
                  color: _categoryColor(product.category),
                ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.brand} - ${product.quantity} ${product.unit}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing widget
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'dairy':
        return Icons.water_drop;
      case 'bakery':
        return Icons.bakery_dining;
      case 'produce':
        return Icons.eco;
      case 'meat':
        return Icons.restaurant;
      case 'pantry':
        return Icons.kitchen;
      case 'beverages':
        return Icons.local_cafe;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'dairy':
        return Colors.blue;
      case 'bakery':
        return Colors.brown;
      case 'produce':
        return Colors.green;
      case 'meat':
        return Colors.red;
      case 'pantry':
        return Colors.amber;
      case 'beverages':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
