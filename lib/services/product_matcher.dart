import 'package:string_similarity/string_similarity.dart';
import '../models/product.dart';

/// Product matching and normalization engine.
/// Matches products across different stores using multiple strategies:
/// 1. Exact UPC/barcode match (highest confidence)
/// 2. High name similarity with same brand
/// 3. Brand + category match with name similarity
/// 4. Fuzzy name-only match (lowest confidence)
class ProductMatcher {
  static const double _highSimilarityThreshold = 0.85;
  static const double _mediumSimilarityThreshold = 0.65;
  static const double _lowSimilarityThreshold = 0.45;

  /// Match a source product against a list of candidate products.
  /// Returns matches sorted by confidence (highest first).
  static List<MatchResult> findMatches({
    required Product source,
    required List<Product> candidates,
    double minConfidence = 0.4,
  }) {
    final results = <MatchResult>[];

    for (final candidate in candidates) {
      if (candidate.id == source.id) continue;

      final result = _computeMatch(source, candidate);
      if (result != null && result.confidence >= minConfidence) {
        results.add(result);
      }
    }

    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    return results;
  }

  /// Compute match between two products
  static MatchResult? _computeMatch(Product source, Product candidate) {
    // Strategy 1: Exact UPC match - highest confidence
    if (source.upc != null &&
        candidate.upc != null &&
        source.upc!.isNotEmpty &&
        candidate.upc!.isNotEmpty &&
        source.upc == candidate.upc) {
      return MatchResult(
        sourceProduct: source,
        matchedProduct: candidate,
        confidence: 1.0,
        matchType: MatchType.exactUpc,
      );
    }

    // Normalize names for comparison
    final sourceName = _normalizeName(source.name);
    final candidateName = _normalizeName(candidate.name);

    // Compute name similarity
    final nameSimilarity =
        StringSimilarity.compareTwoStrings(sourceName, candidateName);

    // Strategy 2: High name similarity
    if (nameSimilarity >= _highSimilarityThreshold) {
      final brandBoost = _brandMatch(source.brand, candidate.brand) ? 0.05 : 0;
      return MatchResult(
        sourceProduct: source,
        matchedProduct: candidate,
        confidence: (nameSimilarity + brandBoost).clamp(0.0, 1.0),
        matchType: MatchType.highNameSimilarity,
      );
    }

    // Strategy 3: Same brand + same category + moderate name similarity
    if (_brandMatch(source.brand, candidate.brand) &&
        source.category == candidate.category &&
        nameSimilarity >= _lowSimilarityThreshold) {
      final confidence = 0.3 + (nameSimilarity * 0.5) + 0.1; // brand + category bonus
      return MatchResult(
        sourceProduct: source,
        matchedProduct: candidate,
        confidence: confidence.clamp(0.0, 1.0),
        matchType: MatchType.brandAndCategory,
      );
    }

    // Strategy 4: Fuzzy match - name similarity above threshold
    if (nameSimilarity >= _mediumSimilarityThreshold) {
      return MatchResult(
        sourceProduct: source,
        matchedProduct: candidate,
        confidence: nameSimilarity * 0.8,
        matchType: MatchType.fuzzyMatch,
      );
    }

    return null;
  }

  /// Normalize product name for better matching
  static String _normalizeName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Check if brands match (case-insensitive, handles abbreviations)
  static bool _brandMatch(String brand1, String brand2) {
    final b1 = brand1.toLowerCase().trim();
    final b2 = brand2.toLowerCase().trim();
    if (b1 == b2) return true;
    if (b1.contains(b2) || b2.contains(b1)) return true;
    return StringSimilarity.compareTwoStrings(b1, b2) > 0.8;
  }

  /// Search products by query with fuzzy matching.
  /// Returns products sorted by relevance.
  static List<ProductSearchResult> searchProducts({
    required String query,
    required List<Product> products,
    double minScore = 0.3,
  }) {
    if (query.trim().isEmpty) return [];

    final normalizedQuery = _normalizeName(query);
    final results = <ProductSearchResult>[];

    for (final product in products) {
      final nameScore = StringSimilarity.compareTwoStrings(
        normalizedQuery,
        _normalizeName(product.name),
      );
      final brandScore = StringSimilarity.compareTwoStrings(
        normalizedQuery,
        _normalizeName(product.brand),
      );
      final categoryScore = StringSimilarity.compareTwoStrings(
        normalizedQuery,
        _normalizeName(product.category),
      );

      // Weighted score: name matters most, then brand, then category
      final score = (nameScore * 0.6) + (brandScore * 0.25) + (categoryScore * 0.15);

      // Boost if query is contained in the name
      final containsBoost =
          product.name.toLowerCase().contains(query.toLowerCase()) ? 0.3 : 0;

      final finalScore = (score + containsBoost).clamp(0.0, 1.0);

      if (finalScore >= minScore) {
        results.add(ProductSearchResult(
          product: product,
          relevanceScore: finalScore,
        ));
      }
    }

    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return results;
  }

  /// Get confidence label for a match score
  static String confidenceLabel(double confidence) {
    if (confidence >= 0.95) return 'Exact Match';
    if (confidence >= 0.85) return 'Very High';
    if (confidence >= 0.70) return 'High';
    if (confidence >= 0.55) return 'Medium';
    if (confidence >= 0.40) return 'Low';
    return 'Very Low';
  }
}

class ProductSearchResult {
  final Product product;
  final double relevanceScore;

  const ProductSearchResult({
    required this.product,
    required this.relevanceScore,
  });
}
