import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../services/product_matcher.dart';
import '../widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search for groceries (e.g., milk, bread, eggs)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),

          // Results info
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${searchResults.length} result${searchResults.length == 1 ? '' : 's'} for "$query"',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Results list
          Expanded(
            child: query.isEmpty
                ? _buildBrowseView(productsAsync)
                : searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products found for "$query"',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Try a different search term',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return ProductCard(
                            product: result.product,
                            subtitle:
                                'Relevance: ${(result.relevanceScore * 100).toStringAsFixed(0)}%',
                            trailing: _confidenceBadge(
                              result.relevanceScore,
                              context,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseView(AsyncValue productsAsync) {
    return productsAsync.when(
      data: (products) {
        // Group products by category
        final grouped = <String, List>{};
        for (final p in products) {
          grouped.putIfAbsent(p.category, () => []).add(p);
        }
        final categories = grouped.keys.toList()..sort();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final items = grouped[category]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ...items.map((product) => ProductCard(product: product)),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _confidenceBadge(double score, BuildContext context) {
    final label = ProductMatcher.confidenceLabel(score);
    final color = score >= 0.7
        ? Colors.green
        : score >= 0.5
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
