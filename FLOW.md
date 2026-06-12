# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro Max"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (if missing) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_grocery_price_compare
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro Max"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - pumps the full `GroceryPriceCompareApp` (Riverpod + GoRouter). The mock `ScraperApi` resolves seeded grocery data (stores, products, prices) so every screen renders real-looking content. The test then:
  1. Lets the simulated scraper API resolve and captures the Stores tab (`01-nearby-stores`) showing nearby stores sorted by distance.
  2. Taps the Compare tab, opens the product dropdown, picks Whole Milk, and captures the price comparison across stores with lowest/average/highest/savings (`02-price-comparison`).
  3. Taps the Search tab and captures the category-grouped product browse view (`03-browse-products`).
  4. Types "milk" into the search field and captures the fuzzy-match results with relevance scores (`04-search-results`).
- Each capture calls `binding.convertFlutterSurfaceToImage()` + `binding.takeScreenshot('NN-name')`.
- Location uses the geolocator provider, which falls back to a default San Francisco position on the simulator (no hardware needed).
