import 'package:equatable/equatable.dart';

/// Enum for types of cricket matches
enum MatchType { IPL, TEST, ODI, T20I }

/// Convert string to MatchType enum
MatchType matchTypeFromString(String type) {
  return MatchType.values.firstWhere(
    (e) => e.toString().split('.').last == type,
    orElse: () => MatchType.ODI, // default fallback if needed
  );
}

/// Convert MatchType enum to string
String matchTypeToString(MatchType type) {
  return type.toString().split('.').last;
}

/// CareerStats class to hold batting and bowling statistics
class CareerStats extends Equatable {
  final String? id;
  final MatchType matchType;
  final String season;

  // Batting stats
  final int? matches;
  final int? notOuts;
  final int? runs;
  final String? highestScore;
  final double? average;
  final int? ballsFaced;
  final double? strikeRate;
  final int? hundreds;
  final int? fifties;
  final int? fours;
  final int? sixes;
  final int? catches;
  final int? stumpings;

  // Bowling stats
  final int? ballsBowled;
  final int? runsConceded;
  final int? wickets;
  final String? bestBowlingMatch;
  final double? bowlingAverage;
  final double? economyRate;
  final double? bowlingStrikeRate;
  final int? fourWickets;
  final int? fiveWickets;

  const CareerStats({
    this.id,
    required this.matchType,
    required this.season,
    required this.matches,
    required this.notOuts,
    required this.runs,
    required this.highestScore,
    required this.average,
    required this.ballsFaced,
    required this.strikeRate,
    required this.hundreds,
    required this.fifties,
    required this.fours,
    required this.sixes,
    required this.catches,
    required this.stumpings,
    required this.ballsBowled,
    required this.runsConceded,
    required this.wickets,
    required this.bestBowlingMatch,
    required this.bowlingAverage,
    required this.economyRate,
    required this.bowlingStrikeRate,
    required this.fourWickets,
    required this.fiveWickets,
  });

  /// Factory constructor to create CareerStats from JSON
  factory CareerStats.fromJson(Map<String, dynamic> json) {
    return CareerStats(
      id: json['id'],
      matchType: matchTypeFromString(json['matchType']),
      season: json['season'],
      matches: json['matches'],
      notOuts: json['notOuts'],
      runs: json['runs'],
      highestScore: json['highestScore'].toString(),
      average: (json['average'] as num).toDouble(),
      ballsFaced: json['ballsFaced'],
      strikeRate: (json['strikeRate'] as num).toDouble(),
      hundreds: json['hundreds'],
      fifties: json['fifties'],
      fours: json['fours'],
      sixes: json['sixes'],
      catches: json['catches'],
      stumpings: json['stumpings'],
      ballsBowled: json['ballsBowled'],
      runsConceded: json['runsConceded'],
      wickets: json['wickets'],
      bestBowlingMatch: json['bestBowlingMatch'].toString(),
      bowlingAverage: (json['bowlingAverage'] as num).toDouble(),
      economyRate: (json['economyRate'] as num).toDouble(),
      bowlingStrikeRate: (json['bowlingStrikeRate'] as num).toDouble(),
      fourWickets: json['fourWickets'],
      fiveWickets: json['fiveWickets'],
    );
  }

  /// Convert CareerStats to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchType': matchTypeToString(matchType),
      'season': season,
      'matches': matches,
      'notOuts': notOuts,
      'runs': runs,
      'highestScore': highestScore,
      'average': average,
      'ballsFaced': ballsFaced,
      'strikeRate': strikeRate,
      'hundreds': hundreds,
      'fifties': fifties,
      'fours': fours,
      'sixes': sixes,
      'catches': catches,
      'stumpings': stumpings,
      'ballsBowled': ballsBowled,
      'runsConceded': runsConceded,
      'wickets': wickets,
      'bestBowlingMatch': bestBowlingMatch,
      'bowlingAverage': bowlingAverage,
      'economyRate': economyRate,
      'bowlingStrikeRate': bowlingStrikeRate,
      'fourWickets': fourWickets,
      'fiveWickets': fiveWickets,
    };
  }

  @override
  List<Object?> get props => [
    matchType,
    season,
    matches,
    notOuts,
    runs,
    highestScore,
    average,
    ballsFaced,
    strikeRate,
    hundreds,
    fifties,
    fours,
    sixes,
    catches,
    stumpings,
    ballsBowled,
    runsConceded,
    wickets,
    bestBowlingMatch,
    bowlingAverage,
    economyRate,
    bowlingStrikeRate,
    fourWickets,
    fiveWickets,
  ];
}
