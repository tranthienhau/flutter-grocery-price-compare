import 'package:flutter/material.dart';
import '../models/product.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Store icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _chainIcon(store.chain),
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),

            // Store info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    store.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Distance badge
            if (store.distanceKm != null) ...[
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _distanceColor(store.distanceKm!).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 16,
                      color: _distanceColor(store.distanceKm!),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDistance(store.distanceKm!),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _distanceColor(store.distanceKm!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _chainIcon(String chain) {
    switch (chain.toLowerCase()) {
      case 'safeway':
        return Icons.storefront;
      case 'trader joe\'s':
        return Icons.eco;
      case 'whole foods':
        return Icons.spa;
      case 'costco':
        return Icons.warehouse;
      case 'walmart':
        return Icons.shopping_cart;
      case 'target':
        return Icons.gps_fixed;
      default:
        return Icons.store;
    }
  }

  Color _distanceColor(double km) {
    if (km < 3) return Colors.green;
    if (km < 10) return Colors.orange;
    return Colors.red;
  }

  String _formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
}
