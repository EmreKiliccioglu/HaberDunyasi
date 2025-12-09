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
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);

    if (widget.items.length > 3) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_currentPage < widget.items.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Color getValue2Color(double value, BuildContext context) {
    if (!widget.label2IsPercentage) return Theme.of(context).colorScheme.onSurface;
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

          // KAYAN KARTLAR
          if (widget.items.isNotEmpty)
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  double scale = 1.0;
                  if (_pageController.position.haveDimensions) {
                    scale = (_pageController.page! - index).abs() * 0.1;
                    scale = 1 - scale;
                    if (scale < 0.8) scale = 0.8;
                  }
                  return Transform.scale(
                    scale: scale,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade50, Colors.blue.shade200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${widget.label1}: ${item.value1.toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${widget.label2}: ${formatValue2(item.value2)}",
                                  style: TextStyle(
                                    color: widget.label2IsPercentage
                                        ? getValue2Color(item.value2, context)
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          // ALT LİSTE
          if (itemsToDisplay.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.marketData,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

          // SHOW MORE -- SHOW LESS
          if (widget.items.length > 3)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(showAll
                    ? AppLocalizations.of(context)!.showLess
                    : AppLocalizations.of(context)!.showMore),
              ),
            ),
        ],
      ),
    );
  }
}
