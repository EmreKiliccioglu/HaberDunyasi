import 'package:flutter/material.dart';
import 'package:untitled5/football/service_football.dart';
import 'package:untitled5/football/api_model_football.dart';
import 'ui_detail_page.dart';

class DetailPage extends StatefulWidget {
  final String leagueName;
  final String leagueKey;

  const DetailPage({required this.leagueName, required this.leagueKey, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FootballService service = FootballService();
  List<FootballStanding> standings = [];
  List<FootballFixture> fixtures = [];
  List<FootballStats> stats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }


  void fetchAllData() async {
    setState(() { isLoading = true; });

    try {
      final fetchedStandings = await service.getStandings(widget.leagueKey);
      final fetchedFixtures = await service.getFixtures(widget.leagueKey);
      final fetchedStats = await service.getStats(widget.leagueKey);

      setState(() {
        standings = fetchedStandings;
        fixtures = fetchedFixtures;
        stats = fetchedStats;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Veriler çekilemedi: $e");
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {

    final locale = Localizations.localeOf(context).languageCode;
    final league = FootballLeague(league: widget.leagueName, key: widget.leagueKey);
    final localizedTitle = league.getNameByLocale(locale);
    return UiDetailPage(
      title: localizedTitle,
      standings: standings,
      fixtures: fixtures,
      stats: stats,
      isLoading: isLoading,
    );
  }
}
