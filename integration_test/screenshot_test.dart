import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_grocery_price_compare/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  testWidgets('capture grocery price compare flow', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: GroceryPriceCompareApp(),
      ),
    );

    // Let the mock scraper API resolve (simulated 800ms delay).
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await shoot(tester, '01-nearby-stores');

    // ---- Compare tab ----
    await tester.tap(find.byIcon(Icons.compare_arrows_outlined));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Open the product dropdown and pick a product to show price comparison.
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    final menuItem = find.text('Whole Milk - Horizon Organic').last;
    if (menuItem.evaluate().isNotEmpty) {
      await tester.tap(menuItem);
    } else {
      // Fallback: tap first dropdown menu item.
      await tester.tap(find.byType(DropdownMenuItem<String>).first);
    }
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await shoot(tester, '02-price-comparison');

    // ---- Search tab ----
    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await shoot(tester, '03-browse-products');

    // Type a query to show fuzzy match results.
    await tester.enterText(find.byType(TextField), 'milk');
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await shoot(tester, '04-search-results');
  });
}
