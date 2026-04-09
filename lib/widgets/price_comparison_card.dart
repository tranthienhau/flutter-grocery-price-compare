import 'package:flutter/material.dart';
import '../models/product.dart';

class PriceComparisonCard extends StatelessWidget {
  final StorePriceInfo storePrice;
  final bool isCheapest;
  final double lowestPrice;

  const PriceComparisonCard({
    super.key,
    required this.storePrice,
    required this.isCheapest,
    required this.lowestPrice,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final entry = storePrice.priceEntry;
    final store = storePrice.store;
    final priceDiff = entry.effectivePrice - lowestPrice;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: isCheapest ? 2 : 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCheapest
            ? BorderSide(color: Colors.green.shade400, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Rank indicator
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCheapest
                    ? Colors.green.withOpacity(0.15)
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: isCheapest
                  ? const Icon(Icons.star, color: Colors.green, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),

            // Store info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        store.chain,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      if (store.distanceKm != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        Text(
                          ' ${store.distanceKm!.toStringAsFixed(1)} km',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ],
                  ),
                  if (entry.onSale) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ON SALE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Price display
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (entry.onSale && entry.salePrice != null) ...[
                  Text(
                    '\$${entry.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
                Text(
                  '\$${entry.effectivePrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCheapest
                            ? Colors.green
                            : colorScheme.onSurface,
                      ),
                ),
                if (!isCheapest && priceDiff > 0)
                  Text(
                    '+\$${priceDiff.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontSize: 11,
                        ),
                  ),
                if (isCheapest)
                  Text(
                    'Best Price',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
