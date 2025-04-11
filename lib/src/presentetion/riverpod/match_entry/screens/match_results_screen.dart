import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:combo_dream11/src/data/model/match_entry.dart'; // Ensure PlayerIplTeam, PlayerRole etc. are available
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/screens/cricket_filter_screen.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/screens/utils/utils.dart'; // For formatDate, calculateRootNumber etc.
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/search_filter_provider.dart'; // For providers
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MatchResultsScreen extends ConsumerWidget {
  const MatchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = 12; // Define font size for subtitles
    final List<MatchEntry> filteredMatches = ref.watch(
      filteredMatchEntriesProvider,
    );
    final Map<String, dynamic> filters = ref.watch(appliedFiltersProvider);

    print(
      "Building results screen with ${filteredMatches.length} matches.",
    ); // Debug

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Open Filters',
            onPressed: () {
              // Navigate to the filter screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CricketFilterScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align filter display left
        children: [
          // --- Display Applied Filters ---
          _buildAppliedFiltersDisplay(context, filters), // Helper widget call
          // --- Display Results List ---
          Expanded(
            // Make the ListView take the remaining space
            child:
                filteredMatches.isEmpty
                    ? const Center(
                      // Show message if list is empty
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No matches found matching the current filter criteria. Try adjusting the filters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                    : ListView.builder(
                      // Build the list if not empty
                      itemCount: filteredMatches.length,
                      itemBuilder: (context, index) {
                        final entry = filteredMatches[index];
                        // Create a Card for each entry
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          elevation: 2, // Add slight shadow
                          child: ListTile(
                            // Leading avatar - show role initial
                            leading: CircleAvatar(
                              child: Text(
                                entry.playerRole.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Optional: Add background color based on role?
                              // backgroundColor: _getRoleColor(entry.playerRole),
                            ),
                            // Title - Player name
                            title: Text(
                              entry.playerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Subtitle - Detailed stats
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4), // Spacing
                                // Team, Role, DOB
                                Text(
                                  'Team: ${entry.playerIplTeam.toUpperCase()} | Role: ${entry.playerRole.name} | DOB: ${formatDate(entry.playerDateOfBirth)}',
                                  style: TextStyle(fontSize: fontSize),
                                ),
                                // Match Date, Stadium
                                Text(
                                  'Match: ${formatDate(entry.matchDate)} (${entry.stadium})',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Batting stats (if available)
                                if (entry.runs != null)
                                  Text(
                                    'Bat: ${entry.runs} (${entry.ballsFaced ?? '-'}b) SR: ${entry.battingStrikeRate?.toStringAsFixed(1) ?? '-'}',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                // Bowling stats (if available)
                                if (entry.wickets != null)
                                  Text(
                                    'Bowl: ${entry.wickets}/${entry.runsConceded ?? '-'} (${((entry.ballsBowled ?? 0) / 6.0).toStringAsFixed(1)}ov) Econ: ${entry.bowlingEconomy?.toStringAsFixed(2) ?? '-'} SR: ${entry.bowlingStrikeRate?.toStringAsFixed(1) ?? '-'}',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                // Fielding stats (if available)
                                if (entry.catches != null ||
                                    entry.stumpings != null)
                                  Text(
                                    'Field: ${entry.catches ?? 0}c / ${entry.stumpings ?? 0}st',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                // Numerology
                                Text(
                                  "Match Root: ${calculateRootNumber(entry.matchDate)} | Destiny: ${calculateDestinyNumber(entry.matchDate)}",
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                const SizedBox(height: 4), // Spacing at bottom
                              ],
                            ),
                            isThreeLine:
                                true, // Allows more space for the subtitle
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget to Build Filter Display ---
  Widget _buildAppliedFiltersDisplay(
    BuildContext context,
    Map<String, dynamic> filters,
  ) {
    final List<Widget> filterChips = [];
    final theme = Theme.of(context);
    final chipLabelStyle =
        theme.textTheme.labelSmall; // Use smaller label for chips
    const chipPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 0);
    const chipVisualDensity = VisualDensity(
      horizontal: -2,
      vertical: -2,
    ); // Compact chips

    // Check Date Filter
    final DateTime? selectedDate = filters['selectedDate'] as DateTime?;
    if (selectedDate != null) {
      final rootNum = calculateRootNumber(selectedDate);
      final destinyNum = calculateDestinyNumber(selectedDate);
      filterChips.add(
        Chip(
          avatar: Icon(
            Icons.calendar_today,
            size: 14,
            color: theme.colorScheme.secondary,
          ), // Smaller icon
          label: Text(
            'Date: ${formatDate(selectedDate)} (R:$rootNum/D:$destinyNum)',
            style: chipLabelStyle,
          ),
          backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(
            0.5,
          ),
          labelPadding: chipPadding,
          visualDensity: chipVisualDensity,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    // Check Roles Filter
    // Assuming 'roles' filter stores List<PlayerRole>
    final List<PlayerRole> selectedRoles =
        (filters['roles'] as List?)?.cast<PlayerRole>() ?? [];
    if (selectedRoles.isNotEmpty) {
      filterChips.add(
        Chip(
          avatar: Icon(
            Icons.person_outline,
            size: 14,
            color: theme.colorScheme.tertiary,
          ), // Smaller icon
          label: Text(
            'Roles: ${selectedRoles.map((r) => r.name).join(', ')}',
            style: chipLabelStyle,
          ),
          backgroundColor: theme.colorScheme.tertiaryContainer.withOpacity(0.5),
          labelPadding: chipPadding,
          visualDensity: chipVisualDensity,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    // Check IPL Team Filter (Reads Strings)
    // Assuming 'playerIplTeam' filter stores List<String>
    final List<String> selectedTeamNames =
        (filters['playerIplTeam'] as List?)?.cast<String>() ?? [];
    if (selectedTeamNames.isNotEmpty) {
      filterChips.add(
        Chip(
          avatar: Icon(
            Icons.shield_outlined,
            size: 14,
            color: theme.colorScheme.primary,
          ), // Smaller icon
          label: Text(
            'Teams: ${selectedTeamNames.map((name) => name.toUpperCase()).join(', ')}',
            style: chipLabelStyle,
          ),
          backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
          labelPadding: chipPadding,
          visualDensity: chipVisualDensity,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    // Check Sort Filter
    // Assuming 'sortBy' filter stores SortOption?
    final SortOption? sortBy = filters['sortBy'] as SortOption?;
    if (sortBy != null) {
      filterChips.add(
        Chip(
          avatar: Icon(
            Icons.sort,
            size: 14,
            color: theme.colorScheme.surfaceTint,
          ), // Smaller icon
          label: Text(
            'Sort: ${getSortOptionDisplayName(sortBy)}', // Use helper for display name
            style: chipLabelStyle,
          ),
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          labelPadding: chipPadding,
          visualDensity: chipVisualDensity,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    // If no filters are active, show a message
    if (filterChips.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          'Showing all entries. Apply filters using the ${Icons.filter_list.codePoint} icon above.',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Display active filters using Wrap inside a Container with some styling
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      width: double.infinity, // Take full width
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.1), // Subtle background
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
      ),
      child: Wrap(
        spacing: 6.0, // Horizontal gap between chips
        runSpacing: 4.0, // Vertical gap if chips wrap
        children: filterChips,
      ),
    );
  }

  // Helper function to get display name for SortOption (if not already available)
  // Add this function inside the class or make it top-level/import from utils
  String getSortOptionDisplayName(SortOption option) {
    switch (option) {
      case SortOption.highestScore:
        return 'Highest Score';
      case SortOption.lowestScore:
        return 'Lowest Score';
      case SortOption.mostWickets:
        return 'Most Wickets';
      case SortOption.bestEconomy:
        return 'Best Economy';
      case SortOption.bestBattingSR:
        return 'Best Batting SR';
      case SortOption.bestBowlingSR:
        return 'Best Bowling SR';
      default:
        return option.name; // Fallback
    }
  }

  // Optional: Helper to get color based on role
  // Color _getRoleColor(PlayerRole role) {
  //   switch (role) {
  //     case PlayerRole.batsman: return Colors.blue[100]!;
  //     case PlayerRole.bowler: return Colors.red[100]!;
  //     case PlayerRole.allrounder: return Colors.purple[100]!;
  //     case PlayerRole.wicketKeeper: return Colors.green[100]!;
  //     default: return Colors.grey[300]!;
  //   }
  // }
}
