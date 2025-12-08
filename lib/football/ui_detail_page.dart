import 'package:flutter/material.dart' hide MenuBar;
import 'package:untitled5/core/menu.dart';
import 'package:untitled5/football/api_model_football.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

class UiDetailPage extends StatelessWidget {
  final String title;
  final List<FootballStanding> standings;
  final List<FootballFixture> fixtures;
  final List<FootballStats> stats;
  final bool isLoading;

  const UiDetailPage({
    required this.title,
    this.standings = const [],
    this.fixtures = const [],
    this.stats = const [],
    this.isLoading = false,
    super.key,
  });

  String formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  String formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MenuBar.build(title: title, context: context),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Material(
              color: theme.scaffoldBackgroundColor,
              child: TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.textTheme.bodyMedium!.color,
                indicatorColor: theme.colorScheme.primary,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.standings),
                  Tab(text: AppLocalizations.of(context)!.fixture),
                  Tab(text: AppLocalizations.of(context)!.statistics),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Standings tab
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double tableWidth = 6 * 80.0;
                      if (tableWidth < constraints.maxWidth) {
                        tableWidth = constraints.maxWidth;
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: tableWidth),
                          child: SizedBox(
                            width: tableWidth,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 16,
                                headingRowColor: WidgetStateProperty.resolveWith(
                                      (states) => isDark
                                      ? Colors.grey[800]
                                      : Colors.blue.shade300,
                                ),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.position,
                                        style: TextStyle(
                                            color:
                                            theme.textTheme.bodyMedium!.color),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.team,
                                        style: TextStyle(
                                            color:
                                            theme.textTheme.bodyMedium!.color),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.played,
                                        style: TextStyle(
                                            color:
                                            theme.textTheme.bodyMedium!.color),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.wins,
                                        style: TextStyle(
                                            color:
                                            theme.textTheme.bodyMedium!.color),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.loses,
                                        style: TextStyle(
                                            color:
                                            theme.textTheme.bodyMedium!.color),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        AppLocalizations.of(context)!.points,
                                        style: TextStyle(
                                            color:
                                            theme.textTheme.bodyMedium!.color),
                                      )),
                                ],
                                rows: standings.map((item) {
                                  int index = standings.indexOf(item);
                                  Color? rowColor;
                                  if (index == 0) {
                                    rowColor =
                                    isDark ? Color(0xFF388E3C) : Colors.green.shade100;
                                  } else if (index == 1) {
                                    rowColor =
                                    isDark ? Color(0xFF1976D2) : Colors.blue.shade100;
                                  } else if (index == 2) {
                                    rowColor =
                                    isDark ? Color(0xFF6A1B9A) : Colors.purple.shade100;
                                  }
                                  return DataRow(
                                    color: WidgetStateProperty.resolveWith(
                                            (states) => rowColor ?? Colors.transparent),
                                    cells: [
                                      DataCell(Text(item.rank,
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium!.color))),
                                      DataCell(Text(item.team,
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium!.color))),
                                      DataCell(Text(item.play,
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium!.color))),
                                      DataCell(Text(item.win,
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium!.color))),
                                      DataCell(Text(item.lose,
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium!.color))),
                                      DataCell(Text(item.point,
                                          style: TextStyle(
                                              color: theme.textTheme.bodyMedium!.color))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Fixtures tab
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: fixtures.length,
                    itemBuilder: (context, index) {
                      final item = fixtures[index];
                      final bool isPlayed =
                      !(item.score.isEmpty || item.score == 'undefined-undefined');

                      return Card(
                        color: theme.cardColor,
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: isPlayed
                                            ? [
                                          TextSpan(
                                            text: item.home,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: theme.textTheme.bodyMedium!.color,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " ${item.score} ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          TextSpan(
                                            text: item.away,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: theme.textTheme.bodyMedium!.color,
                                            ),
                                          ),
                                        ]
                                            : [
                                          TextSpan(
                                            text: item.home,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: theme.textTheme.bodyMedium!.color,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " vs ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          TextSpan(
                                            text: item.away,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: theme.textTheme.bodyMedium!.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.date}: ${formatDate(item.date)}",
                                    style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.time}: ${formatTime(item.date)}",
                                    style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (!isPlayed)
                                Text(
                                  "${AppLocalizations.of(context)!.score}: ${AppLocalizations.of(context)!.notPlayedYet}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: theme.textTheme.bodyMedium!.color,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Stats tab
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final item = stats[index];
                      return Card(
                        color: theme.cardColor,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.textTheme.bodyMedium!.color,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.sports_soccer,
                                          size: 30, color: theme.iconTheme.color),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${AppLocalizations.of(context)!.goal}: ${item.goals}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: theme.textTheme.bodyMedium!.color,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

