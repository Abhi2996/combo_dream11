import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:combo_dream11/src/data/model/match_entry.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/match_entry_notifier.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/screens/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//============================================================
// 1. Data Models & Enums
// (Often in src/data/models/ or similar)
//============================================================

// // ============================================================
// // 2. Mock Data
// // (Often in src/data/mock/ or similar)
// // ============================================================
// // Other filer

//============================================================
// 3. Helper Functions
// (Can be top-level or in a utils file)
//============================================================

//============================================================
// 4. Riverpod Providers
// (Often in application/providers or feature-specific provider files)
//============================================================
//============================================================
// 4. Riverpod Providers
//============================================================

// Provider for the base list of match entries (replace mock with real source)
final matchEntryProvider = Provider<List<MatchEntry>>((ref) {
  // In a real app, load from a repository/database
  final mockMatchEntriess = ref.watch(matchEntryNotifierProvider);
  return mockMatchEntriess;
});

// Provider holding the map of currently applied filters
final appliedFiltersProvider = StateProvider<Map<String, dynamic>>((ref) => {});

//============================================================
// 1. Data Models & Enums
//============================================================
// Assume PlayerRole and SortOption are defined here or imported
// Assume PlayerIplTeam enum is defined here or imported from match_entry.dart

//============================================================
// 4. Riverpod Providers
//============================================================

// --- Constants for Filter Keys ---
class FilterKeys {
  static const String selectedDate = 'selectedDate';
  static const String roles = 'roles';
  static const String playerIplTeam = 'playerIplTeam';
  static const String sortBy = 'sortBy';
}

// --- The Refactored Provider ---
final filteredMatchEntriesProvider = Provider<List<MatchEntry>>((ref) {
  // --- 1. Watch Dependencies ---
  // final List<MatchEntry> allEntries = ref.watch(matchEntryNotifierProvider); // If using StateNotifier
  final List<MatchEntry> allEntries = ref.watch(
    matchEntryProvider,
  ); // If using a simple Provider<List<MatchEntry>>
  final Map<String, dynamic> filters = ref.watch(appliedFiltersProvider);

  if (kDebugMode) {
    print("--- Filtering Start ---");
    print("Initial entry count: ${allEntries.length}");
    print("Applied filters map: $filters");
  }

  // --- 2. Retrieve Filter Values Safely ---
  final DateTime? selectedDate = filters[FilterKeys.selectedDate] as DateTime?;
  final List<PlayerRole> selectedRoles =
      (filters[FilterKeys.roles] as List?)?.cast<PlayerRole>() ?? [];
  final List<String> selectedTeamNames =
      (filters[FilterKeys.playerIplTeam] as List?)?.cast<String>() ?? [];
  final SortOption? sortBy = filters[FilterKeys.sortBy] as SortOption?;

  // --- 3. Apply Filters Sequentially ---
  // Start with a copy of all entries
  List<MatchEntry> filteredEntries = List.from(allEntries);

  // Apply each filter step using dedicated functions
  filteredEntries = _applyDateNumerologyFilter(filteredEntries, selectedDate);
  filteredEntries = _applyRoleFilter(filteredEntries, selectedRoles);
  filteredEntries = _applyIplTeamFilter(filteredEntries, selectedTeamNames);
  // Add calls to other filter functions here if needed

  // --- 4. Apply Sorting ---
  filteredEntries = _applySorting(filteredEntries, sortBy);

  // --- 5. Return Result ---
  if (kDebugMode) {
    print("--- Filtering End --- Returning ${filteredEntries.length} entries.");
  }
  return filteredEntries;
});

// --- Helper Functions (Single Responsibility) ---

// --- Filtering Logic ---

List<MatchEntry> _applyDateNumerologyFilter(
  List<MatchEntry> entries,
  DateTime? selectedDate,
) {
  if (selectedDate == null) {
    if (kDebugMode)
      print("[Filter Step] No Date selected, skipping Date Numerology filter.");
    return entries; // No filter applied
  }

  final int? targetRootNum = calculateRootNumber(selectedDate);
  final int? targetDestinyNum = calculateDestinyNumber(selectedDate);

  if (targetRootNum == null && targetDestinyNum == null) {
    if (kDebugMode) {
      print(
        "[Filter Step] Warning: Could not calculate target numerology for date: ${formatDate(selectedDate)}, skipping filter.",
      );
    }
    return entries; // Cannot filter if target numbers are invalid
  }

  if (kDebugMode) {
    print(
      "[Filter Step] Applying Date Numerology. Target Root: $targetRootNum, Target Destiny: $targetDestinyNum (from date: ${formatDate(selectedDate)})",
    );
  }

  final filtered =
      entries.where((entry) {
        final int? entryRootNum = calculateRootNumber(entry.matchDate);
        final int? entryDestinyNum = calculateDestinyNumber(entry.matchDate);

        // Match if *either* root or destiny number matches the target (if target exists)
        bool rootMatches =
            (targetRootNum != null && entryRootNum == targetRootNum);
        bool destinyMatches =
            (targetDestinyNum != null && entryDestinyNum == targetDestinyNum);

        return rootMatches || destinyMatches;
      }).toList();

  if (kDebugMode)
    print("After Date Numerology Filter count: ${filtered.length}");
  return filtered;
}

List<MatchEntry> _applyRoleFilter(
  List<MatchEntry> entries,
  List<PlayerRole> selectedRoles,
) {
  if (selectedRoles.isEmpty) {
    if (kDebugMode)
      print("[Filter Step] No Roles selected, skipping Role filter.");
    return entries; // No filter applied
  }

  if (kDebugMode) {
    print(
      "[Filter Step] Applying Player Role Filter: ${selectedRoles.map((r) => r.name).join(', ')}", // Use displayName
    );
  }

  final filtered =
      entries
          .where((entry) => selectedRoles.contains(entry.playerRole))
          .toList();

  if (kDebugMode) print("After Player Role Filter count: ${filtered.length}");
  return filtered;
}

List<MatchEntry> _applyIplTeamFilter(
  List<MatchEntry> entries,
  List<String> selectedTeamNames,
) {
  if (selectedTeamNames.isEmpty) {
    if (kDebugMode) {
      print("[Filter Step] No IPL Teams selected, skipping IPL Team filter.");
    }
    return entries; // No filter applied
  }

  // --- Normalization Step ---
  // Normalize the list of selected team names ONCE and store in a Set for efficient lookup.
  final Set<String> normalizedSelectedTeams =
      selectedTeamNames
          .map(_normalizeTeamName) // Apply normalization to each selected name
          .where(
            (normalized) => normalized.isNotEmpty,
          ) // Avoid matching empty strings if normalization results in one unexpectedly
          .toSet(); // Store in a Set

  if (normalizedSelectedTeams.isEmpty) {
    if (kDebugMode) {
      print(
        "[Filter Step] Selected IPL Teams resulted in empty normalized set, skipping filter.",
      );
    }
    return entries; // If all selected names somehow became empty after normalization
  }

  if (kDebugMode) {
    print(
      "[Filter Step] Applying Player IPL Team Filter using normalized names: ${normalizedSelectedTeams.join(', ')}",
    );
    // You might want to log the original names too for clarity:
    // print("[Filter Step] Original selected names: ${selectedTeamNames.join(', ')}");
  }

  final filtered =
      entries.where((entry) {
        // 1. Normalize the team name from the current entry
        final String normalizedEntryTeam = _normalizeTeamName(
          entry.playerIplTeam,
        );

        // 2. Check if the normalized entry team name exists in the set of normalized selected teams
        //    Ensure the normalized entry team isn't empty before checking.
        return normalizedEntryTeam.isNotEmpty &&
            normalizedSelectedTeams.contains(normalizedEntryTeam);
      }).toList();

  if (kDebugMode) {
    print("After Player IPL Team Filter count: ${filtered.length}");
  }
  return filtered;
}

/// Normalizes a team name for comparison by converting to lowercase
/// and removing all whitespace characters.
/// Returns an empty string if the input is null.
String _normalizeTeamName(String? teamName) {
  if (teamName == null) {
    return '';
  }
  // Use RegExp r'\s+' to match one or more whitespace characters
  return teamName.toLowerCase().replaceAll(RegExp(r'\s+'), '');
}

// --- Sorting Logic ---

List<MatchEntry> _applySorting(List<MatchEntry> entries, SortOption? sortBy) {
  if (sortBy == null) {
    if (kDebugMode)
      print(
        "[Sort Step] No Sort selected, using default order (or previous filter order).",
      );
    // Optionally apply a default sort here if desired, e.g., by date or name
    // entries.sort((a, b) => a.matchDate.compareTo(b.matchDate));
    return entries; // No sort applied
  }

  if (kDebugMode) print("[Sort Step] Applying Sort: ${sortBy.name}");

  // Create a mutable copy to sort in place
  final sortedEntries = List<MatchEntry>.from(entries);

  sortedEntries.sort((a, b) {
    int comparison = 0;
    // --- Primary Sort Criteria ---
    switch (sortBy) {
      case SortOption.highestScore:
        // Handle nulls: place them last (or first, depending on preference)
        comparison = (b.runs ?? -1).compareTo(a.runs ?? -1);
        break;
      case SortOption.lowestScore:
        comparison = _compareNullableInts(a.runs, b.runs);
        break;
      case SortOption.mostWickets:
        comparison = (b.wickets ?? -1).compareTo(a.wickets ?? -1);
        break;
      case SortOption.bestEconomy:
        comparison = _compareNullableDoubles(
          a.bowlingEconomy,
          b.bowlingEconomy,
        );
        break;
      case SortOption.bestBattingSR:
        comparison = _compareNullableDoubles(
          b.battingStrikeRate,
          a.battingStrikeRate,
          descending: true,
        );
        break;
      case SortOption.bestBowlingSR:
        comparison = _compareNullableDoubles(
          a.bowlingStrikeRate,
          b.bowlingStrikeRate,
        );
        break;
    }

    // --- Secondary Sort Criteria (if primary is equal) ---
    if (comparison == 0) {
      // Sort by player name alphabetically as a tie-breaker
      comparison = a.playerName.compareTo(b.playerName);
    }
    // Add more tie-breakers if needed (e.g., match date)
    // if (comparison == 0) {
    //   comparison = a.matchDate.compareTo(b.matchDate);
    // }

    return comparison;
  });

  if (kDebugMode) print("After Sorting count: ${sortedEntries.length}");
  return sortedEntries;
}

// --- Comparison Helpers for Nullable Numerics (for Sorting) ---

// Compares two nullable integers (ascending by default)
// Nulls are treated as "lowest"
int _compareNullableInts(int? a, int? b) {
  if (a == null && b == null) return 0;
  if (a == null) return -1; // a is less than b
  if (b == null) return 1; // a is greater than b
  return a.compareTo(b);
}

// Compares two nullable doubles (ascending by default)
// Nulls are treated as "lowest" unless descending is true
int _compareNullableDoubles(double? a, double? b, {bool descending = false}) {
  if (a == null && b == null) return 0;

  if (descending) {
    // For descending, nulls are lowest
    if (a == null) return 1; // a is less than b (comes later in descending)
    if (b == null)
      return -1; // a is greater than b (comes earlier in descending)
    return b.compareTo(a); // Reverse comparison for descending
  } else {
    // For ascending, nulls are lowest
    if (a == null) return -1; // a is less than b
    if (b == null) return 1; // a is greater than b
    return a.compareTo(b);
  }
}

// --- Make sure your utility functions are available ---
// Ensure these functions exist and handle potential errors gracefully
// int? calculateRootNumber(DateTime date) { ... }
// int? calculateDestinyNumber(DateTime date) { ... }
// String formatDate(DateTime date) { ... }
