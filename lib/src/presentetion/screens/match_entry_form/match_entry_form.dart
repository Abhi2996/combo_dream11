import 'package:combo_dream11/src/core/ToastService.dart';
import 'package:combo_dream11/src/data/model/enums/IndianStadium.dart';
import 'package:combo_dream11/src/data/model/enums/enumFromString.dart';
import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:combo_dream11/src/data/model/enums/pitch_condition.dart';
import 'package:combo_dream11/src/data/model/match_entry.dart';
import 'package:combo_dream11/src/data/model/player_info.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/match_entry_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // For generating IDs

// Assuming these imports exist for your project structure

class AddMatchEntryScreen extends ConsumerWidget {
  final PlayerInfo playerInfo;
  final MatchEntry? matchToEdit; // Pass match data if editing

  const AddMatchEntryScreen({
    super.key,
    this.matchToEdit,
    required this.playerInfo,
  });

  // Handles submission, including error handling and calling the correct provider method
  Future<void> _handleMatchSubmit(
    BuildContext context,
    WidgetRef ref,
    MatchEntry match,
  ) async {
    // Determine if we are adding or updating
    final bool isAdding = matchToEdit == null;
    final notifier = ref.read(matchEntryNotifierProvider.notifier);

    try {
      if (isAdding) {
        // ===== Call ADD logic =====
        // Assuming addEntry might be async (e.g., saves to DB)
        notifier.addEntry(match);
      } else {
        // ===== Call UPDATE logic =====
        // Ensure the match object has the correct ID for updating
        // If the form doesn't inherently set the ID, you might need to ensure it here:
        // final matchWithId = match.copyWith(id: matchToEdit!.id); // Example if using copyWith
        // Assuming updateEntry needs the ID and the updated data, and might be async
        notifier.updateEntry(
          match.id,
          match,
        ); // Make sure match.id is correctly populated from the form or matchToEdit
      }

      // Show success message ONLY if the operation succeeded
      if (context.mounted) {
        // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${isAdding ? 'Added' : 'Updated'} Match Entry for ${match.playerName}',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green[700],
          ),
        );

        // Optionally navigate back only on success
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }
    } catch (e, stackTrace) {
      // Log the error for debugging
      debugPrint("Error submitting match entry: $e");
      debugPrint("Stack trace: $stackTrace");

      // Show error message to the user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error ${isAdding ? 'adding' : 'updating'} match entry: ${e.toString()}',
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MatchEntryForm(
      playerInfo: playerInfo,
      onSubmit: (match) => _handleMatchSubmit(context, ref, match),
      // Pass the initial data to the form if editing
      initialMatchEntry: matchToEdit,
    );
  }
}

//---------------------------------------------------------------------
// Form Widget (Reusable UI Component)
//---------------------------------------------------------------------
// ignore: must_be_immutable

//---------------------------------------------------------------------
// Form Widget - UI Refinement and Standardization
//---------------------------------------------------------------------
class MatchEntryForm extends HookConsumerWidget {
  final Function(MatchEntry) onSubmit;
  final PlayerInfo playerInfo;
  final MatchEntry? initialMatchEntry;

  const MatchEntryForm({
    super.key,
    required this.onSubmit,
    required this.playerInfo,
    this.initialMatchEntry,
  });

  // --- UI Constants ---
  static const double _vSpace = 16.0; // Standard vertical spacing
  static const double _hSpace =
      8.0; // Standard horizontal spacing (e.g., in rows)

  // --- LOGIC HELPERS (Unchanged) ---
  Future<void> _pickDate(
    BuildContext context,
    ValueNotifier<DateTime?> dateNotifier,
  ) async {
    // ... Date picking logic ... (as before)
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateNotifier.value ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && picked != dateNotifier.value) {
      dateNotifier.value = picked;
    }
  }

  int? _parseOptionalInt(String? text) {
    // ... Parsing logic ... (as before)
    if (text == null || text.trim().isEmpty) return null;
    return int.tryParse(text.trim());
  }

  // --- UI HELPERS (Refined for Consistency) ---

  // Standardized Input Decoration
  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    required ThemeData theme,
    IconData? prefixIconData, // Use prefix icon for alignment
    Widget? suffixIcon,
    bool isDense = false,
  }) {
    final colorScheme = theme.colorScheme;
    final baseBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: colorScheme.outlineVariant.withOpacity(0.8),
      ),
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon:
          prefixIconData != null
              ? Icon(
                prefixIconData,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              )
              : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor:
          theme.inputDecorationTheme.fillColor ??
          colorScheme.surfaceContainerLowest, // Subtle fill
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: baseBorder.copyWith(
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: baseBorder.copyWith(
        borderSide: BorderSide(color: colorScheme.error, width: 1.2),
      ),
      focusedErrorBorder: baseBorder.copyWith(
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isDense ? 12 : 14,
      ), // Consistent padding
      isDense: isDense,
    );
  }

  // Read-Only Info Row (Used in Card)
  Widget _buildReadOnlyInfoRow({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110, // Fixed width for labels for alignment
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  // Text Input Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    IconData? icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(
        label: label,
        hint: hint,
        prefixIconData: icon,
        theme: theme,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      textCapitalization: textCapitalization,
      textInputAction: TextInputAction.next,
      readOnly: readOnly,
      style:
          readOnly
              ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
              : null, // Dim read-only text
    );
  }

  // Number Input Field
  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    IconData? icon,
  }) {
    return _buildTextField(
      controller: controller,
      label: label,
      theme: theme,
      icon: icon,
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  // Dropdown Field (Using String State)
  Widget _buildStringDropdown<T extends Enum>({
    required String label,
    required ThemeData theme,
    required IconData icon,
    required ValueNotifier<String?> selectedValueNotifier,
    required List<T> enumValues,
    required String unknownValueName, // e.g., IndianStadium.unknown.name
    bool isRequired = false,
  }) {
    // Helper to build items (moved inside for context)
    List<DropdownMenuItem<String>> buildItems() {
      return enumValues.map((T value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.displayName, overflow: TextOverflow.ellipsis),
        );
      }).toList();
    }

    return DropdownButtonFormField<String?>(
      value: selectedValueNotifier.value,
      items: buildItems(),
      onChanged: (String? newValue) => selectedValueNotifier.value = newValue,
      decoration: _buildInputDecoration(
        label: label,
        hint: 'Select $label',
        prefixIconData: icon,
        theme: theme,
      ),
      isExpanded: true,
      validator:
          !isRequired
              ? null
              : (value) =>
                  (value == null || value == unknownValueName)
                      ? '$label is required'
                      : null,
    );
  }

  // Date Picker Field
  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required ValueNotifier<DateTime?> dateNotifier,
    required IconData icon,
    required bool isRequired,
    required ThemeData theme,
  }) {
    final currentValue = dateNotifier.value;

    return FormField<DateTime>(
      initialValue: currentValue,
      validator:
          !isRequired
              ? null
              : (value) => value == null ? '$label is required' : null,
      builder: (formFieldState) {
        return InkWell(
          onTap: () async {
            await _pickDate(context, dateNotifier);
            formFieldState.didChange(dateNotifier.value);
          },
          child: InputDecorator(
            // Use InputDecorator to mimic text field appearance
            decoration: _buildInputDecoration(
              label: label,
              prefixIconData: icon,
              theme: theme,
            ).copyWith(
              errorText: formFieldState.errorText,
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.onSurfaceVariant,
              ), // Dropdown arrow
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              // Use minimum height from theme or default
              constraints: BoxConstraints(
                minHeight:
                    theme.inputDecorationTheme.constraints?.minHeight ?? 48,
              ),
              child: Text(
                currentValue == null
                    ? 'Select Date'
                    : DateFormat.yMMMd().format(currentValue),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: currentValue == null ? theme.hintColor : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Section Header
  Widget _buildSectionHeader(
    String title,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _vSpace * 1.5,
        bottom: _vSpace * 0.75,
      ), // Adjusted spacing
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Stats ExpansionTile
  Widget _buildStatsExpansionTile({
    required String title,
    required ThemeData theme,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Card(
      elevation: 0.5, // Subtle elevation
      margin: const EdgeInsets.symmetric(vertical: _vSpace / 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ), // Subtle border
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        initiallyExpanded: initiallyExpanded,
        // Match background with input fields slightly
        backgroundColor:
            theme.inputDecorationTheme.fillColor?.withOpacity(0.5) ??
            theme.colorScheme.surfaceContainerLowest,
        collapsedBackgroundColor:
            theme.inputDecorationTheme.fillColor?.withOpacity(0.5) ??
            theme.colorScheme.surfaceContainerLowest,
        childrenPadding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16,
        ), // Padding inside expansion
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        shape: const Border(), // Remove internal border
        collapsedShape: const Border(),
        children: children,
      ),
    );
  }

  // Helper to create rows of stats with consistent spacing
  Widget _buildStatRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _vSpace * 0.75,
      ), // Space above each row within expansion
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : _hSpace,
              ), // Horizontal space between items
              child: children[index],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const uuid = Uuid(); // Logic Helper
    final isEditing = initialMatchEntry != null; // Logic Helper
    final theme = Theme.of(context); // UI Helper
    final textTheme = theme.textTheme; // UI Helper
    final colorScheme = theme.colorScheme; // UI Helper

    // --- State Initialization (Logic - Unchanged) ---
    final initialPlayerRole = enumFromString<PlayerRole>(
      playerInfo.role,
      PlayerRole.values,
    );
    final selectedMatchDate = useState<DateTime?>(
      initialMatchEntry?.matchDate ?? DateTime.now(),
    );
    final selectedStadium = useState<String?>(
      initialMatchEntry?.stadium ?? IndianStadium.unknown.name,
    );
    final selectedPitchCondition = useState<String?>(
      initialMatchEntry?.pitchCondition ?? PitchCondition.unknown.name,
    );
    final runsController = useTextEditingController(
      text: initialMatchEntry?.runs?.toString(),
    );
    final ballsFacedController = useTextEditingController(
      text: initialMatchEntry?.ballsFaced?.toString(),
    );
    final foursController = useTextEditingController(
      text: initialMatchEntry?.fours?.toString(),
    );
    final sixesController = useTextEditingController(
      text: initialMatchEntry?.sixes?.toString(),
    );
    final ballsBowledController = useTextEditingController(
      text: initialMatchEntry?.ballsBowled?.toString(),
    );
    final runsConcededController = useTextEditingController(
      text: initialMatchEntry?.runsConceded?.toString(),
    );
    final wicketsController = useTextEditingController(
      text: initialMatchEntry?.wickets?.toString(),
    );
    final bestBowlingController = useTextEditingController(
      text: initialMatchEntry?.bestBowling,
    );
    final catchesController = useTextEditingController(
      text: initialMatchEntry?.catches?.toString(),
    );
    final stumpingsController = useTextEditingController(
      text: initialMatchEntry?.stumpings?.toString(),
    );
    final formKey = useMemoized(() => GlobalKey<FormState>()); // Logic Helper

    // --- Submission Logic (Unchanged) ---
    void submitForm() {
      FocusScope.of(context).unfocus();
      if (formKey.currentState?.validate() ?? false) {
        // Decide on ID: Use existing if editing, generate if adding
        final String entryId;
        if (isEditing) {
          entryId = initialMatchEntry!.id; // Use the original ID
        } else {
          // Consider using a real UUID here instead of a compound key
          // final uuid = Uuid(); // Move Uuid instance outside build if used
          // entryId = uuid.v4();
          // Or keep your compound key if absolutely necessary, but ensure consistency:
          entryId =
              playerInfo.id +
              selectedMatchDate.value!
                  .toIso8601String(); // Use consistent date format
        }

        // Decide on Player ID type (String or Int?) - Using String as per current code
        final String finalPlayerId =
            playerInfo.id; // Assuming String is intended

        // --- PARSE ALL FIELDS ---
        final runs = _parseOptionalInt(runsController.text);
        final ballsFaced = _parseOptionalInt(ballsFacedController.text);
        final fours = _parseOptionalInt(foursController.text);
        final sixes = _parseOptionalInt(sixesController.text);
        final ballsBowled = _parseOptionalInt(ballsBowledController.text);
        final runsConceded = _parseOptionalInt(runsConcededController.text);
        final wickets = _parseOptionalInt(wicketsController.text);
        final bestBowling =
            bestBowlingController.text.trim().isEmpty
                ? null
                : bestBowlingController.text.trim();
        final catches = _parseOptionalInt(catchesController.text);
        final stumpings = _parseOptionalInt(stumpingsController.text);

        // --- Create MatchEntry with ALL data ---
        final matchEntry = MatchEntry(
          id: entryId, // Use the correctly determined ID
          playerId: finalPlayerId, // Use consistent player ID
          playerName: playerInfo.name,
          playerIplTeam: playerInfo.iplTeam!.trim(), // Directly use if string
          playerNationalTeam:
              playerInfo.internationalTeam!, // Directly use if string
          playerRole: initialPlayerRole!,
          playerDateOfBirth: playerInfo.birthDate!,
          matchDate: selectedMatchDate.value!,
          stadium: selectedStadium.value!, // Ensure not null or handle default
          pitchCondition:
              selectedPitchCondition
                  .value!, // Ensure not null or handle default
          // Batting
          runs: runs,
          ballsFaced: ballsFaced,
          fours: fours,
          sixes: sixes,

          // Bowling (NOW INCLUDED)
          ballsBowled: ballsBowled,
          runsConceded: runsConceded,
          wickets: wickets,
          bestBowling: bestBowling,

          // Fielding (NOW INCLUDED)
          catches: catches,
          stumpings: stumpings,
        );

        onSubmit(matchEntry);
      } else {
        ToastService.show(
          message: "Validation failed. Please check all fields.",
        );
        // Optional: Show more specific validation errors if needed
      }
    }

    // --- Build UI ---
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Match Entry' : 'Add Match Entry'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          60,
        ), // Padding for content + FAB space
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Section: Player Info Card ---
              Card(
                /* ... Player Info Card using _buildReadOnlyInfoRow ... */
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                margin: const EdgeInsets.only(bottom: _vSpace * 1.5),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Player Info",
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 16, thickness: 0.5),
                      _buildReadOnlyInfoRow(
                        label: 'ID:',
                        value: playerInfo.id,
                        theme: theme,
                      ),
                      _buildReadOnlyInfoRow(
                        label: 'Name:',
                        value: playerInfo.name,
                        theme: theme,
                      ),
                      if (playerInfo.birthDate != null)
                        _buildReadOnlyInfoRow(
                          label: 'DOB:',
                          value: DateFormat.yMMMd().format(
                            playerInfo.birthDate!,
                          ),
                          theme: theme,
                        ),
                      if (initialPlayerRole != null)
                        _buildReadOnlyInfoRow(
                          label: 'Role:',
                          value: initialPlayerRole.displayName,
                          theme: theme,
                        ),
                      if (playerInfo.internationalTeam != null)
                        _buildReadOnlyInfoRow(
                          label: 'National Team:',
                          value: playerInfo.internationalTeam!,
                          theme: theme,
                        ),
                      if (playerInfo.iplTeam != null)
                        _buildReadOnlyInfoRow(
                          label: 'IPL Team:',
                          value: playerInfo.iplTeam!,
                          theme: theme,
                        ),
                    ],
                  ),
                ),
              ),

              // --- Section: Match Details ---
              _buildSectionHeader("Match Details", textTheme, colorScheme),
              _buildDatePickerField(
                context: context,
                label: 'Match Date *',
                dateNotifier: selectedMatchDate,
                icon: Icons.calendar_today_outlined,
                isRequired: true,
                theme: theme,
              ),
              const SizedBox(height: _vSpace),
              _buildStringDropdown<IndianStadium>(
                label: 'Stadium *',
                theme: theme,
                icon: Icons.stadium_outlined,
                selectedValueNotifier: selectedStadium,
                enumValues: IndianStadium.values,
                unknownValueName: IndianStadium.unknown.name,
                isRequired: true,
              ),
              const SizedBox(height: _vSpace),
              _buildStringDropdown<PitchCondition>(
                label: 'Pitch Condition *',
                theme: theme,
                icon: Icons.grass_outlined,
                selectedValueNotifier: selectedPitchCondition,
                enumValues: PitchCondition.values,
                unknownValueName: PitchCondition.unknown.name,
                isRequired: true,
              ),

              // --- Sections for Stats (ExpansionTiles) ---
              _buildStatsExpansionTile(
                title: "Batting Stats",
                theme: theme,
                initiallyExpanded:
                    isEditing &&
                    (initialMatchEntry?.runs != null ||
                        initialMatchEntry?.ballsFaced != null),
                children: [
                  _buildStatRow([
                    _buildNumberInput(
                      controller: runsController,
                      label: 'Runs',
                      icon: Icons.scoreboard_outlined,
                      theme: theme,
                    ),
                    _buildNumberInput(
                      controller: ballsFacedController,
                      label: 'Balls Faced',
                      icon: Icons.timer_outlined,
                      theme: theme,
                    ),
                  ]),
                  _buildStatRow([
                    _buildNumberInput(
                      controller: foursController,
                      label: 'Fours',
                      icon: Icons.looks_4_outlined,
                      theme: theme,
                    ),
                    _buildNumberInput(
                      controller: sixesController,
                      label: 'Sixes',
                      icon: Icons.looks_6_outlined,
                      theme: theme,
                    ),
                  ]),
                ],
              ),

              _buildStatsExpansionTile(
                title: "Bowling Stats",
                theme: theme,
                initiallyExpanded:
                    isEditing &&
                    (initialMatchEntry?.ballsBowled != null ||
                        initialMatchEntry?.wickets != null),
                children: [
                  _buildStatRow([
                    _buildNumberInput(
                      controller: ballsBowledController,
                      label: 'Balls Bowled',
                      icon: Icons.sports_volleyball_outlined,
                      theme: theme,
                    ),
                    _buildNumberInput(
                      controller: runsConcededController,
                      label: 'Runs Conceded',
                      icon: Icons.trending_down,
                      theme: theme,
                    ),
                  ]),
                  _buildStatRow([
                    _buildNumberInput(
                      controller: wicketsController,
                      label: 'Wickets',
                      icon: Icons.sports_kabaddi_outlined,
                      theme: theme,
                    ),
                    Expanded(
                      child: _buildTextField(
                        // Use generic text field helper
                        controller: bestBowlingController,
                        label: 'Best Bowling',
                        hint: 'e.g., 3/25',
                        icon: Icons.star_border_outlined,
                        theme: theme,
                      ),
                    ),
                  ]),
                ],
              ),

              _buildStatsExpansionTile(
                title: "Fielding Stats",
                theme: theme,
                initiallyExpanded:
                    isEditing &&
                    (initialMatchEntry?.catches != null ||
                        initialMatchEntry?.stumpings != null),
                children: [
                  _buildStatRow([
                    _buildNumberInput(
                      controller: catchesController,
                      label: 'Catches',
                      icon: Icons.back_hand_outlined,
                      theme: theme,
                    ),
                    _buildNumberInput(
                      controller: stumpingsController,
                      label: 'Stumpings',
                      icon: Icons.accessibility_new_outlined,
                      theme: theme,
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: _vSpace * 2), // More space before submit
              // --- Submit Button ---
              ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save_alt : Icons.post_add),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    isEditing ? 'Update Match Entry' : 'Add Match Entry',
                    style: textTheme.labelLarge?.copyWith(fontSize: 16),
                  ),
                ),
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(
                    48,
                  ), // Standard button height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Removed extra SizedBox at the end, padding is on SingleChildScrollView
            ],
          ),
        ),
      ),
    );
  }
} // End of MatchEntryForm
