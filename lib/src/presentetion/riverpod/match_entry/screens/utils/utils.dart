import 'package:combo_dream11/src/data/model/enums/enum_other.dart';
import 'package:combo_dream11/src/data/model/enums/player_info_enum.dart';
import 'package:intl/intl.dart';

int? calculateRootNumber(DateTime? date) {
  if (date == null) return null;
  int day = date.day;
  int sum = day;
  while (sum > 9) {
    sum = sum.toString().split('').map(int.parse).reduce((a, b) => a + b);
  }
  return sum;
}

int? calculateDestinyNumber(DateTime? date) {
  if (date == null) return null;
  String dateStr = DateFormat('ddMMyyyy').format(date);
  int sum = dateStr.split('').map(int.parse).reduce((a, b) => a + b);
  while (sum > 9 && sum != 11 && sum != 22 && sum != 33) {
    sum = sum.toString().split('').map(int.parse).reduce((a, b) => a + b);
  }
  return sum;
}

String formatDate(DateTime? date) {
  if (date == null) return 'Not Set';
  return DateFormat('dd MMM yyyy').format(date);
}

String getSortOptionDisplayName(SortOption option) {
  switch (option) {
    case SortOption.highestScore:
      return 'Highest Score';
    case SortOption.lowestScore:
      return 'Lowest Score';
    case SortOption.mostWickets:
      return 'Most Wickets';
    case SortOption.bestEconomy:
      return 'Best Economy (Lowest)';
    case SortOption.bestBattingSR:
      return 'Best Batting Strike Rate';
    case SortOption.bestBowlingSR:
      return 'Best Bowling Strike Rate (Lowest)';
  }
}

//
const List<String> nationalTeams = [
  'India',
  'Australia',
  'England',
  'Pakistan',
  'South Africa',
  'New Zealand',
  'Sri Lanka',
  'Bangladesh',
  'Afghanistan',
  'West Indies',
  'Zimbabwe',
  'Ireland',
  'Netherlands',
  'Scotland',
];

extension PlayerIplTeamExtension on PlayerIplTeam {
  String get displayName {
    switch (this) {
      case PlayerIplTeam.chennaiSuperKings:
        return 'Chennai Super Kings';
      case PlayerIplTeam.mumbaiIndians:
        return 'Mumbai Indians';
      case PlayerIplTeam.royalChallengersBangalore:
        return 'Royal Challengers Bangalore';
      case PlayerIplTeam.kolkataKnightRiders:
        return 'Kolkata Knight Riders';
      case PlayerIplTeam.rajasthanRoyals:
        return 'Rajasthan Royals';
      case PlayerIplTeam.delhiCapitals:
        return 'Delhi Capitals';
      case PlayerIplTeam.sunrisersHyderabad:
        return 'Sunrisers Hyderabad';
      case PlayerIplTeam.lucknowSuperGiants:
        return 'Lucknow Super Giants';
      case PlayerIplTeam.gujaratTitans:
        return 'Gujarat Titans';
      case PlayerIplTeam.punjabKings:
        return 'Punjab Kings';
      case PlayerIplTeam.unknown:
        return 'unknown';
      case PlayerIplTeam.none:
        return 'none';
    }
  }
}
