import 'package:combo_dream11/src/data/model/career_stats.dart';
import 'package:combo_dream11/src/data/model/player_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// We still need a way to distinguish between Batting and Bowling TABS in the UI,
// even if the data model combines them. Let's reuse the StatType enum *locally* for the UI.
enum _TabStatType { batting, bowling }

class PlayerDetailScreen extends StatefulWidget {
  final PlayerInfo player;

  const PlayerDetailScreen({super.key, required this.player});

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- Use the correct MatchType enum from your model ---
  final List<MatchType> _displayFormats = [
    MatchType.TEST,
    MatchType.ODI,
    MatchType.T20I, // Use T20I as defined in your enum
    MatchType.IPL,
  ];

  // --- Updated Helper: Find the SINGLE CareerStats object for a MatchType ---
  CareerStats? _findStatsForFormat(MatchType format) {
    try {
      if (widget.player.cricketStats == null) return null;
      // Find the stats object matching the specified format (MatchType)
      return widget.player.cricketStats!.firstWhere(
        (stats) => stats.matchType == format,
      );
    } catch (e) {
      // Not found for this format
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // Keep 5 tabs
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lightGreen = Colors.green.shade100;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.name),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.green.shade200,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Batting'),
            Tab(text: 'Bowling'),
            Tab(text: 'Career'), // Placeholder
            Tab(text: 'News'), // Placeholder
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(context, lightGreen),
          // Pass the local enum to indicate which type of stats the tab should display
          _buildStatsTab(context, _TabStatType.batting, lightGreen),
          _buildStatsTab(context, _TabStatType.bowling, lightGreen),
          const Center(child: Text('Career Info (Coming Soon)')),
          const Center(child: Text('News Feed (Coming Soon)')),
        ],
      ),
    );
  }

  // --- Builds the Info Tab (Largely unchanged, ensure field names match PlayerInfo) ---
  Widget _buildInfoTab(BuildContext context, Color headerBgColor) {
    // (Code for _buildInfoTab remains the same as the previous full example,
    // ensure widget.player.xyz fields match your PlayerInfo model exactly)
    String birthDateString = 'N/A';
    if (widget.player.birthDate != null) {
      final DateFormat formatter = DateFormat('MMMM d, yyyy');
      birthDateString = formatter.format(widget.player.birthDate!);
      // Calculate Age
      try {
        final now = DateTime.now();
        int age = now.year - widget.player.birthDate!.year;
        if (now.month < widget.player.birthDate!.month ||
            (now.month == widget.player.birthDate!.month &&
                now.day < widget.player.birthDate!.day)) {
          age--;
        }
        if (age >= 0) {
          // Basic sanity check for age
          birthDateString += ' ($age years)';
        }
      } catch (e) {
        print("Error calculating age: $e");
      }
    }

    return ListView(
      children: [
        _buildSectionHeader('Personal Information', headerBgColor),
        _buildInfoRow('Born', birthDateString),
        _buildInfoRow('Birth Place', widget.player.birthPlace ?? 'N/A'),
        _buildInfoRow(
          'Nickname',
          widget.player.nickname ?? widget.player.name,
        ), // Fallback nickname to name
        _buildInfoRow(
          'Role',
          widget.player.role ?? 'N/A',
        ), // Make sure 'role' exists in PlayerInfo
        _buildInfoRow(
          'Batting Style',
          widget.player.battingStyle ?? 'N/A',
        ), // Make sure 'battingStyle' exists
        _buildInfoRow(
          'Bowling Style',
          widget.player.bowlingStyle ?? 'N/A',
        ), // Make sure 'bowlingStyle' exists
        _buildInfoRow(
          'Team',
          widget.player.internationalTeam ?? 'N/A',
        ), // Make sure 'internationalTeam' exists
        if (widget.player.iplTeam != null &&
            widget.player.iplTeam!.isNotEmpty) // Make sure 'iplTeam' exists
          _buildInfoRow('IPL Team', widget.player.iplTeam!),
      ],
    );
  }

  // --- Helper for Info Tab section header (Unchanged) ---
  Widget _buildSectionHeader(String title, Color bgColor) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontSize: 16,
        ),
      ),
    );
  }

  // --- Helper for Info Tab rows (Unchanged) ---
  Widget _buildInfoRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  // --- Builds the Batting or Bowling Stats Tab ---
  Widget _buildStatsTab(
    BuildContext context,
    _TabStatType tabType,
    Color headerBgColor,
  ) {
    // Use the updated stat order lists based on the new model
    final List<String> statKeys =
        (tabType == _TabStatType.batting)
            ? _battingStatOrder
            : _bowlingStatOrder;

    // Check if there are any relevant stats *for this tab type* across all formats
    bool hasAnyStatsForTab = _displayFormats.any((format) {
      final stats = _findStatsForFormat(format);
      if (stats == null) return false;
      // Check if *any* key relevant to this tab has a non-zero/non-null value
      return statKeys.any((key) {
        String value = _getFormattedStatValue(
          stats,
          key,
          tabType,
        ); // Pass tabType here
        return value != '-' &&
            value != '0' &&
            value != '0.0' &&
            value != '0.00';
      });
    });

    if (!hasAnyStatsForTab) {
      return Column(
        children: [
          _buildSectionHeader(
            tabType == _TabStatType.batting ? 'Batting Stats' : 'Bowling Stats',
            headerBgColor,
          ),
          Expanded(
            child: Center(
              child: Text("No relevant ${tabType.name} stats available."),
            ),
          ),
        ],
      );
    }

    // --- Columns setup (Use MatchType.name) ---
    final List<DataColumn> columns = [
      DataColumn(
        label: Expanded(
          child: Text('Stat', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      ..._displayFormats.map(
        (format) => DataColumn(
          label: Expanded(
            child: Text(
              // Get the string representation from the enum name
              matchTypeToString(format).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          numeric: true,
        ),
      ),
    ];

    // --- Rows setup ---
    final List<DataRow> rows =
        statKeys
            .map((key) {
              // Check if *this specific stat row* has meaningful data across formats
              bool rowHasData = _displayFormats.any((format) {
                final stats = _findStatsForFormat(
                  format,
                ); // Find the single stats object
                // Pass the tabType to know which fields to check
                String value = _getFormattedStatValue(stats, key, tabType);
                return value != '-' &&
                    value != '0' &&
                    value != '0.0' &&
                    value != '0.00';
              });

              if (!rowHasData) {
                return null; // Skip rows with no meaningful data (e.g., all zeros/hyphens)
              }

              return DataRow(
                cells: [
                  DataCell(
                    Text(key, style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  ..._displayFormats.map((format) {
                    // Find the single CareerStats object for the format
                    final stats = _findStatsForFormat(format);
                    return DataCell(
                      Center(
                        child: Text(
                          // Get the specific value using the helper, passing the tabType
                          _getFormattedStatValue(stats, key, tabType),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ],
              );
            })
            .whereType<DataRow>()
            .toList(); // Filter out the null rows

    if (rows.isEmpty) {
      return Column(
        children: [
          _buildSectionHeader(
            tabType == _TabStatType.batting ? 'Batting Stats' : 'Bowling Stats',
            headerBgColor,
          ),
          Expanded(
            child: Center(
              child: Text("No significant ${tabType.name} stats to display."),
            ),
          ),
        ],
      );
    }

    // --- DataTable structure (mostly unchanged) ---
    return Column(
      children: [
        _buildSectionHeader(
          tabType == _TabStatType.batting ? 'Batting Stats' : 'Bowling Stats',
          headerBgColor,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DataTable(
                  columns: columns,
                  rows: rows,
                  columnSpacing: 20,
                  headingRowHeight: 40,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 48,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Stat Order Definitions - UPDATED based on new CareerStats model ---
  static const List<String> _battingStatOrder = [
    'Matches', 'Innings', 'NO', 'Runs', 'HS', 'Avg', 'BF', // Balls Faced
    'SR', '100', '50', '4s', '6s', 'Ct', 'St', // Catches, Stumpings
    // Missing: Ducks, 200s, 300s
  ];

  static const List<String> _bowlingStatOrder = [
    'Matches', 'Innings', 'Balls', 'Runs', 'Wkts', 'BBM', // Best Bowling Match
    'Avg', 'Econ', 'SR', '4W', '5W',
    // Missing: Maidens, 10w, BBI (using BBM)
  ];

  // --- Helper to get and format stat values - SIGNIFICANTLY UPDATED ---
  String _getFormattedStatValue(
    CareerStats? stats,
    String key,
    _TabStatType tabType,
  ) {
    // Check if stats object exists for the format
    if (stats == null) return '-';

    // Helper for formatting doubles
    String formatDouble(double? value, {int precision = 2}) {
      if (value == null || value.isNaN || value.isInfinite) return '-';
      // Basic check to avoid 0.0 if divisor was likely 0
      if (value == 0.0) {
        if ((key == 'Avg' || key == 'SR') &&
            tabType == _TabStatType.batting &&
            (stats.ballsFaced ?? 0) == 0 &&
            (stats.matches ?? 0) == (stats.notOuts ?? 0))
          return '-'; // Batting Avg/SR
        if ((key == 'Avg' || key == 'SR' || key == 'Econ') &&
            tabType == _TabStatType.bowling &&
            (stats.ballsBowled ?? 0) == 0)
          return '-'; // Bowling Avg/SR/Econ
        if (key == 'Avg' &&
            tabType == _TabStatType.bowling &&
            (stats.wickets ?? 0) == 0)
          return '-'; // Bowling Avg if 0 wickets
      }
      return value.toStringAsFixed(precision);
    }

    // Helper for formatting integers (show '0' instead of '-')
    String formatInt(int? value) =>
        (value == null || value == 0) ? '0' : value.toString();

    // Decide which value to return based on the key (matching _batting/_bowlingStatOrder)
    // Use the tabType to know which fields are relevant if names are ambiguous (none in this new model)
    switch (key) {
      // --- COMMON / BATTING ---
      case 'Matches':
        return formatInt(stats.matches);
      // Note: Your model doesn't have a separate 'innings' field. Matches is often used for both.
      // If you *need* distinct innings, you'd have to add it to the CareerStats model.
      case 'Innings':
        return formatInt(
          stats.matches,
        ); // Using Matches as placeholder for Innings
      case 'NO':
        return formatInt(stats.notOuts);
      case 'Runs': // Batting: Runs Scored | Bowling: Runs Conceded
        return tabType == _TabStatType.batting
            ? formatInt(stats.runs)
            : formatInt(stats.runsConceded);
      case 'HS':
        return stats.highestScore?.isNotEmpty == true
            ? stats.highestScore!
            : '-';
      case 'Avg': // Batting Average | Bowling Average
        return tabType == _TabStatType.batting
            ? formatDouble(stats.average)
            : formatDouble(stats.bowlingAverage);
      case 'BF':
        return formatInt(stats.ballsFaced);
      case 'SR': // Batting Strike Rate | Bowling Strike Rate
        return tabType == _TabStatType.batting
            ? formatDouble(stats.strikeRate)
            : formatDouble(stats.bowlingStrikeRate);
      case '100':
        return formatInt(stats.hundreds);
      case '50':
        return formatInt(stats.fifties);
      case '4s':
        return formatInt(stats.fours);
      case '6s':
        return formatInt(stats.sixes);
      case 'Ct':
        return formatInt(stats.catches);
      case 'St':
        return formatInt(stats.stumpings);

      // --- BOWLING ---
      case 'Balls':
        return formatInt(stats.ballsBowled);
      case 'Wkts':
        return formatInt(stats.wickets);
      case 'BBM':
        return stats.bestBowlingMatch?.isNotEmpty == true
            ? stats.bestBowlingMatch!
            : '-';
      case 'Econ':
        return formatDouble(stats.economyRate);
      case '4W':
        return formatInt(stats.fourWickets);
      case '5W':
        return formatInt(stats.fiveWickets);

      default:
        return '-';
    }
  }
}
