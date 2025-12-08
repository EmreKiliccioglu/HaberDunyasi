import 'package:flutter/material.dart' hide MenuBar;
import 'package:untitled5/core/menu.dart';
import 'package:untitled5/weather/api_model_weather.dart';
import 'package:untitled5/core/cities.dart';

import '../l10n/app_localizations.dart';

class UiWeather extends StatefulWidget {
  final String title;
  final List<Weather> weatherList;
  final bool isLoading;
  final String selectedCity;
  final ValueChanged<String> onCitySubmitted;
  final bool userLoggedIn;
  final String favoriteCity;
  final Function(String city) onFavoritePressed;

  const UiWeather({
    required this.title,
    this.weatherList = const [],
    this.isLoading = false,
    required this.selectedCity,
    required this.onCitySubmitted,
    required this.userLoggedIn,
    required this.favoriteCity,
    required this.onFavoritePressed,
    super.key,
  });

  @override
  State<UiWeather> createState() => _UiWeatherState();
}

class _UiWeatherState extends State<UiWeather> {
  late String selectedCity;
  TextEditingController controller = TextEditingController();
  bool dropdownOpen = false;
  List<String> filteredCities = List.from(turkiyeSehirleri);

  @override
  void initState() {
    super.initState();
    selectedCity = widget.selectedCity;
    controller.text = selectedCity;
  }

  void filterCities(String input) {
    setState(() {
      filteredCities = turkiyeSehirleri
          .where((city) => city.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  void selectCity(String city) {
    setState(() {
      selectedCity = city;
      controller.text = city;
      dropdownOpen = false;
    });
    widget.onCitySubmitted(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar.build(title: widget.title, context: context),
      body: widget.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // TextField + dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              dropdownOpen = !dropdownOpen;
                            });
                          },
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.cityHint,
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              setState(() {
                                dropdownOpen = true;
                                controller.clear();
                                filteredCities = List.from(turkiyeSehirleri);
                              });
                            },
                            onChanged: (value) {
                              filterCities(value);
                              if (!dropdownOpen) {
                                setState(() {
                                  dropdownOpen = true;
                                });
                              }
                            },
                          ),

                        ),
                      ),
                      Icon(dropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    ],
                  ),
                ),
                // Dropdown listesi
                if (dropdownOpen)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: Card(
                      margin: const EdgeInsets.only(top: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) {
                            final city = filteredCities[index];
                            return ListTile(
                              title: Text(city),

                              trailing: widget.userLoggedIn
                                  ? IconButton(
                                icon: Icon(
                                  widget.favoriteCity == city ? Icons.star : Icons.star_border,
                                  color: widget.favoriteCity == city ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () {
                                  widget.onFavoritePressed(city);
                                },
                              )
                                  : null,

                              onTap: () => selectCity(city),
                            );

                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Hava durumu listesi
          Expanded(
            child: widget.weatherList.isEmpty
                ? Center(
              child: Text(
                AppLocalizations.of(context)!.noData,
                style: const TextStyle(fontSize: 20),
              ),
            )
                : ListView.builder(
              itemCount: widget.weatherList.length,
              itemBuilder: (context, index) {
                final weather = widget.weatherList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weather.getDayByLocale(
                                      Localizations.localeOf(context).languageCode),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("${weather.degree}°C",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Image.network(
                              weather.icon,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.cloud, size: 60);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          weather
                              .getTextByLocale(Localizations.localeOf(context).languageCode)
                              .toUpperCase(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Min: ${weather.min}°C"),
                            Text("Max: ${weather.max}°C"),
                            Text("${AppLocalizations.of(context)!.night}: ${weather.night}°C"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${AppLocalizations.of(context)!.humidity}: ${weather.humidity}%"),
                            Builder(
                              builder: (context) {
                                List<String> dateParts = weather.date.split('/');
                                String formattedDate =
                                    "${dateParts[1]}/${dateParts[0]}/${dateParts[2]}";
                                return Text(
                                  "${AppLocalizations.of(context)!.date} : $formattedDate",
                                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
