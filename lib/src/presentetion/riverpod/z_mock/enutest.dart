import 'package:combo_dream11/src/data/model/enums/player_info_enum.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('IPL Team Selector')),
        body: Padding(padding: EdgeInsets.all(16.0), child: TeamDropdown()),
      ),
    );
  }
}

// --- ENUM + EXTENSION FOR OFFICIAL TEAMS ---

// --- HYBRID MODEL ---

class TeamSelection {
  final String displayName;
  final bool isCustom;

  TeamSelection({required this.displayName, this.isCustom = false});

  @override
  String toString() => displayName;
}

// --- WIDGET: TEAM DROPDOWN + ADD NEW ---

class TeamDropdown extends StatefulWidget {
  const TeamDropdown({super.key});

  @override
  State<TeamDropdown> createState() => _TeamDropdownState();
}

class _TeamDropdownState extends State<TeamDropdown> {
  final TextEditingController _controller = TextEditingController();
  late List<TeamSelection> allTeams;
  TeamSelection? selectedTeam;

  @override
  void initState() {
    super.initState();
    allTeams = _loadOfficialTeams();
  }

  List<TeamSelection> _loadOfficialTeams() {
    return PlayerIplTeam.values.map((e) {
      return TeamSelection(displayName: e.name);
    }).toList();
  }

  void _addCustomTeam(String name) {
    if (name.trim().isEmpty) return;
    final newTeam = TeamSelection(displayName: name.trim(), isCustom: true);
    setState(() {
      allTeams.add(newTeam);
      selectedTeam = newTeam;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select or Add an IPL Team:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),

          // Dropdown
          DropdownButton<TeamSelection>(
            value: selectedTeam,
            hint: const Text('Choose a team'),
            isExpanded: true,
            items:
                allTeams.map((team) {
                  return DropdownMenuItem(
                    value: team,
                    child: Text(
                      team.displayName + (team.isCustom ? ' (Custom)' : ''),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() => selectedTeam = value);
            },
          ),

          const SizedBox(height: 20),

          // Text input to add custom team
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Add Custom Team',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addCustomTeam(_controller.text),
              ),
            ),
            onSubmitted: _addCustomTeam,
          ),

          const SizedBox(height: 20),

          // Display selected team
          if (selectedTeam != null)
            Text(
              'Selected Team: ${selectedTeam!.displayName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
