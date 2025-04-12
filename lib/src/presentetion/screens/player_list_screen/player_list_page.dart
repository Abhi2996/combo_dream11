import 'package:combo_dream11/src/data/model/player_info.dart';
import 'package:combo_dream11/src/presentetion/riverpod/player_info/player_info_notifier.dart';
import 'package:combo_dream11/src/presentetion/screens/match_entry_form/match_entry_form.dart';
import 'package:combo_dream11/src/presentetion/screens/player_info_form/player_info_form.dart';
import 'package:combo_dream11/src/test_screen/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerListPage extends ConsumerWidget {
  // Use ConsumerWidget to access ref
  const PlayerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider state. The list page will rebuild when the list changes.
    final List<PlayerInfo> players = ref.watch(playerInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player List'),
        actions: [
          // Optional: Add a count badge or other actions
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text('Count: ${players.length}')),
          ),
        ],
      ),
      body:
          players.isEmpty
              ? const Center(
                // Show a message if the list is empty
                child: Text(
                  'No players added yet.\nTap the + button to add one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Card(
                    // Use Cards for better visual separation
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            // Simple avatar
                            child: Text(
                              player.name.isNotEmpty ? player.name[0] : '?',
                            ),
                          ),
                          title: Text(player.name),
                          subtitle: Text(
                            // Display some key info - using enum names directly from PlayerInfo String fields
                            // Need to handle potential null values gracefully
                            'Role: ${player.role ?? 'N/A'} | Team: ${player.internationalTeam ?? player.iplTeam ?? 'N/A'}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            // Example: Delete button
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[300],
                            ),
                            tooltip: 'Delete Player',
                            onPressed: () {
                              // Show confirmation dialog before deleting
                              showDialog(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: Text(
                                        'Are you sure you want to delete ${player.name}?',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed:
                                              () => Navigator.of(ctx).pop(),
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.red[700],
                                            ),
                                          ),
                                          onPressed: () {
                                            // Call the remove method from the provider
                                            ref
                                                .read(
                                                  playerInfoProvider.notifier,
                                                )
                                                .removePlayer(player.id);
                                            Navigator.of(
                                              ctx,
                                            ).pop(); // Close dialog
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${player.name} deleted',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                          onTap: () {
                            // Navigate to Edit screen (pass the player data)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AddPlayerScreen(
                                      playerToEdit: player,
                                    ), // Pass player data
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: () {
                                NavigationPaths.navigateToScreen(
                                  context: context,
                                  page: AddMatchEntryScreen(playerInfo: player),
                                );
                              },
                              child: Text('Match entry'),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: () {},
                              child: Text('Player Info'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddPlayerScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              // Ensure AddPlayerScreen does NOT receive playerToEdit when adding new
              builder: (_) => const AddPlayerScreen(),
            ),
          );
        },
        tooltip: 'Add Player',
        child: const Icon(Icons.add),
      ),
    );
  }
}
