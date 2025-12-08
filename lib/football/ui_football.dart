import 'package:flutter/material.dart' hide MenuBar;
import 'package:untitled5/football/detail_page.dart';
import 'package:untitled5/core/menu.dart';
import 'package:untitled5/football/api_model_football.dart';

import '../l10n/app_localizations.dart';

class UiFootball extends StatelessWidget {
  final String title;
  final List<FootballLeague> leagues;
  final bool isLoading;

  const UiFootball({
    required this.title,
    required this.leagues,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar.build(title: title, context: context),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : leagues.isEmpty
          ? Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: TextStyle(fontSize: 20),
        ),
      )

          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final league = leagues[index];

          return InkWell(
            onTap: () {
              debugPrint("Tıklanan Lig: ${league.key}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    leagueKey: league.key,
                    leagueName: league.league,
                  ),
                ),
              );
            },

            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        league.getNameByLocale(Localizations.localeOf(context).languageCode),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
