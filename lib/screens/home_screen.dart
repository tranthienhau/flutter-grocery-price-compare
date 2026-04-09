import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/store_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(storesProvider);
    final locationAsync = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(storesProvider);
              ref.invalidate(userLocationProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Location status bar
          locationAsync.when(
            data: (position) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    position != null
                        ? 'Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'
                        : 'Using default location',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.errorContainer,
              child: const Text('Could not determine location'),
            ),
          ),

          // Store list
          Expanded(
            child: storesAsync.when(
              data: (stores) {
                if (stores.isEmpty) {
                  return const Center(child: Text('No stores found nearby'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    return StoreCard(store: stores[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text('Error loading stores: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(storesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
