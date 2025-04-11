import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:equatable/equatable.dart';

class MatchEntry extends Equatable {
  final String id;
  final String playerId;
  final String playerName;
  final PlayerRole playerRole;
  final DateTime playerDateOfBirth;
  final DateTime matchDate;
  final String stadium;
  final String pitchCondition;

  // Player's Team Info
  final String playerNationalTeam;
  final String playerIplTeam;

  // Batting Stats
  final int? runs;
  final int? ballsFaced;
  final int? fours;
  final int? sixes;

  // Bowling Stats
  final int? ballsBowled;
  final int? runsConceded;
  final int? wickets;
  final String? bestBowling;

  // Fielding/Keeping Stats
  final int? catches;
  final int? stumpings;

  const MatchEntry({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.playerRole,
    required this.playerDateOfBirth,
    required this.matchDate,
    required this.stadium,
    required this.pitchCondition,
    required this.playerNationalTeam,
    required this.playerIplTeam,
    this.runs,
    this.ballsFaced,
    this.fours,
    this.sixes,
    this.ballsBowled,
    this.runsConceded,
    this.wickets,
    this.bestBowling,
    this.catches,
    this.stumpings,
  });

  @override
  List<Object?> get props => [
    id,
    playerId,
    playerName,
    playerRole,
    playerDateOfBirth,
    matchDate,
    stadium,
    pitchCondition,
    playerNationalTeam,
    playerIplTeam,
    runs,
    ballsFaced,
    fours,
    sixes,
    ballsBowled,
    runsConceded,
    wickets,
    bestBowling,
    catches,
    stumpings,
  ];

  // --- Calculation Helpers ---

  double? get battingStrikeRate {
    if (runs != null && ballsFaced != null && ballsFaced! > 0) {
      return (runs! / ballsFaced!) * 100.0;
    }
    return null;
  }

  double? get bowlingStrikeRate {
    if (wickets != null &&
        wickets! > 0 &&
        ballsBowled != null &&
        ballsBowled! > 0) {
      return (ballsBowled! / wickets!);
    }
    return null;
  }

  double? get bowlingEconomy {
    if (runsConceded != null && ballsBowled != null && ballsBowled! > 0) {
      double overs = ballsBowled! / 6.0;
      return runsConceded! / overs;
    }
    return null;
  }
}
