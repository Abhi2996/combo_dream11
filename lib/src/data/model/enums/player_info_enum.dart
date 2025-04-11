// Player roles
// enum PlayerRole { batsman, bowler, allRounder, wicketKeeper }

// Batting styles
enum BattingStyle { rightHanded, leftHanded, unknown }

// Bowling styles
enum BowlingStyle {
  rightArmFast,
  rightArmMedium,
  leftArmFast,
  leftArmMedium,
  spin,
  none,
  unknown,
}

//
//
enum PlayerIplTeam {
  chennaiSuperKings,
  mumbaiIndians,
  royalChallengersBangalore,
  kolkataKnightRiders,
  rajasthanRoyals,
  delhiCapitals,
  sunrisersHyderabad,
  lucknowSuperGiants,
  gujaratTitans,
  punjabKings,
  none,
  unknown,
}

//
enum InternationalTeam {
  none, // Represents no international team affiliation / default unselected
  afghanistan,
  australia,
  bangladesh,
  canada, // Associate
  england,
  india,
  ireland,
  namibia, // Associate
  nepal, // Associate
  netherlands, // Associate
  newZealand,
  oman, // Associate
  pakistan,
  papuaNewGuinea, // Associate
  scotland, // Associate
  southAfrica,
  sriLanka,
  uganda, // Associate (Notable recent T20 WC qualification)
  unitedArabEmirates, // Associate
  usa, // Associate
  westIndies, // Represents Cricket West Indies (multiple nations)
  zimbabwe,
  other, // Catch-all for teams not listed
}
