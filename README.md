# Flutter Grocery Price Compare

A Flutter POC demonstrating grocery price comparison across multiple retailers with product matching, location-based store selection, and Supabase integration.

## Features

- **Retailer Data Integration** - Simulates Bright Data scraping API for fetching product/pricing data from multiple grocery chains (Safeway, Trader Joe's, Whole Foods, Costco, Walmart, Target)
- **Product Matching Engine** - Fuzzy matching by product name, brand, UPC/barcode with confidence scoring (exact UPC, high similarity, brand+category, fuzzy)
- **Location-Based Stores** - Uses geolocator to find nearby stores sorted by distance
- **Price Comparison** - Side-by-side pricing across all stores with lowest/average/highest/savings summary
- **Supabase Persistence** - Full Supabase integration for storing products, prices, and store data
- **Product Search** - Fuzzy search with relevance scoring and category browsing

## Tech Stack

- Flutter + Riverpod (state management)
- go_router (navigation)
- Supabase (backend/persistence)
- Geolocator + Google Maps
- string_similarity (fuzzy matching)

## Project Structure

```
lib/
  main.dart                    - App entry with ProviderScope
  app.dart                     - MaterialApp.router with GoRouter (3 tabs)
  models/
    product.dart               - Product, Store, PriceEntry, ComparisonResult
  providers/
    app_providers.dart         - Riverpod providers for state management
  services/
    supabase_service.dart      - Supabase CRUD operations
    scraper_api.dart           - Mock Bright Data scraper with realistic data
    product_matcher.dart       - Product matching/normalization engine
  screens/
    home_screen.dart           - Nearby stores with distance display
    compare_screen.dart        - Price comparison with category filters
    search_screen.dart         - Fuzzy product search
  widgets/
    store_card.dart            - Store card with chain icon and distance
    product_card.dart          - Product card with category styling
    price_comparison_card.dart - Price comparison with sale indicators
```

## Getting Started

1. Clone the repo
2. Set up Supabase project and add credentials via environment variables
3. Run `flutter pub get`
4. Run `flutter run`

## Supabase Setup

Create the following tables in your Supabase project:

- `stores` (id, name, address, latitude, longitude, chain)
- `products` (id, name, brand, category, upc, unit, quantity)
- `price_entries` (id, product_id, store_id, price, sale_price, on_sale, last_updated, currency)
