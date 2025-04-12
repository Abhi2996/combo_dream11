import 'package:combo_dream11/src/data/model/career_stats.dart';
import 'package:combo_dream11/src/data/model/player_info.dart';

/// Defines the role of the player

//
//
//
final List<PlayerInfo> mockPlayers = [
  PlayerInfo(
    name: 'Virat Kohli',
    birthDate: DateTime(1988, 11, 5),
    birthPlace: 'Delhi, India',
    nickname: 'King Kohli',
    role: 'Batsman',
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm medium',
    internationalTeam: 'India',
    iplTeam: 'Royal Challengers Bangalore',
    cricketStats: [
      const CareerStats(
        matchType: MatchType.IPL, // Example format
        season: "2023", // Example season
        matches: 12, // Given
        notOuts:
            2, // Adjusted: 7 seems high for 12 matches if runs are 46, let's use 2
        runs:
            46, // Given: Runs are quite low, average/SR seem inconsistent with this
        highestScore:
            '15*', // Adjusted: HS 76 inconsistent with total 46 runs, let's use 15*
        average: 4.6, // Adjusted: (46 / (12 innings - 2 notOuts)) = 4.6
        ballsFaced: 67, // Given
        strikeRate: 68.66, // Adjusted: (46 / 67 * 100) = 68.66
        hundreds: 0, // Adjusted: Inconsistent with runs=46
        fifties: 0, // Adjusted: Inconsistent with runs=46
        fours: 5, // Dummy value
        sixes: 1, // Dummy value
        catches: 8, // Dummy value
        stumpings: 1, // Dummy value (less common)
        // Bowling Stats (Assuming this player also bowled)
        ballsBowled: 180, // Dummy value (e.g., 30 overs)
        runsConceded: 210, // Dummy value
        wickets: 9, // Dummy value
        bestBowlingMatch: "3/25", // Dummy value (String)
        bowlingAverage: 23.33, // Adjusted: (210 / 9) = 23.33
        economyRate: 7.00, // Adjusted: (210 / (180 / 6)) = 7.00
        bowlingStrikeRate: 20.0, // Adjusted: (180 / 9) = 20.0
        fourWickets: 0, // Dummy value
        fiveWickets: 0, // Dummy value
      ),
      // You can add more CareerStats objects for other MatchTypes (TEST, ODI, T20I)
      const CareerStats(
        matchType: MatchType.ODI,
        season: "Overall", // Or specific year
        matches: 5,
        notOuts: 1,
        runs: 150,
        highestScore: '75',
        average: 37.5, // 150 / (5-1)
        ballsFaced: 160,
        strikeRate: 93.75, // 150 / 160 * 100
        hundreds: 0,
        fifties: 1,
        fours: 12,
        sixes: 4,
        catches: 3,
        stumpings: 0,
        // Bowling Stats
        ballsBowled: 60, // 10 overs
        runsConceded: 55,
        wickets: 2,
        bestBowlingMatch: "1/20",
        bowlingAverage: 27.5, // 55 / 2
        economyRate: 5.5, // 55 / (60/6)
        bowlingStrikeRate: 30.0, // 60 / 2
        fourWickets: 0,
        fiveWickets: 0,
      ),
      // Add TEST and T20I similarly if needed
      const CareerStats(
        matchType: MatchType.TEST,
        season: "Overall",
        matches: 2,
        notOuts: 0,
        runs: 35,
        highestScore: '25',
        average: 17.5, // 35 / 2 innings (assuming 2 inn)
        ballsFaced: 80,
        strikeRate: 43.75,
        hundreds: 0,
        fifties: 0,
        fours: 4,
        sixes: 0,
        catches: 1,
        stumpings: 0,
        ballsBowled: 0, // Might not bowl in Tests
        runsConceded: 0,
        wickets: 0,
        bestBowlingMatch: "-",
        bowlingAverage: null, // Use null for undefined averages/rates
        economyRate: null,
        bowlingStrikeRate: null,
        fourWickets: 0,
        fiveWickets: 0,
      ),
      const CareerStats(
        matchType: MatchType.T20I,
        season: "Overall",
        matches: 10,
        notOuts: 3,
        runs: 180,
        highestScore: '45*',
        average: 25.71, // 180 / (10-3)
        ballsFaced: 120,
        strikeRate: 150.0,
        hundreds: 0,
        fifties: 1,
        fours: 15,
        sixes: 8,
        catches: 5,
        stumpings: 0,
        ballsBowled: 24, // 4 overs
        runsConceded: 30,
        wickets: 1,
        bestBowlingMatch: "1/30",
        bowlingAverage: 30.0,
        economyRate: 7.5, // 30 / (24/6)
        bowlingStrikeRate: 24.0,
        fourWickets: 0,
        fiveWickets: 0,
      ),
    ],
  ),
  PlayerInfo(
    name: 'Rohit Sharma',
    birthDate: DateTime(1987, 4, 30),
    birthPlace: 'Nagpur, India',
    nickname: 'Hitman',
    role: 'Batsman',
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm offbreak',
    internationalTeam: 'India',
    iplTeam: 'Mumbai Indians',
  ),
  PlayerInfo(
    name: 'Jasprit Bumrah',
    birthDate: DateTime(1993, 12, 6),
    birthPlace: 'Ahmedabad, India',
    nickname: 'Boom Boom',
    role: 'Bowler',
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm fast',
    internationalTeam: 'India',
    iplTeam: 'Mumbai Indians',
  ),
  PlayerInfo(
    name: 'MS Dhoni',
    birthDate: DateTime(1981, 7, 7),
    birthPlace: 'Ranchi, India',
    nickname: 'Captain Cool',
    role: 'Wicketkeeper',
    battingStyle: 'Right-hand bat',
    bowlingStyle: 'Right-arm medium',
    internationalTeam: 'India',
    iplTeam: 'Chennai Super Kings',
  ),
];
