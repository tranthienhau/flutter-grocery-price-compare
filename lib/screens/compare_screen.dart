import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/product.dart';
import '../widgets/price_comparison_card.dart';

class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Compare'),
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: selectedCategory == null,
                    onSelected: (_) {
                      ref.read(selectedCategoryProvider.notifier).state = null;
                    },
                  ),
                ),
                ...categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (_) {
                        ref.read(selectedCategoryProvider.notifier).state =
                            selectedCategory == category ? null : category;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          // Product selector dropdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: productsAsync.when(
              data: (_) {
                return DropdownButtonFormField<String>(
                  value: _selectedProductId,
                  decoration: const InputDecoration(
                    labelText: 'Select a product to compare',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_cart),
                  ),
                  isExpanded: true,
                  items: filteredProducts.map((product) {
                    return DropdownMenuItem(
                      value: product.id,
                      child: Text(
                        '${product.name} - ${product.brand}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProductId = value;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ),

          // Comparison results
          Expanded(
            child: _selectedProductId == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.compare_arrows,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Select a product to see price comparison',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildComparisonView(_selectedProductId!),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonView(String productId) {
    final comparisonAsync = ref.watch(comparisonResultsProvider(productId));

    return comparisonAsync.when(
      data: (comparison) {
        if (comparison.storePrices.isEmpty) {
          return const Center(child: Text('No prices found for this product'));
        }

        return Column(
          children: [
            // Summary card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem(
                    'Lowest',
                    '\$${comparison.lowestPrice.toStringAsFixed(2)}',
                    Colors.green,
                  ),
                  _summaryItem(
                    'Average',
                    '\$${comparison.averagePrice.toStringAsFixed(2)}',
                    Colors.orange,
                  ),
                  _summaryItem(
                    'Highest',
                    '\$${comparison.highestPrice.toStringAsFixed(2)}',
                    Colors.red,
                  ),
                  _summaryItem(
                    'Savings',
                    '\$${comparison.potentialSavings.toStringAsFixed(2)}',
                    Colors.blue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Store price list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: comparison.storePrices.length,
                itemBuilder: (context, index) {
                  final storePrice = comparison.storePrices[index];
                  final isCheapest = index == 0;
                  return PriceComparisonCard(
                    storePrice: storePrice,
                    isCheapest: isCheapest,
                    lowestPrice: comparison.lowestPrice,
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
