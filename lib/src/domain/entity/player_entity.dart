import 'package:combo_dream11/src/data/model/player_model.dart';
import 'package:equatable/equatable.dart';

class PlayerEntity extends Equatable {
  final int? id;
  final String name;
  final DateTime dateOfBirth;
  final String country;
  final String iplTeam;
  final String playingRole;
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

  PlayerEntity({
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

  PlayerModel toModel() {
    return PlayerModel(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      country: country,
      iplTeam: iplTeam,
      playingRole: playingRole,
      playingTeam: playingTeam,
      playerImage: playerImage,
      battingMatches: battingMatches,
      battingInnings: battingInnings,
      runs: runs,
      highestScore: highestScore,
      average: average,
      ballsFaced: ballsFaced,
      strikeRate: strikeRate,
      centuries: centuries,
      fifties: fifties,
      fours: fours,
      sixes: sixes,
      bowlingMatches: bowlingMatches,
      bowlingInnings: bowlingInnings,
      balls: balls,
      runsConceded: runsConceded,
      wickets: wickets,
      bestBowling: bestBowling,
      averageBowling: averageBowling,
      economy: economy,
      strikeRateBowling: strikeRateBowling,
      fourWickets: fourWickets,
      fiveWickets: fiveWickets,
      catches: catches,
      stumpings: stumpings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'country': country,
      'iplTeam': iplTeam,
      'playingRole': playingRole,
      'playingTeam': playingTeam,
      'playerImage': playerImage,
      'battingMatches': battingMatches,
      'battingInnings': battingInnings,
      'runs': runs,
      'highestScore': highestScore,
      'average': average,
      'ballsFaced': ballsFaced,
      'strikeRate': strikeRate,
      'centuries': centuries,
      'fifties': fifties,
      'fours': fours,
      'sixes': sixes,
      'bowlingMatches': bowlingMatches,
      'bowlingInnings': bowlingInnings,
      'balls': balls,
      'runsConceded': runsConceded,
      'wickets': wickets,
      'bestBowling': bestBowling,
      'averageBowling': averageBowling,
      'economy': economy,
      'strikeRateBowling': strikeRateBowling,
      'fourWickets': fourWickets,
      'fiveWickets': fiveWickets,
      'catches': catches,
      'stumpings': stumpings,
    };
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
