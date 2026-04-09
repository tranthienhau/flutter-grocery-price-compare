class Store {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String chain;
  double? distanceKm;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.chain,
    this.distanceKm,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      chain: json['chain'] as String,
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'chain': chain,
      if (distanceKm != null) 'distance_km': distanceKm,
    };
  }

  Store copyWith({double? distanceKm}) {
    return Store(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      chain: chain,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String? upc;
  final String unit;
  final double quantity;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.upc,
    required this.unit,
    required this.quantity,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      upc: json['upc'] as String?,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      if (upc != null) 'upc': upc,
      'unit': unit,
      'quantity': quantity,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}

class PriceEntry {
  final String id;
  final String productId;
  final String storeId;
  final double price;
  final double? salePrice;
  final bool onSale;
  final DateTime lastUpdated;
  final String currency;

  const PriceEntry({
    required this.id,
    required this.productId,
    required this.storeId,
    required this.price,
    this.salePrice,
    this.onSale = false,
    required this.lastUpdated,
    this.currency = 'USD',
  });

  double get effectivePrice => onSale && salePrice != null ? salePrice! : price;

  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      storeId: json['store_id'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice: json['sale_price'] != null
          ? (json['sale_price'] as num).toDouble()
          : null,
      onSale: json['on_sale'] as bool? ?? false,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'store_id': storeId,
      'price': price,
      if (salePrice != null) 'sale_price': salePrice,
      'on_sale': onSale,
      'last_updated': lastUpdated.toIso8601String(),
      'currency': currency,
    };
  }
}

class ComparisonResult {
  final Product product;
  final List<StorePriceInfo> storePrices;
  final double lowestPrice;
  final double highestPrice;
  final double averagePrice;
  final double potentialSavings;

  const ComparisonResult({
    required this.product,
    required this.storePrices,
    required this.lowestPrice,
    required this.highestPrice,
    required this.averagePrice,
    required this.potentialSavings,
  });

  factory ComparisonResult.fromEntries({
    required Product product,
    required List<PriceEntry> entries,
    required List<Store> stores,
  }) {
    final storePrices = entries.map((entry) {
      final store = stores.firstWhere(
        (s) => s.id == entry.storeId,
        orElse: () => Store(
          id: entry.storeId,
          name: 'Unknown',
          address: '',
          latitude: 0,
          longitude: 0,
          chain: '',
        ),
      );
      return StorePriceInfo(
        store: store,
        priceEntry: entry,
      );
    }).toList()
      ..sort((a, b) =>
          a.priceEntry.effectivePrice.compareTo(b.priceEntry.effectivePrice));

    final prices = entries.map((e) => e.effectivePrice).toList();
    final lowest = prices.isEmpty ? 0.0 : prices.reduce((a, b) => a < b ? a : b);
    final highest = prices.isEmpty ? 0.0 : prices.reduce((a, b) => a > b ? a : b);
    final average = prices.isEmpty
        ? 0.0
        : prices.reduce((a, b) => a + b) / prices.length;

    return ComparisonResult(
      product: product,
      storePrices: storePrices,
      lowestPrice: lowest,
      highestPrice: highest,
      averagePrice: average,
      potentialSavings: highest - lowest,
    );
  }
}

class StorePriceInfo {
  final Store store;
  final PriceEntry priceEntry;

  const StorePriceInfo({
    required this.store,
    required this.priceEntry,
  });

  bool get isCheapest => false; // Set externally during comparison
}

class MatchResult {
  final Product sourceProduct;
  final Product matchedProduct;
  final double confidence;
  final MatchType matchType;

  const MatchResult({
    required this.sourceProduct,
    required this.matchedProduct,
    required this.confidence,
    required this.matchType,
  });
}

enum MatchType {
  exactUpc,
  highNameSimilarity,
  brandAndCategory,
  fuzzyMatch,
}
