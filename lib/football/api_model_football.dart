//Ligler
class FootballLeague {
  final String league;
  final String key;

  FootballLeague({
    required this.league,
    required this.key,
  });

  factory FootballLeague.fromJson(Map<String, dynamic> json) {
    return FootballLeague(
      league: json["league"]?.toString() ?? "",
      key: json["key"]?.toString() ?? "",
    );
  }

  String getNameByLocale(String locale) {
    const leagueMap = {
      "Trendyol Süper Lig": {"tr": "Trendyol Süper Lig", "en": "Trendyol Super League"},
      "Trendyol 1. Lig": {"tr": "Trendyol 1. Lig", "en": "Trendyol 1. League"},
      "İngiltere Premier Ligi": {"tr": "İngiltere Premier Lig", "en": "England Premier League"},
      "UEFA Konferans Ligi": {"tr": "UEFA Konferans Ligi", "en": "UEFA Conferance League"},
      "Almanya Bundesliga": {"tr": "Almanya Bundesliga", "en": "Germany Bundesliga"},
      "Fransa Ligue 1": {"tr": "Fransa Ligue 1", "en": "France Ligue 1"},
      "İspanya La Liga": {"tr": "İspanya La Liga", "en": "Spain La Liga"},
      "İtalya Serie A": {"tr": "İtalya Serie A", "en": "Italy Serie A"},
      "İngiltere Championship": {"tr": "İngiltere Championship", "en": "England Championship"},
      "Fransa Ligue 2": {"tr": "Fransa Ligue 2", "en": "France Ligue 2"},
      "Avrupa Şampiyonası": {"tr": "Avrupa Şampiyonası", "en": "European Championship"},
    };

    if (!leagueMap.containsKey(league)) return league;
    return leagueMap[league]![locale] ?? league;
  }
}
//Puan Durumu
class FootballStanding {
  final String rank;
  final String lose;
  final String win;
  final String play;
  final String point;
  final String team;

  FootballStanding({
    required this.rank,
    required this.lose,
    required this.win,
    required this.play,
    required this.point,
    required this.team,
  });

  factory FootballStanding.fromJson(Map<String, dynamic> json) {
    return FootballStanding(
      rank: json['rank']?.toString() ?? "0",
      lose: json['lose']?.toString() ?? "0",
      win: json['win']?.toString() ?? "0",
      play: json['play']?.toString() ?? "0",
      point: json['point']?.toString() ?? "0",
      team: json['team']?.toString() ?? "",
    );
  }
}
//Fikstür
class FootballFixture {
  final String score;
  final String date;
  final String home;
  final String away;

  FootballFixture({
    required this.score,
    required this.date,
    required this.home,
    required this.away,
  });

  factory FootballFixture.fromJson(Map<String, dynamic> json) {
    String rawScore = json['skor']?.toString() ?? "";

    return FootballFixture(
      score: rawScore,
      date: json['date']?.toString() ?? "",
      home: json['home']?.toString() ?? "",
      away: json['away']?.toString() ?? "",
    );
  }
}

//İstatistikler
class FootballStats {
  final String play;
  final String goals;
  final String name;

  FootballStats({
    required this.play,
    required this.goals,
    required this.name,
  });

  factory FootballStats.fromJson(Map<String, dynamic> json) {
    return FootballStats(
      play: json['play']?.toString() ?? "0",
      goals: json['goals']?.toString() ?? "0",
      name: json['name']?.toString() ?? "",
    );
  }
}


