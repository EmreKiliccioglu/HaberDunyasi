import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled5/finance/api_model_finance.dart';

import '../l10n/app_localizations.dart';

class UiFinance extends StatefulWidget {
  final String title;
  final String label1;
  final String label2;
  final List<MarketItem> items;
  final bool label2IsPercentage;

  const UiFinance({
    super.key,
    required this.title,
    required this.items,
    required this.label1,
    required this.label2,
    this.label2IsPercentage = false,
  });

  @override
  State<UiFinance> createState() => _UiFinanceState();
}

class _UiFinanceState extends State<UiFinance> {
  bool showAll = false;
  late Timer _timer;
  int topStartIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.items.length > 3) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          topStartIndex = (topStartIndex + 1) % widget.items.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color getValue2Color(double value, BuildContext context) {
    final theme = Theme.of(context);
    if (!widget.label2IsPercentage) return theme.colorScheme.onSurface;
    return value < 0 ? Colors.red : Colors.green;
  }

  String formatValue2(double value) {
    if (widget.label2IsPercentage) {
      return "${value.toStringAsFixed(2)}%";
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayCount = showAll ? widget.items.length : 3;
    final itemsToDisplay = widget.items.take(displayCount).toList();

    final topItems = List<MarketItem>.generate(3, (i) {
      final index = (topStartIndex + i) % widget.items.length;
      return widget.items[index];
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          if (topItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: topItems.map((item) {
                  return Expanded(
                    child: Card(
                      color: Theme.of(context).primaryColor.withAlpha((0.5 * 255).round()),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${widget.label1}: ${item.value1.toStringAsFixed(2)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              "${widget.label2}: ${formatValue2(item.value2)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.label2IsPercentage
                                    ? getValue2Color(item.value2,context)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 16),

          if (itemsToDisplay.isNotEmpty)
           Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.marketData,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

          ...itemsToDisplay.map((item) => Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: InkWell(
              onTap: () {
                debugPrint("${item.name} seçildi!");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${widget.label1}: ${item.value1.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${widget.label2}: ${formatValue2(item.value2)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: getValue2Color(item.value2, context)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),

          if (widget.items.length > 3)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(showAll ? AppLocalizations.of(context)!.showLess : AppLocalizations.of(context)!.showMore),
              ),
            ),
        ],
      ),
    );
  }
}
