import 'package:combo_dream11/src/data/model/player_info.dart';
import 'package:combo_dream11/src/presentetion/riverpod/z_mock/list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerInfoProvider =
    NotifierProvider<PlayerInfoNotifier, List<PlayerInfo>>(
      () => PlayerInfoNotifier(),
    );

class PlayerInfoNotifier extends Notifier<List<PlayerInfo>> {
  @override
  List<PlayerInfo> build() {
    return [...mockPlayers]; // Initial empty list of players
  }

  void addPlayer(PlayerInfo player) {
    state = [...state, player];
    if (kDebugMode) {
      print("Player added in Notifier. New count: ${state.length}");
    } // Add logging
  }

  void updatePlayer(String id, PlayerInfo updated) {
    state = [
      for (final player in state)
        if (player.id == id) updated else player,
    ];
  }

  void removePlayer(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void clearPlayers() {
    state = [];
  }
}
