import 'package:combo_dream11/src/core/ToastService.dart';
import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:combo_dream11/src/data/model/enums/player_info_enum.dart';
import 'package:combo_dream11/src/data/model/player_info.dart';
import 'package:combo_dream11/src/presentetion/riverpod/player_info/player_info_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

//---------------------------------------------------------------------
// Screen Widget (Entry Point for the Form)
//---------------------------------------------------------------------
class AddPlayerScreen extends HookConsumerWidget {
  final PlayerInfo? playerToEdit; // Pass player data if editing

  const AddPlayerScreen({
    super.key,
    this.playerToEdit, // Make it optional
  });

  // This function will be called by the form when submitted successfully
  void _handlePlayerSubmit(
    BuildContext context,
    PlayerInfo player,
    WidgetRef ref,
  ) {
    // ===== TODO: Implement actual submission logic here =====
    // Examples:
    // 1. Use Riverpod to update state:
    //    ref.read(playerListProvider.notifier).addOrUpdatePlayer(player);
    // 2. Save to database
    // 3. Make API call

    // Optionally navigate back after submission
    // Navigator.of(context).pop();
    try {
      ref.read(playerInfoProvider.notifier).addPlayer(player);
      ToastService.show(message: "Added Player!!");
    } catch (e) {
      ToastService.show(message: "$e");
    }

    // ref.watch(playerInfoProvider).
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass the context to the submit handler if needed (e.g., for navigation)
    return PlayerInfoForm(
      onSubmit: (player) => _handlePlayerSubmit(context, player, ref),
      initialPlayerInfo: playerToEdit, // Pass existing data for editing
    );
  }
}

//---------------------------------------------------------------------
// Form Widget (Reusable UI Component)
//---------------------------------------------------------------------
class PlayerInfoForm extends HookConsumerWidget {
  final Function(PlayerInfo) onSubmit;
  final PlayerInfo? initialPlayerInfo;

  const PlayerInfoForm({
    super.key,
    required this.onSubmit,
    this.initialPlayerInfo,
  });

  // --- UI Constants ---
  static const double _vSpace = 16.0; // Standard vertical spacing

  // --- LOGIC HELPERS (Unchanged) ---

  /// Helper function to show a date picker dialog and update a ValueNotifier state.
  /// Specifically configured for selecting a birth date (past dates up to today).
  Future<void> _pickBirthDate(
    BuildContext context,
    ValueNotifier<DateTime?>
    dateNotifier, // The state variable holding the selected date
  ) async {
    // --- Configuration for the Date Picker ---

    // 1. Determine the initial date shown in the picker:
    //    - Use the currently selected date if available.
    //    - Otherwise, default to today's date.
    final DateTime initialDateValue = dateNotifier.value ?? DateTime.now();

    // 2. Define the allowed date range:
    final DateTime firstSelectableDate = DateTime(
      1900,
    ); // Earliest possible birth year (adjust as needed)
    final DateTime lastSelectableDate =
        DateTime.now(); // Latest possible birth date is today

    // 3. Ensure the initialDateValue is within the allowed range:
    //    (Prevents errors if the notifier somehow holds an invalid date)
    DateTime safeInitialDate = initialDateValue;
    if (safeInitialDate.isBefore(firstSelectableDate)) {
      safeInitialDate = firstSelectableDate;
    } else if (safeInitialDate.isAfter(lastSelectableDate)) {
      safeInitialDate = lastSelectableDate;
    }

    // --- Show the Date Picker Dialog ---

    final DateTime? picked = await showDatePicker(
      context: context, // Required build context
      initialDate:
          safeInitialDate, // The date picker opens highlighting this date
      firstDate: firstSelectableDate, // The earliest date the user can select
      lastDate: lastSelectableDate, // The latest date the user can select
      helpText: 'Select Birth Date', // Optional: Title text for the dialog
      // builder: (context, child) {    // Optional: Apply custom theme
      //   return Theme(
      //     data: Theme.of(context).copyWith( /* Custom Theme properties */ ),
      //     child: child!,
      //   );
      // },
    );

    // --- Update State if a Date was Picked ---

    // Check if the user actually selected a date (didn't cancel)
    // and if the selected date is different from the current value in the notifier
    if (picked != null && picked != dateNotifier.value) {
      // Update the state notifier. This will trigger a rebuild in widgets
      // that are listening to this notifier (like via watch() in Riverpod/Provider
      // or using a ValueListenableBuilder).
      dateNotifier.value = picked;
    }
    // If picked is null (user cancelled) or the same date was chosen again, do nothing.
  }
  // --- UI HELPERS (Refined for Consistency) ---

  // Standardized Input Decoration
  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    required ThemeData theme,
    IconData? prefixIconData,
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
      // Use prefix icon for consistent alignment within the border
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
          colorScheme.surfaceContainerLowest,
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
      ),
      isDense: isDense,
    );
  }

  // Text Input Field Helper
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    IconData? icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
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
      validator: validator,
      textCapitalization: textCapitalization,
      textInputAction: TextInputAction.next, // Keep for keyboard flow
    );
  }

  // Dropdown Field Helper (Using String State)
  Widget _buildStringDropdown<T extends Enum>({
    required String label,
    required ThemeData theme,
    required IconData icon,
    required ValueNotifier<String?> selectedValueNotifier,
    required List<T> enumValues,
    String? Function(String?)? validator, // Optional validator
  }) {
    // Helper to build items (using displayName)
    List<DropdownMenuItem<String>> buildItems() {
      return enumValues.map((T value) {
        return DropdownMenuItem<String>(
          value: value.name, // Value stored is the name string
          child: Text(
            value.name,
            overflow: TextOverflow.ellipsis,
          ), // Display friendly name
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
      validator: validator,
    );
  }

  // Date Picker Field Helper (Standardized Look)
  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required ValueNotifier<DateTime?> dateNotifier,
    required IconData icon,
    required ThemeData theme,
  }) {
    final currentValue = dateNotifier.value;

    return FormField<DateTime>(
      // Use FormField to integrate validation if needed later
      initialValue: currentValue,
      // validator: (value) => value == null ? '$label is required' : null, // Example validation
      builder: (formFieldState) {
        return InkWell(
          onTap: () async {
            await _pickBirthDate(
              context,
              dateNotifier,
            ); // Use specific picker function
            formFieldState.didChange(dateNotifier.value);
          },
          child: InputDecorator(
            decoration: _buildInputDecoration(
              label: label,
              prefixIconData: icon,
              theme: theme,
            ).copyWith(
              errorText: formFieldState.errorText,
              // Use suffix icon for calendar button for consistency
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(
                minHeight:
                    theme.inputDecorationTheme.constraints?.minHeight ?? 48,
              ),
              child: Text(
                currentValue == null
                    ? 'Select Date (Optional)'
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Logic Helpers (Unchanged) ---
    final isEditing = initialPlayerInfo != null;
    final theme = Theme.of(context); // UI Helper
    final textTheme = theme.textTheme; // UI Helper
    final colorScheme = theme.colorScheme; // UI Helper

    // --- State Hooks (Logic - Unchanged) ---
    final nameController = useTextEditingController(
      text: initialPlayerInfo?.name,
    );
    final birthPlaceController = useTextEditingController(
      text: initialPlayerInfo?.birthPlace,
    );
    final nicknameController = useTextEditingController(
      text: initialPlayerInfo?.nickname,
    );
    final selectedBirthDate = useState<DateTime?>(initialPlayerInfo?.birthDate);
    final selectedRole = useState<String?>(
      initialPlayerInfo?.role ?? PlayerRole.unknown.name,
    );
    final selectedBattingStyle = useState<String?>(
      initialPlayerInfo?.battingStyle ?? BattingStyle.unknown.name,
    );
    final selectedBowlingStyle = useState<String?>(
      initialPlayerInfo?.bowlingStyle ?? BowlingStyle.none.name,
    );
    final selectedIntlTeam = useState<String?>(
      initialPlayerInfo?.internationalTeam ?? InternationalTeam.none.name,
    );
    final selectedIplTeam = useState<String?>(
      initialPlayerInfo?.iplTeam ?? PlayerIplTeam.none.name,
    );
    final formKey = useMemoized(() => GlobalKey<FormState>()); // Logic Helper

    // --- Submission Logic (Unchanged) ---
    void submitForm() {
      FocusScope.of(context).unfocus(); // Dismiss keyboard
      if (formKey.currentState?.validate() ?? false) {
        // ... (Parsing and PlayerInfo object creation remains the same) ...
        final playerInfo = PlayerInfo(
          id: initialPlayerInfo?.id,
          name: nameController.text.trim(),
          birthDate: selectedBirthDate.value,
          birthPlace:
              birthPlaceController.text.trim().isEmpty
                  ? null
                  : birthPlaceController.text.trim(),
          nickname:
              nicknameController.text.trim().isEmpty
                  ? null
                  : nicknameController.text.trim(),
          role:
              selectedRole.value == PlayerRole.unknown.name
                  ? null
                  : selectedRole.value,
          battingStyle:
              selectedBattingStyle.value == BattingStyle.unknown.name
                  ? null
                  : selectedBattingStyle.value,
          bowlingStyle:
              selectedBowlingStyle.value == BowlingStyle.none.name
                  ? null
                  : selectedBowlingStyle.value,
          internationalTeam:
              selectedIntlTeam.value == InternationalTeam.none.name
                  ? null
                  : selectedIntlTeam.value,
          iplTeam:
              selectedIplTeam.value == PlayerIplTeam.none.name
                  ? null
                  : selectedIplTeam.value,
        );
        onSubmit(playerInfo);
        // SnackBar moved to _handlePlayerSubmit in parent screen
      } else {
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(/* ... error snackbar ... */);
      }
    }

    // --- Build UI ---
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Player Info' : 'Add New Player'),
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
          autovalidateMode: AutovalidateMode.disabled, // Validate on submit
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Name ---
              _buildTextField(
                controller: nameController,
                label: 'Player Name *',
                hint: 'Enter full name',
                icon: Icons.person_outline,
                theme: theme,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Player name is required';
                  if (value.trim().length < 2) return 'Name seems too short';
                  return null;
                },
              ),
              const SizedBox(height: _vSpace),

              // --- Birth Date ---
              _buildDatePickerField(
                context: context,
                label: 'Birth Date',
                dateNotifier: selectedBirthDate,
                icon: Icons.calendar_today_outlined,
                // isRequired: false, // Not marked as required in validator
                theme: theme,
              ),
              const SizedBox(height: _vSpace),
              // --- Need ipl team selected drop down
              Text('Select ipl team'),
              // --- Birth Place ---
              _buildTextField(
                controller: birthPlaceController,
                label: 'Birth Place',
                hint: 'e.g., Mumbai, India',
                icon: Icons.place_outlined,
                theme: theme,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: _vSpace),

              // --- Nickname ---
              _buildTextField(
                controller: nicknameController,
                label: 'Nickname',
                hint: 'e.g., Mahi, Hitman',
                icon: Icons.tag_faces_outlined,
                theme: theme,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: _vSpace * 1.5,
              ), // More space before dropdowns
              // --- Dropdowns ---
              _buildStringDropdown<PlayerRole>(
                label: 'Role',
                theme: theme,
                icon: Icons.sports_cricket_outlined,
                selectedValueNotifier: selectedRole,
                enumValues: PlayerRole.values,
              ),
              const SizedBox(height: _vSpace),
              _buildStringDropdown<BattingStyle>(
                label: 'Batting Style',
                theme: theme,
                icon: Icons.sports_baseball_outlined,
                selectedValueNotifier: selectedBattingStyle,
                enumValues: BattingStyle.values,
              ),
              const SizedBox(height: _vSpace),
              _buildStringDropdown<BowlingStyle>(
                label: 'Bowling Style',
                theme: theme,
                icon: Icons.sports_volleyball_outlined,
                selectedValueNotifier: selectedBowlingStyle,
                enumValues: BowlingStyle.values,
              ),
              const SizedBox(height: _vSpace),
              _buildStringDropdown<InternationalTeam>(
                label: 'International Team',
                theme: theme,
                icon: Icons.flag_outlined,
                selectedValueNotifier: selectedIntlTeam,
                enumValues: InternationalTeam.values,
              ),
              const SizedBox(height: _vSpace),
              _buildStringDropdown<PlayerIplTeam>(
                label: 'IPL Team',
                theme: theme,
                icon: Icons.shield_outlined,
                selectedValueNotifier: selectedIplTeam,
                enumValues: PlayerIplTeam.values,
              ),

              const SizedBox(height: _vSpace * 2), // Space before submit button
              // --- Submit Button ---
              ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save_alt : Icons.person_add_alt_1),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    isEditing ? 'Update Player' : 'Add Player',
                    style: textTheme.labelLarge?.copyWith(fontSize: 16),
                  ),
                ),
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // End of PlayerInfoForm
