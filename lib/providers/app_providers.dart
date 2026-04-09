import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/product.dart';
import '../services/scraper_api.dart';
import '../services/product_matcher.dart';

// ---------------------------------------------------------------------------
// Location Provider
// ---------------------------------------------------------------------------

final userLocationProvider = FutureProvider<Position?>((ref) async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return _defaultPosition();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return _defaultPosition();
    }
    if (permission == LocationPermission.deniedForever) {
      return _defaultPosition();
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      ),
    );
  } catch (e) {
    print('Location error: $e');
    return _defaultPosition();
  }
});

Position _defaultPosition() {
  // Default: San Francisco city center
  return Position(
    latitude: 37.7749,
    longitude: -122.4194,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

// ---------------------------------------------------------------------------
// Store Providers
// ---------------------------------------------------------------------------

final storesProvider = FutureProvider<List<Store>>((ref) async {
  final stores = await ScraperApi.fetchStores();
  final position = await ref.watch(userLocationProvider.future);

  if (position != null) {
    for (var store in stores) {
      store.distanceKm = _calculateDistance(
        position.latitude,
        position.longitude,
        store.latitude,
        store.longitude,
      );
    }
    stores.sort((a, b) =>
        (a.distanceKm ?? double.infinity)
            .compareTo(b.distanceKm ?? double.infinity));
  }

  return stores;
});

final selectedStoreProvider = StateProvider<Store?>((ref) => null);

// ---------------------------------------------------------------------------
// Product Providers
// ---------------------------------------------------------------------------

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return ScraperApi.fetchProducts();
});

final allPricesProvider = FutureProvider<List<PriceEntry>>((ref) async {
  return ScraperApi.fetchAllPrices();
});

final productPricesProvider =
    FutureProvider.family<List<PriceEntry>, String>((ref, productId) async {
  return ScraperApi.fetchPricesForProduct(productId);
});

// ---------------------------------------------------------------------------
// Comparison Provider
// ---------------------------------------------------------------------------

final comparisonResultsProvider =
    FutureProvider.family<ComparisonResult, String>((ref, productId) async {
  final products = await ref.watch(productsProvider.future);
  final prices = await ref.watch(productPricesProvider(productId).future);
  final stores = await ref.watch(storesProvider.future);

  final product = products.firstWhere((p) => p.id == productId);

  return ComparisonResult.fromEntries(
    product: product,
    entries: prices,
    stores: stores,
  );
});

// ---------------------------------------------------------------------------
// Search Provider
// ---------------------------------------------------------------------------

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<ProductSearchResult>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final productsAsync = ref.watch(productsProvider);

  return productsAsync.when(
    data: (products) => ProductMatcher.searchProducts(
      query: query,
      products: products,
    ),
    loading: () => [],
    error: (_, __) => [],
  );
});

// ---------------------------------------------------------------------------
// Category Filter Provider
// ---------------------------------------------------------------------------

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final categoriesProvider = Provider<List<String>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.when(
    data: (products) {
      final categories = products.map((p) => p.category).toSet().toList();
      categories.sort();
      return categories;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsAsync.when(
    data: (products) {
      if (selectedCategory == null) return products;
      return products.where((p) => p.category == selectedCategory).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

double _calculateDistance(
    double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371.0; // km
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _toRadians(double degrees) => degrees * pi / 180;
