import 'package:equatable/equatable.dart';

class PlayerModel extends Equatable {
  final int? id;
  final String name;
  final DateTime dateOfBirth;
  final String country;
  final String iplTeam;
  final String playingRole; // e.g., "Batter", "Bowler", "All-Rounder"
  final String playingTeam;
  final String playerImage;

  // Batting Stats
  final int? battingMatches;
  final int? battingInnings;
  final int? runs;
  final String? highestScore; // e.g., "120*"
  final double? average;
  final int? ballsFaced;
  final double? strikeRate;
  final int? centuries;
  final int? fifties;
  final int? fours;
  final int? sixes;

  // Bowling Stats
  final int? bowlingMatches;
  final int? bowlingInnings;
  final int? balls;
  final int? runsConceded;
  final int? wickets;
  final String? bestBowling;
  final double? averageBowling;
  final double? economy;
  final double? strikeRateBowling;
  final int? fourWickets;
  final int? fiveWickets;

  // Fielding Stats
  final int? catches;
  final int? stumpings;

  PlayerModel({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.country,
    required this.iplTeam,
    required this.playingRole,
    required this.playingTeam,
    required this.playerImage,
    this.battingMatches,
    this.battingInnings,
    this.runs,
    this.highestScore,
    this.average,
    this.ballsFaced,
    this.strikeRate,
    this.centuries,
    this.fifties,
    this.fours,
    this.sixes,
    this.bowlingMatches,
    this.bowlingInnings,
    this.balls,
    this.runsConceded,
    this.wickets,
    this.bestBowling,
    this.averageBowling,
    this.economy,
    this.strikeRateBowling,
    this.fourWickets,
    this.fiveWickets,
    this.catches,
    this.stumpings,
  });

  @override
  String toString() {
    return 'PlayerModel{id: $id, name: $name, dateOfBirth: $dateOfBirth, country: $country, iplTeam: $iplTeam, playingRole: $playingRole, playingTeam: $playingTeam}';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dateOfBirth,
    country,
    iplTeam,
    playingRole,
    playingTeam,
    playerImage,
    battingMatches,
    battingInnings,
    runs,
    highestScore,
    average,
    ballsFaced,
    strikeRate,
    centuries,
    fifties,
    fours,
    sixes,
    bowlingMatches,
    bowlingInnings,
    balls,
    runsConceded,
    wickets,
    bestBowling,
    averageBowling,
    economy,
    strikeRateBowling,
    fourWickets,
    fiveWickets,
    catches,
    stumpings,
  ];
}
