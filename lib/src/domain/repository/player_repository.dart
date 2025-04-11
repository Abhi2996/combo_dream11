import 'package:combo_dream11/src/data/model/player_model.dart';
import 'package:combo_dream11/src/domain/entity/player_entity.dart';

abstract class PlayerRepository {
  Future<List<PlayerModel>> getAllPlayers();
  Future<int> insertPlayer(PlayerEntity player);
  Future<int> updatePlayer(PlayerEntity player);
  Future<int> deletePlayer(int id);
}
