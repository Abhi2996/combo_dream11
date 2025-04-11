// lib/data/model/enums/player_info_enum.dart

// ... (Keep other enums like PlayerRole, BattingStyle, etc.) ...

enum IndianStadium {
  unknown, // Default/fallback if not listed or known
  wankhedeMumbai,
  chidambaramChennai, // MA Chidambaram (Chepauk)
  edenGardensKolkata,
  chinnaswamyBangalore, // M. Chinnaswamy
  arunJaitleyDelhi, // Feroz Shah Kotla
  rajivGandhiHyderabad, // Rajiv Gandhi International Stadium
  pcaMohali, // PCA IS Bindra Stadium
  sawaiMansinghJaipur,
  narendraModiAhmedabad, // Motera
  ekanaLucknow, // BRSABV Ekana Stadium
  mcaPune, // Maharashtra Cricket Association Stadium
  hpcaDharamsala, // Himachal Pradesh Cricket Association Stadium
  barsaparaGuwahati, // ACA Stadium, Barsapara
  holkarIndore, // Holkar Cricket Stadium
  ysrVisakhapatnam, // Dr. Y.S. Rajasekhara Reddy ACA-VDCA Stadium
  greenParkKanpur, // Sometimes used
  scaSaurashtra, // Saurashtra Cricket Association Stadium, Rajkot
  other, // Catch-all for stadiums not listed
}

// --- Ensure EnumDisplayExtension handles stadiums nicely ---
// You might need to add specific overrides in the existing extension
// if the automatic camelCase splitting isn't perfect.

extension EnumDisplayExtension on Enum {
  String get displayName {
    // --- Add specific overrides for Stadiums ---
    if (this is IndianStadium) {
      switch (this as IndianStadium) {
        case IndianStadium.unknown:
          return 'Unknown';
        case IndianStadium.wankhedeMumbai:
          return 'Wankhede Stadium, Mumbai';
        case IndianStadium.chidambaramChennai:
          return 'MA Chidambaram Stadium, Chennai';
        case IndianStadium.edenGardensKolkata:
          return 'Eden Gardens, Kolkata';
        case IndianStadium.chinnaswamyBangalore:
          return 'M. Chinnaswamy Stadium, Bangalore';
        case IndianStadium.arunJaitleyDelhi:
          return 'Arun Jaitley Stadium, Delhi';
        case IndianStadium.rajivGandhiHyderabad:
          return 'Rajiv Gandhi Intl. Stadium, Hyderabad';
        case IndianStadium.pcaMohali:
          return 'PCA IS Bindra Stadium, Mohali';
        case IndianStadium.sawaiMansinghJaipur:
          return 'Sawai Mansingh Stadium, Jaipur';
        case IndianStadium.narendraModiAhmedabad:
          return 'Narendra Modi Stadium, Ahmedabad';
        case IndianStadium.ekanaLucknow:
          return 'BRSABV Ekana Stadium, Lucknow';
        case IndianStadium.mcaPune:
          return 'MCA Stadium, Pune';
        case IndianStadium.hpcaDharamsala:
          return 'HPCA Stadium, Dharamsala';
        case IndianStadium.barsaparaGuwahati:
          return 'Barsapara Stadium, Guwahati';
        case IndianStadium.holkarIndore:
          return 'Holkar Cricket Stadium, Indore';
        case IndianStadium.ysrVisakhapatnam:
          return 'Dr. YSR ACA-VDCA Stadium, Visakhapatnam';
        case IndianStadium.greenParkKanpur:
          return 'Green Park Stadium, Kanpur';
        case IndianStadium.scaSaurashtra:
          return 'SCA Stadium, Rajkot';
        case IndianStadium.other:
          return 'Other Stadium';
        // No default needed as switch covers all enum values
      }
    }

    // General case: split by camelCase and capitalize
    final name = this.name;
    if (name.isEmpty) return '';
    final spacedName = name.replaceAllMapped(
      RegExp(r'(?<=[a-z])([A-Z])'),
      (match) => ' ${match.group(1)}',
    );
    return spacedName[0].toUpperCase() + spacedName.substring(1);
  }
}
