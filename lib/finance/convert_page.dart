import 'package:flutter/material.dart';
import 'package:untitled5/finance/service_finance.dart';
import 'package:untitled5/finance/api_model_finance.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../l10n/app_localizations.dart';

class ConvertPageContent extends StatefulWidget {
  const ConvertPageContent({super.key});

  @override
  State<ConvertPageContent> createState() => _ConvertPageContentState();
}

class _ConvertPageContentState extends State<ConvertPageContent> {
  final TextEditingController _amountController = TextEditingController(); // Kullanıcının girdiği miktar
  String? _selectedCurrency; // Kullanıcının seçtiği para birimi
  double? _convertedBuying; // Hesaplanan alış değeri
  double? _convertedSelling; // Hesaplanan satış değeri

  final MarketService _marketService = MarketService();
  late Future<List<MarketItem>> _convertFuture;

  @override
  void initState() {
    super.initState();
    _convertFuture = _marketService.fetch(
      dotenv.env['CONVERTER_URL'] ?? '',
      'converter',
    );
  }
  //Çevirme işlemi yapan fonksiyon
  void _convert(List<MarketItem> currencies) {
    if (_amountController.text.isEmpty || _selectedCurrency == null) return;

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null) return;

    final selected = currencies.firstWhere((c) => c.name == _selectedCurrency);

    if (selected.value1 == 0 || selected.value2 == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Döviz alış veya satış fiyatı sıfır olamaz")),
      );
      return;
    }

    setState(() {
      _convertedBuying = amount / selected.value1;
      _convertedSelling = amount / selected.value2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<MarketItem>>(
      future: _convertFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Veri alınamadı: ${snapshot.error}"));
        }

        final currencies = snapshot.data ?? [];
        _selectedCurrency ??= currencies.isNotEmpty ? currencies.first.name : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: theme.cardColor,
                // Girilen miktar için textField
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.tlAmount,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.money, color: theme.primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: theme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //Açılır liste ile para birimi seçimi
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: currencies
                        .map((c) => DropdownMenuItem(
                      value: c.name, // Listeden seçtiğimiz birimin değeri
                      child: Text(c.name, style: theme.textTheme.bodyMedium), //Kullanıcıya gösterilen
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value; // Yeni seçilen değer
                        _convertedBuying = null; // Alışı sıfırla
                        _convertedSelling = null; // Satışı sıfırla
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Hesaplama butonu
              ElevatedButton(
                onPressed: () => _convert(currencies),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.calculate,
                  style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              if (_convertedBuying != null && _convertedSelling != null) //Butona basılmadıysa kartı gösterme
                //Hesaplama sonuçlarını gösteren kart
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.primaryColor,
                      width: 2,
                    ),
                  ),
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "${_convertedBuying!.toStringAsFixed(2)} ${_selectedCurrency!.split(' ')[0]} ${AppLocalizations.of(context)!.buying}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent.shade400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${_convertedSelling!.toStringAsFixed(2)} ${_selectedCurrency!.split(' ')[0]} ${AppLocalizations.of(context)!.selling}",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
