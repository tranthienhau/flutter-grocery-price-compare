import '../models/product.dart';

/// Mock Bright Data scraper API that simulates fetching grocery product
/// data with pricing per store. In production, this would call the
/// Bright Data Scraping Browser or Dataset API to collect real-time
/// pricing from retailer websites.
class ScraperApi {
  // Simulated API delay
  static const _apiDelay = Duration(milliseconds: 800);

  /// Fetch all available stores (simulating Bright Data location discovery)
  static Future<List<Store>> fetchStores() async {
    await Future.delayed(_apiDelay);
    return _mockStores;
  }

  /// Fetch products for a given store (simulating scraping a retailer site)
  static Future<List<Product>> fetchProducts({String? storeId}) async {
    await Future.delayed(_apiDelay);
    return _mockProducts;
  }

  /// Fetch prices for a specific product across all stores
  static Future<List<PriceEntry>> fetchPricesForProduct(
      String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockPriceEntries
        .where((entry) => entry.productId == productId)
        .toList();
  }

  /// Fetch all prices across all stores (bulk scrape simulation)
  static Future<List<PriceEntry>> fetchAllPrices() async {
    await Future.delayed(_apiDelay);
    return _mockPriceEntries;
  }

  /// Fetch prices for a specific store
  static Future<List<PriceEntry>> fetchPricesForStore(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockPriceEntries
        .where((entry) => entry.storeId == storeId)
        .toList();
  }

  /// Search products by query (simulating search endpoint)
  static Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _mockProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.brand.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Mock Data - Realistic grocery stores in San Francisco Bay Area
  // ---------------------------------------------------------------------------

  static final List<Store> _mockStores = [
    Store(
      id: 'store_1',
      name: 'Safeway - Mission District',
      address: '4950 Mission St, San Francisco, CA 94112',
      latitude: 37.7194,
      longitude: -122.4398,
      chain: 'Safeway',
    ),
    Store(
      id: 'store_2',
      name: 'Trader Joe\'s - Masonic',
      address: '3 Masonic Ave, San Francisco, CA 94118',
      latitude: 37.7842,
      longitude: -122.4464,
      chain: 'Trader Joe\'s',
    ),
    Store(
      id: 'store_3',
      name: 'Whole Foods - SoMa',
      address: '399 4th St, San Francisco, CA 94107',
      latitude: 37.7822,
      longitude: -122.4005,
      chain: 'Whole Foods',
    ),
    Store(
      id: 'store_4',
      name: 'Costco - South SF',
      address: '451 S Airport Blvd, South San Francisco, CA 94080',
      latitude: 37.6547,
      longitude: -122.4077,
      chain: 'Costco',
    ),
    Store(
      id: 'store_5',
      name: 'Walmart Neighborhood - Daly City',
      address: '133 Serramonte Ctr, Daly City, CA 94015',
      latitude: 37.6713,
      longitude: -122.4736,
      chain: 'Walmart',
    ),
    Store(
      id: 'store_6',
      name: 'Target - Metreon',
      address: '789 Mission St, San Francisco, CA 94103',
      latitude: 37.7830,
      longitude: -122.4036,
      chain: 'Target',
    ),
  ];

  static final List<Product> _mockProducts = [
    // Dairy
    const Product(
      id: 'prod_milk_whole',
      name: 'Whole Milk',
      brand: 'Horizon Organic',
      category: 'Dairy',
      upc: '036632001002',
      unit: 'gallon',
      quantity: 1,
    ),
    const Product(
      id: 'prod_milk_2pct',
      name: '2% Reduced Fat Milk',
      brand: 'Organic Valley',
      category: 'Dairy',
      upc: '093966001006',
      unit: 'gallon',
      quantity: 1,
    ),
    const Product(
      id: 'prod_eggs_large',
      name: 'Large Eggs, Grade A',
      brand: 'Eggland\'s Best',
      category: 'Dairy',
      upc: '072036700124',
      unit: 'dozen',
      quantity: 12,
    ),
    const Product(
      id: 'prod_butter',
      name: 'Unsalted Butter',
      brand: 'Kerrygold',
      category: 'Dairy',
      upc: '767707001104',
      unit: 'oz',
      quantity: 8,
    ),
    const Product(
      id: 'prod_yogurt',
      name: 'Greek Yogurt, Plain',
      brand: 'Chobani',
      category: 'Dairy',
      upc: '894700010014',
      unit: 'oz',
      quantity: 32,
    ),
    // Bakery
    const Product(
      id: 'prod_bread_wheat',
      name: 'Whole Wheat Bread',
      brand: 'Dave\'s Killer Bread',
      category: 'Bakery',
      upc: '013764021921',
      unit: 'loaf',
      quantity: 1,
    ),
    const Product(
      id: 'prod_bread_white',
      name: 'White Sandwich Bread',
      brand: 'Wonder',
      category: 'Bakery',
      upc: '045000000001',
      unit: 'loaf',
      quantity: 1,
    ),
    // Produce
    const Product(
      id: 'prod_bananas',
      name: 'Organic Bananas',
      brand: 'Dole',
      category: 'Produce',
      upc: '000000004011',
      unit: 'lb',
      quantity: 1,
    ),
    const Product(
      id: 'prod_avocados',
      name: 'Hass Avocados',
      brand: 'Mission',
      category: 'Produce',
      upc: '000000004046',
      unit: 'each',
      quantity: 1,
    ),
    const Product(
      id: 'prod_strawberries',
      name: 'Fresh Strawberries',
      brand: 'Driscoll\'s',
      category: 'Produce',
      upc: '000000004089',
      unit: 'lb',
      quantity: 1,
    ),
    // Meat
    const Product(
      id: 'prod_chicken_breast',
      name: 'Boneless Skinless Chicken Breast',
      brand: 'Foster Farms',
      category: 'Meat',
      upc: '075280000123',
      unit: 'lb',
      quantity: 1,
    ),
    const Product(
      id: 'prod_ground_beef',
      name: '85% Lean Ground Beef',
      brand: 'Organic Prairie',
      category: 'Meat',
      upc: '072436000456',
      unit: 'lb',
      quantity: 1,
    ),
    // Pantry
    const Product(
      id: 'prod_pasta',
      name: 'Spaghetti Pasta',
      brand: 'Barilla',
      category: 'Pantry',
      upc: '076808006124',
      unit: 'oz',
      quantity: 16,
    ),
    const Product(
      id: 'prod_rice',
      name: 'Long Grain White Rice',
      brand: 'Jasmine',
      category: 'Pantry',
      upc: '074265000102',
      unit: 'lb',
      quantity: 5,
    ),
    const Product(
      id: 'prod_olive_oil',
      name: 'Extra Virgin Olive Oil',
      brand: 'California Olive Ranch',
      category: 'Pantry',
      upc: '850687000012',
      unit: 'oz',
      quantity: 16.9,
    ),
    // Beverages
    const Product(
      id: 'prod_coffee',
      name: 'Medium Roast Ground Coffee',
      brand: 'Peet\'s Coffee',
      category: 'Beverages',
      upc: '075211002010',
      unit: 'oz',
      quantity: 12,
    ),
    const Product(
      id: 'prod_oj',
      name: 'Orange Juice, No Pulp',
      brand: 'Tropicana',
      category: 'Beverages',
      upc: '048500003411',
      unit: 'oz',
      quantity: 52,
    ),
  ];

  static final List<PriceEntry> _mockPriceEntries = [
    // Whole Milk prices across stores
    PriceEntry(id: 'pe_1', productId: 'prod_milk_whole', storeId: 'store_1', price: 5.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_2', productId: 'prod_milk_whole', storeId: 'store_2', price: 4.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_3', productId: 'prod_milk_whole', storeId: 'store_3', price: 6.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_4', productId: 'prod_milk_whole', storeId: 'store_4', price: 4.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_5', productId: 'prod_milk_whole', storeId: 'store_5', price: 4.78, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_6', productId: 'prod_milk_whole', storeId: 'store_6', price: 5.49, lastUpdated: DateTime(2026, 4, 8)),

    // 2% Milk
    PriceEntry(id: 'pe_7', productId: 'prod_milk_2pct', storeId: 'store_1', price: 5.79, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_8', productId: 'prod_milk_2pct', storeId: 'store_2', price: 4.79, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_9', productId: 'prod_milk_2pct', storeId: 'store_3', price: 6.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_10', productId: 'prod_milk_2pct', storeId: 'store_4', price: 4.29, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_11', productId: 'prod_milk_2pct', storeId: 'store_5', price: 4.58, lastUpdated: DateTime(2026, 4, 8)),

    // Eggs
    PriceEntry(id: 'pe_12', productId: 'prod_eggs_large', storeId: 'store_1', price: 4.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_13', productId: 'prod_eggs_large', storeId: 'store_2', price: 3.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_14', productId: 'prod_eggs_large', storeId: 'store_3', price: 5.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_15', productId: 'prod_eggs_large', storeId: 'store_4', price: 3.49, salePrice: 2.99, onSale: true, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_16', productId: 'prod_eggs_large', storeId: 'store_5', price: 3.79, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_17', productId: 'prod_eggs_large', storeId: 'store_6', price: 4.29, lastUpdated: DateTime(2026, 4, 8)),

    // Butter
    PriceEntry(id: 'pe_18', productId: 'prod_butter', storeId: 'store_1', price: 4.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_19', productId: 'prod_butter', storeId: 'store_2', price: 3.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_20', productId: 'prod_butter', storeId: 'store_3', price: 5.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_21', productId: 'prod_butter', storeId: 'store_4', price: 3.79, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_22', productId: 'prod_butter', storeId: 'store_5', price: 3.98, lastUpdated: DateTime(2026, 4, 8)),

    // Yogurt
    PriceEntry(id: 'pe_23', productId: 'prod_yogurt', storeId: 'store_1', price: 5.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_24', productId: 'prod_yogurt', storeId: 'store_2', price: 4.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_25', productId: 'prod_yogurt', storeId: 'store_3', price: 6.29, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_26', productId: 'prod_yogurt', storeId: 'store_4', price: 4.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_27', productId: 'prod_yogurt', storeId: 'store_6', price: 5.29, lastUpdated: DateTime(2026, 4, 8)),

    // Whole Wheat Bread
    PriceEntry(id: 'pe_28', productId: 'prod_bread_wheat', storeId: 'store_1', price: 5.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_29', productId: 'prod_bread_wheat', storeId: 'store_2', price: 4.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_30', productId: 'prod_bread_wheat', storeId: 'store_3', price: 6.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_31', productId: 'prod_bread_wheat', storeId: 'store_5', price: 4.98, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_32', productId: 'prod_bread_wheat', storeId: 'store_6', price: 5.49, lastUpdated: DateTime(2026, 4, 8)),

    // White Bread
    PriceEntry(id: 'pe_33', productId: 'prod_bread_white', storeId: 'store_1', price: 3.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_34', productId: 'prod_bread_white', storeId: 'store_2', price: 2.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_35', productId: 'prod_bread_white', storeId: 'store_4', price: 2.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_36', productId: 'prod_bread_white', storeId: 'store_5', price: 2.68, lastUpdated: DateTime(2026, 4, 8)),

    // Bananas
    PriceEntry(id: 'pe_37', productId: 'prod_bananas', storeId: 'store_1', price: 0.79, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_38', productId: 'prod_bananas', storeId: 'store_2', price: 0.29, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_39', productId: 'prod_bananas', storeId: 'store_3', price: 0.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_40', productId: 'prod_bananas', storeId: 'store_4', price: 0.59, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_41', productId: 'prod_bananas', storeId: 'store_5', price: 0.58, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_42', productId: 'prod_bananas', storeId: 'store_6', price: 0.69, lastUpdated: DateTime(2026, 4, 8)),

    // Avocados
    PriceEntry(id: 'pe_43', productId: 'prod_avocados', storeId: 'store_1', price: 1.50, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_44', productId: 'prod_avocados', storeId: 'store_2', price: 0.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_45', productId: 'prod_avocados', storeId: 'store_3', price: 2.00, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_46', productId: 'prod_avocados', storeId: 'store_4', price: 0.89, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_47', productId: 'prod_avocados', storeId: 'store_5', price: 0.98, lastUpdated: DateTime(2026, 4, 8)),

    // Strawberries
    PriceEntry(id: 'pe_48', productId: 'prod_strawberries', storeId: 'store_1', price: 3.99, salePrice: 2.99, onSale: true, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_49', productId: 'prod_strawberries', storeId: 'store_2', price: 3.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_50', productId: 'prod_strawberries', storeId: 'store_3', price: 4.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_51', productId: 'prod_strawberries', storeId: 'store_5', price: 3.28, lastUpdated: DateTime(2026, 4, 8)),

    // Chicken Breast
    PriceEntry(id: 'pe_52', productId: 'prod_chicken_breast', storeId: 'store_1', price: 5.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_53', productId: 'prod_chicken_breast', storeId: 'store_2', price: 6.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_54', productId: 'prod_chicken_breast', storeId: 'store_3', price: 8.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_55', productId: 'prod_chicken_breast', storeId: 'store_4', price: 4.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_56', productId: 'prod_chicken_breast', storeId: 'store_5', price: 5.48, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_57', productId: 'prod_chicken_breast', storeId: 'store_6', price: 6.49, lastUpdated: DateTime(2026, 4, 8)),

    // Ground Beef
    PriceEntry(id: 'pe_58', productId: 'prod_ground_beef', storeId: 'store_1', price: 6.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_59', productId: 'prod_ground_beef', storeId: 'store_3', price: 9.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_60', productId: 'prod_ground_beef', storeId: 'store_4', price: 5.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_61', productId: 'prod_ground_beef', storeId: 'store_5', price: 5.78, lastUpdated: DateTime(2026, 4, 8)),

    // Pasta
    PriceEntry(id: 'pe_62', productId: 'prod_pasta', storeId: 'store_1', price: 1.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_63', productId: 'prod_pasta', storeId: 'store_2', price: 1.29, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_64', productId: 'prod_pasta', storeId: 'store_3', price: 2.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_65', productId: 'prod_pasta', storeId: 'store_4', price: 0.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_66', productId: 'prod_pasta', storeId: 'store_5', price: 1.18, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_67', productId: 'prod_pasta', storeId: 'store_6', price: 1.49, lastUpdated: DateTime(2026, 4, 8)),

    // Rice
    PriceEntry(id: 'pe_68', productId: 'prod_rice', storeId: 'store_1', price: 5.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_69', productId: 'prod_rice', storeId: 'store_2', price: 4.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_70', productId: 'prod_rice', storeId: 'store_3', price: 6.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_71', productId: 'prod_rice', storeId: 'store_4', price: 3.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_72', productId: 'prod_rice', storeId: 'store_5', price: 4.28, lastUpdated: DateTime(2026, 4, 8)),

    // Olive Oil
    PriceEntry(id: 'pe_73', productId: 'prod_olive_oil', storeId: 'store_1', price: 8.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_74', productId: 'prod_olive_oil', storeId: 'store_2', price: 7.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_75', productId: 'prod_olive_oil', storeId: 'store_3', price: 10.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_76', productId: 'prod_olive_oil', storeId: 'store_4', price: 7.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_77', productId: 'prod_olive_oil', storeId: 'store_6', price: 8.49, lastUpdated: DateTime(2026, 4, 8)),

    // Coffee
    PriceEntry(id: 'pe_78', productId: 'prod_coffee', storeId: 'store_1', price: 9.99, salePrice: 7.99, onSale: true, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_79', productId: 'prod_coffee', storeId: 'store_2', price: 8.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_80', productId: 'prod_coffee', storeId: 'store_3', price: 11.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_81', productId: 'prod_coffee', storeId: 'store_4', price: 7.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_82', productId: 'prod_coffee', storeId: 'store_5', price: 8.48, lastUpdated: DateTime(2026, 4, 8)),

    // Orange Juice
    PriceEntry(id: 'pe_83', productId: 'prod_oj', storeId: 'store_1', price: 4.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_84', productId: 'prod_oj', storeId: 'store_2', price: 3.99, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_85', productId: 'prod_oj', storeId: 'store_3', price: 5.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_86', productId: 'prod_oj', storeId: 'store_4', price: 3.49, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_87', productId: 'prod_oj', storeId: 'store_5', price: 3.78, lastUpdated: DateTime(2026, 4, 8)),
    PriceEntry(id: 'pe_88', productId: 'prod_oj', storeId: 'store_6', price: 4.29, lastUpdated: DateTime(2026, 4, 8)),
  ];
}
