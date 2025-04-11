import 'package:combo_dream11/src/data/model/match_entry.dart';
import 'package:combo_dream11/src/presentetion/riverpod/match_entry/mockmatchlist.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final matchEntryNotifierProvider =
    NotifierProvider<MatchEntryNotifier, List<MatchEntry>>(
      () => MatchEntryNotifier(),
    );

class MatchEntryNotifier extends Notifier<List<MatchEntry>> {
  @override
  List<MatchEntry> build() {
    return [...mockMatchEntries]; // Initial state: empty list of match entries
  }

  void addEntry(MatchEntry entry) {
    state = [...state, entry];
  }

  void updateEntry(String id, MatchEntry updated) {
    state = [
      for (final entry in state)
        if (entry.id == id) updated else entry,
    ];
  }

  void removeEntry(String id) {
    state = state.where((entry) => entry.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

//
