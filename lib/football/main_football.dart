import 'package:flutter/material.dart';
import 'package:untitled5/football/ui_football.dart';
import 'package:untitled5/football/service_football.dart';
import 'package:untitled5/football/api_model_football.dart';

import '../l10n/app_localizations.dart';

class MainFootball extends StatefulWidget {
  const MainFootball({super.key});

  @override
  State<MainFootball> createState() => _MainFootballState();
}

class _MainFootballState extends State<MainFootball> {
  List<FootballLeague> leagues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeagues();
  }

  void fetchLeagues() async {
    try {
      final service = FootballService();
      final data = await service.getLeagues();
      setState(() {
        leagues = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Ligler çekilemedi: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiFootball(
      title: AppLocalizations.of(context)!.leagues,
      leagues: leagues,
      isLoading: isLoading,
    );
  }
}
