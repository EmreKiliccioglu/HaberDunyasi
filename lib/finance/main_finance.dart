import 'package:flutter/material.dart' hide MenuBar;
import 'package:untitled5/finance/convert_page.dart';
import 'package:untitled5/finance/ui_finance.dart';
import 'package:untitled5/finance/service_finance.dart';
import 'package:untitled5/finance/api_model_finance.dart';
import 'package:untitled5/core/menu.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../l10n/app_localizations.dart';


class MainFinance extends StatefulWidget {
  const MainFinance({super.key});

  @override
  State<MainFinance> createState() => _MainFinanceState();
}

class _MainFinanceState extends State<MainFinance> {
  final MarketService _marketService = MarketService();

  late Future<List<MarketItem>> _currencyFuture;
  late Future<List<MarketItem>> _goldFuture;
  late Future<List<MarketItem>> _cryptoFuture;
  late Future<List<MarketItem>> _emtiaFuture;

  @override
  void initState() {
    super.initState();
    _currencyFuture = _marketService.fetch(dotenv.env['CURRENCY_URL'] ?? '', 'currency');
    _goldFuture = _marketService.fetch(dotenv.env['GOLDPRICE_URL'] ?? '', 'gold');
    _cryptoFuture = _marketService.fetch(dotenv.env['CRIPTOPRICE_URL'] ?? '', 'crypto');
    _emtiaFuture = _marketService.fetch(dotenv.env['EMTIAPRICE_URL'] ?? '', 'emtia');
  } //uygulama açılır açılmaz veri çekilir

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar.build(title: AppLocalizations.of(context)!.finance, context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const ConvertPageContent(),
                        ),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.currencyConverter),
                ),
              ),
            ),

            FutureBuilder<List<MarketItem>>(
              future: _currencyFuture,
              builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
               if (snapshot.hasError) {
                 debugPrint("Döviz verisi alınamadı: ${snapshot.error}");
                 return const SizedBox.shrink();
               }
               final items = snapshot.data ?? [];
                return UiFinance(title: AppLocalizations.of(context)!.exchangeRates, label1: AppLocalizations.of(context)!.buying ,label2: AppLocalizations.of(context)!.selling, items: items,label2IsPercentage: false,
                );
              },
            ),

            FutureBuilder<List<MarketItem>>(
              future: _goldFuture,
              builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Altın verisi alınamadı: ${snapshot.error}"));
                }
                final items = snapshot.data ?? [];
                return UiFinance(title: AppLocalizations.of(context)!.goldPrices, label1: AppLocalizations.of(context)!.buying,label2: AppLocalizations.of(context)!.selling,items: items, label2IsPercentage: false,
                );
              },
            ),

            FutureBuilder<List<MarketItem>>(
              future: _cryptoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Kripto verisi alınamadı: ${snapshot.error}"));
                }
                final items = snapshot.data ?? [];
                return UiFinance(title: AppLocalizations.of(context)!.cryptocurrencies, label1: AppLocalizations.of(context)!.price, label2: AppLocalizations.of(context)!.changeRate,items: items,label2IsPercentage: true, );
              },
            ),

            FutureBuilder<List<MarketItem>>(
              future: _emtiaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Emtia verisi alınamadı: ${snapshot.error}"));
                }
                final items = snapshot.data ?? [];
                return UiFinance(title: AppLocalizations.of(context)!.commodities, label1:AppLocalizations.of(context)!.selling, label2: AppLocalizations.of(context)!.changeRate, items: items,label2IsPercentage: true, );
              },
            ),
          ],
        ),
      ),
    );
  }
}
