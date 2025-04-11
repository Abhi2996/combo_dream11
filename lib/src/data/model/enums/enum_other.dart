enum PlayerRole {
  batsman,
  bowler,
  allrounder,
  wicketKeeper, // Make sure this matches roles in your data
  unknown,
}

enum SortOption {
  highestScore,
  lowestScore,
  mostWickets,
  bestEconomy, // Lower is better
  bestBattingSR, // Higher is better
  bestBowlingSR, // Lower is better
}
