import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  // Upsert products to Supabase
  static Future<void> upsertProducts(List<Product> products) async {
    try {
      await client.from('products').upsert(
            products.map((p) => p.toJson()).toList(),
            onConflict: 'id',
          );
    } catch (e) {
      print('Supabase upsert products error: $e');
      // Fallback to local data when Supabase is not configured
    }
  }

  // Upsert price entries
  static Future<void> upsertPriceEntries(List<PriceEntry> entries) async {
    try {
      await client.from('price_entries').upsert(
            entries.map((e) => e.toJson()).toList(),
            onConflict: 'id',
          );
    } catch (e) {
      print('Supabase upsert prices error: $e');
    }
  }

  // Upsert stores
  static Future<void> upsertStores(List<Store> stores) async {
    try {
      await client.from('stores').upsert(
            stores.map((s) => s.toJson()).toList(),
            onConflict: 'id',
          );
    } catch (e) {
      print('Supabase upsert stores error: $e');
    }
  }

  // Fetch products by category
  static Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      final response = await client
          .from('products')
          .select()
          .eq('category', category)
          .order('name');
      return (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      print('Supabase fetch products error: $e');
      return [];
    }
  }

  // Fetch price entries for a product
  static Future<List<PriceEntry>> fetchPricesForProduct(
      String productId) async {
    try {
      final response = await client
          .from('price_entries')
          .select()
          .eq('product_id', productId)
          .order('price');
      return (response as List)
          .map((json) => PriceEntry.fromJson(json))
          .toList();
    } catch (e) {
      print('Supabase fetch prices error: $e');
      return [];
    }
  }

  // Fetch nearby stores
  static Future<List<Store>> fetchStores() async {
    try {
      final response = await client.from('stores').select().order('name');
      return (response as List)
          .map((json) => Store.fromJson(json))
          .toList();
    } catch (e) {
      print('Supabase fetch stores error: $e');
      return [];
    }
  }

  // Sync all local data to Supabase
  static Future<void> syncAll({
    required List<Store> stores,
    required List<Product> products,
    required List<PriceEntry> prices,
  }) async {
    await Future.wait([
      upsertStores(stores),
      upsertProducts(products),
      upsertPriceEntries(prices),
    ]);
  }
}
