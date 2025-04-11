import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:combo_dream11/src/data/model/enums/player_info_enum.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/screens/match_results_screen.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/screens/utils/utils.dart'; // For formatDate, calculateRootNumber etc.
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/search_filter_provider.dart';
import 'package:combo_dream11/src/test_screen/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CricketFilterScreen extends HookConsumerWidget {
  const CricketFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State management
    final initialFilters = ref.watch(appliedFiltersProvider);
    final selectedDate = useState<DateTime?>(
      initialFilters['selectedDate'] as DateTime?,
    );
    final selectedRoles = useState<Set<PlayerRole>>(
      (initialFilters['roles'] as List?)?.whereType<PlayerRole>().toSet() ?? {},
    );
    final selectedIplTeam = useState<Set<PlayerIplTeam>>(
      (initialFilters['playerIplTeam'] as List<String>?)
              ?.map(
                (name) => PlayerIplTeam.values.firstWhere(
                  (e) => e.name == name,
                  orElse: () => PlayerIplTeam.values.first,
                ),
              )
              .toSet() ??
          {},
    );
    final selectedSortOption = useState<SortOption?>(
      initialFilters['sortBy'] as SortOption?,
    );

    // --- Callbacks ---
    Future<void> selectDateCallback() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? DateTime.now(),
        firstDate: DateTime(2000), // Adjust range as needed
        lastDate: DateTime(2101),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        helpText: 'Select Match Date', // Customize help text
        builder: (context, child) {
          // Optional: Theme the Date Picker
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary:
                    Theme.of(context).colorScheme.primary, // Header background
                onPrimary:
                    Theme.of(context).colorScheme.onPrimary, // Header text
                onSurface: Theme.of(context).colorScheme.onSurface, // Body text
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.primary, // Button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
      }
    }

    void resetFiltersCallback() {
      selectedDate.value = null;
      selectedRoles.value = {};
      selectedIplTeam.value = {};
      selectedSortOption.value = null;
      ref.read(appliedFiltersProvider.notifier).state =
          {}; // Clear provider state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Filters Reset"),
          duration: Duration(seconds: 1),
        ),
      );
    }

    void applyFiltersCallback() {
      final selectedTeamNames =
          selectedIplTeam.value.map((team) => team.name).toList();

      final filters = {
        'selectedDate': selectedDate.value,
        'roles': selectedRoles.value.toList(),
        'playerIplTeam': selectedTeamNames, // List of strings
        'rootNumber': calculateRootNumber(selectedDate.value),
        'destinyNumber': calculateDestinyNumber(selectedDate.value),
        'sortBy': selectedSortOption.value,
      };
      ref.read(appliedFiltersProvider.notifier).state = filters;

      print("Applied Filters (Provider Updated): $filters"); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Filters Applied!"),
          duration: Duration(seconds: 1),
        ),
      );

      // Navigate to results screen
      NavigationPaths.navigateToScreen(
        context: context,
        page: const MatchResultsScreen(),
        // Consider replacing the current route if you don't want users
        // to navigate back to the filter screen easily after applying.
        // replace: true,
      );
    }

    // --- UI Build ---
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Filters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Filters',
            onPressed: resetFiltersCallback,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Date Selection Section --- <<< THIS WAS MISSING
          _buildFilterSectionTitle(context, 'Match Date'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              selectedDate.value == null
                  ? 'Select Date'
                  : 'Date: ${formatDate(selectedDate.value)}', // Use formatDate util
            ),
            onPressed: selectDateCallback, // Call the date picker callback
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              textStyle: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // Display calculated numbers if a date is selected
          if (selectedDate.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Date Numbers -> Root: ${calculateRootNumber(selectedDate.value)} / Destiny: ${calculateDestinyNumber(selectedDate.value)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          const Divider(height: 30, thickness: 1),
          // --- End Date Selection Section ---

          // --- IPL Team Filter Section ---
          _buildFilterSectionTitle(context, 'Player IPL Team'),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children:
                PlayerIplTeam.values.map((team) {
                  final isSelected = selectedIplTeam.value.contains(team);
                  return FilterChip(
                    label: Text(
                      team.name.toUpperCase(),
                    ), // Consider better display names if needed
                    selected: isSelected,
                    onSelected: (selected) {
                      final currentTeams = selectedIplTeam.value;
                      if (selected) {
                        selectedIplTeam.value = {...currentTeams, team};
                      } else {
                        selectedIplTeam.value =
                            currentTeams.where((t) => t != team).toSet();
                      }
                    },
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    showCheckmark: true, // Explicitly show checkmark
                  );
                }).toList(),
          ),
          const Divider(height: 30, thickness: 1),

          // --- Player Role Filter Section ---
          _buildFilterSectionTitle(context, 'Player Role'),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children:
                PlayerRole.values.map((role) {
                  final isSelected = selectedRoles.value.contains(role);
                  return FilterChip(
                    label: Text(
                      role.name[0].toUpperCase() + role.name.substring(1),
                    ), // Capitalize
                    selected: isSelected,
                    onSelected: (selected) {
                      final currentRoles = selectedRoles.value;
                      if (selected) {
                        selectedRoles.value = {...currentRoles, role};
                      } else {
                        selectedRoles.value =
                            currentRoles.where((r) => r != role).toSet();
                      }
                    },
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    showCheckmark: true,
                  );
                }).toList(),
          ),
          const Divider(height: 30, thickness: 1),

          // --- Sorting Section ---
          _buildFilterSectionTitle(context, 'Sort Results By'),
          DropdownButtonFormField<SortOption>(
            value: selectedSortOption.value,
            hint: const Text('Select Sorting (Optional)'),
            isExpanded: true, // Make dropdown take full width
            items:
                SortOption.values
                    .map(
                      (option) => DropdownMenuItem<SortOption>(
                        value: option,
                        child: Text(
                          getSortOptionDisplayName(option),
                        ), // Use helper for display name
                      ),
                    )
                    .toList(),
            onChanged: (SortOption? newValue) {
              selectedSortOption.value = newValue;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 14.0,
              ),
              prefixIcon: const Icon(Icons.sort),
              filled: true, // Add a background fill
              fillColor: Theme.of(
                context,
              ).colorScheme.surface.withOpacity(0.05),
            ),
          ),
          const SizedBox(height: 40),

          // --- Action Buttons ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                onPressed: resetFiltersCallback,
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      Theme.of(
                        context,
                      ).colorScheme.error, // Use error color for reset?
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Apply Filters'),
                onPressed: applyFiltersCallback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Padding at the bottom
        ],
      ),
    );
  }

  // Helper for section titles
  Widget _buildFilterSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Helper function to get display name for SortOption
  String getSortOptionDisplayName(SortOption option) {
    switch (option) {
      case SortOption.highestScore:
        return 'Highest Score';
      case SortOption.lowestScore:
        return 'Lowest Score';
      case SortOption.mostWickets:
        return 'Most Wickets';
      case SortOption.bestEconomy:
        return 'Best Economy (Lower)';
      case SortOption.bestBattingSR:
        return 'Best Batting SR (Higher)';
      case SortOption.bestBowlingSR:
        return 'Best Bowling SR (Lower)';
      default:
        return option.name;
    }
  }
}
