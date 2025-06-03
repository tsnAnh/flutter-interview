import 'package:diacritic/diacritic.dart';
import '../models/users_response.dart';

/// Comprehensive local search utility for handling edge cases with special characters,
/// spaces, Unicode, and various search patterns.
class LocalSearchUtils {
  /// Searches through a list of users based on a query string.
  /// Handles edge cases including:
  /// - Special characters (@, ., -, _, etc.)
  /// - Multiple consecutive spaces
  /// - Unicode characters and accents
  /// - Case insensitivity
  /// - Partial matching across multiple fields
  static List<UserData> searchUsers(List<UserData> users, String query) {
    if (users.isEmpty) return [];

    final normalizedQuery = _normalizeSearchQuery(query);
    if (normalizedQuery.isEmpty) return users;

    // Split query into individual terms for multi-term search
    final queryTerms = _extractSearchTerms(normalizedQuery);
    if (queryTerms.isEmpty) return users;

    final results = <UserData>[];

    for (final user in users) {
      if (_matchesSearchTerms(user, queryTerms)) {
        results.add(user);
      }
    }

    return results;
  }

  /// Normalizes a search query by:
  /// - Trimming whitespace
  /// - Converting to lowercase
  /// - Removing diacritics/accents
  /// - Collapsing multiple spaces
  static String _normalizeSearchQuery(String query) {
    if (query.isEmpty) return '';

    // Remove leading/trailing whitespace
    String normalized = query.trim();

    // Return empty if only whitespace
    if (normalized.isEmpty) return '';

    // Convert to lowercase for case-insensitive search
    normalized = normalized.toLowerCase();

    // Remove diacritics (accents) for better matching
    // e.g., "José" matches "jose"
    normalized = removeDiacritics(normalized);

    // Collapse multiple consecutive spaces into single space
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    return normalized;
  }

  /// Extracts search terms from a normalized query.
  /// Handles edge cases like quoted strings and special characters.
  static List<String> _extractSearchTerms(String normalizedQuery) {
    if (normalizedQuery.isEmpty) return [];

    // Handle quoted strings (exact phrases)
    final terms = <String>[];
    final quotedPattern = RegExp(r'"([^"]*)"');
    String remainingQuery = normalizedQuery;

    // Extract quoted phrases first
    quotedPattern.allMatches(normalizedQuery).forEach((match) {
      final phrase = match.group(1);
      if (phrase != null && phrase.trim().isNotEmpty) {
        terms.add(phrase.trim());
        remainingQuery = remainingQuery.replaceFirst(match.group(0)!, '');
      }
    });

    // Extract remaining individual terms
    remainingQuery
        .split(' ')
        .where((term) => term.isNotEmpty)
        .forEach(terms.add);

    return terms;
  }

  /// Checks if a user matches all search terms.
  /// Uses multi-field matching across:
  /// - First name
  /// - Last name
  /// - Email
  /// - Full name (firstName + lastName)
  /// - User ID (as string)
  static bool _matchesSearchTerms(UserData user, List<String> terms) {
    if (terms.isEmpty) return true;

    // Get all searchable text for this user
    final searchableFields = _getSearchableUserText(user);

    // All terms must match at least one field
    return terms.every(
      (term) => searchableFields.any((field) => field.contains(term)),
    );
  }

  /// Extracts and normalizes all searchable text from a user.
  static List<String> _getSearchableUserText(UserData user) {
    final fields = <String>[];

    // Normalize each field
    fields.add(_normalizeText(user.firstName));
    fields.add(_normalizeText(user.lastName));
    fields.add(_normalizeText(user.email));
    fields.add(_normalizeText(user.id.toString()));

    // Add combined full name
    final fullName = '${user.firstName} ${user.lastName}';
    fields.add(_normalizeText(fullName));

    // Add email username (part before @)
    final emailParts = user.email.split('@');
    if (emailParts.isNotEmpty) {
      fields.add(_normalizeText(emailParts.first));
    }

    // Add email domain (part after @)
    if (emailParts.length > 1) {
      fields.add(_normalizeText(emailParts[1]));
    }

    // Filter out empty fields
    return fields.where((field) => field.isNotEmpty).toList();
  }

  /// Normalizes individual text fields for consistent matching.
  static String _normalizeText(String text) {
    if (text.isEmpty) return '';

    String normalized = text.toLowerCase();
    normalized = removeDiacritics(normalized);

    // Preserve special characters but normalize spaces
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();

    return normalized;
  }

  /// Validates if a search query contains only valid characters.
  /// Returns true if query is valid, false if it should be rejected.
  static bool isValidSearchQuery(String query) {
    if (query.isEmpty) return true;

    // Allow reasonable query length (prevent extremely long queries)
    if (query.length > 100) return false;

    // Check for potentially malicious patterns
    final maliciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'data:text/html', caseSensitive: false),
    ];

    return !maliciousPatterns.any((pattern) => pattern.hasMatch(query));
  }

  /// Highlights search terms in text (for potential UI enhancement).
  /// Returns the original text with highlight markers.
  static String highlightSearchTerms(String text, List<String> terms) {
    if (terms.isEmpty || text.isEmpty) return text;

    String result = text;
    for (final term in terms) {
      if (term.isNotEmpty) {
        // Simple highlighting - can be enhanced for UI
        final pattern = RegExp(RegExp.escape(term), caseSensitive: false);
        result = result.replaceAllMapped(
          pattern,
          (match) => '**${match.group(0)}**',
        );
      }
    }

    return result;
  }
}
