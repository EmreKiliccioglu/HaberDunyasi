import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/weather/ui_weather.dart';
import 'package:untitled5/weather/service_weather.dart';
import 'package:untitled5/weather/api_model_weather.dart';

import '../core/cities.dart';
import '../l10n/app_localizations.dart';

class MainWeather extends StatefulWidget {
  const MainWeather({super.key});

  @override
  State<MainWeather> createState() => _MainWeatherState();
}

class _MainWeatherState extends State<MainWeather> {
  late String title = AppLocalizations.of(context)!.weather;

  List<Weather> weatherList = [];
  bool isLoading = true;

  String? selectedCity;
  String? favoriteCity;

  bool initializing = true;

  @override
  void initState() {
    super.initState();
    checkLoginAndLoadFavorite();
  }

  // Uygulama açılırken çalışan fonksiyon
  Future<void> checkLoginAndLoadFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    // Kullanıcı giriş yapmamışsa → favori yok → Ankara
    if (user == null) {
      selectedCity = "Ankara";
      initializing = false;
      setState(() {});
      await fetchWeather("Ankara");
      return;
    }

    // Kullanıcı giriş yapmışsa → favori şehir kontrolü
    try {
      final ref = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("settings")
          .doc("favorite_weather_city");

      final doc = await ref.get();

      if (doc.exists && doc.data()!.containsKey("city")) {
        final fav = doc["city"] as String;

        favoriteCity = fav;
        selectedCity = fav; // Favori varsa başlangıç şehri favori olur.

        initializing = false;
        setState(() {});
        await fetchWeather(fav);
        return;
      }

      // Favori yoksa → Ankara
      selectedCity = "Ankara";
      initializing = false;
      setState(() {});
      await fetchWeather("Ankara");

    } catch (e) {
      // Hata olursa → Ankara
      selectedCity = "Ankara";
      initializing = false;
      setState(() {});
      await fetchWeather("Ankara");
    }
  }

  // Hava durumu getir
  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    try {
      final service = WeatherService();
      final data = await service.getWeather(city);

      setState(() {
        weatherList = data;
        isLoading = false;
        selectedCity = city;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  // Favori şehir belirle
  Future<void> setFavoriteCity(String city) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("settings")
        .doc("favorite_weather_city")
        .set({"city": city});

    setState(() {
      favoriteCity = city;
    });
  }

  // Favori şehri kaldır
  Future<void> removeFavoriteCity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("settings")
        .doc("favorite_weather_city")
        .delete();

    setState(() {
      favoriteCity = null;
    });
  }
  // Kullanıcı manuel şehir seçtiğinde
  void onCitySubmitted(String city) {
    fetchWeather(normalizeCityName(city));
  }

  @override
  Widget build(BuildContext context) {
    if (initializing || selectedCity == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return UiWeather(
      title: title,
      weatherList: weatherList,
      isLoading: isLoading,
      selectedCity: selectedCity!,
      onCitySubmitted: onCitySubmitted,
      userLoggedIn: FirebaseAuth.instance.currentUser != null,
      favoriteCity: favoriteCity ?? "",
      onFavoritePressed: (city) async {
        if (favoriteCity == city) {
          await removeFavoriteCity();
        } else {
          await setFavoriteCity(city);
        }
      },
    );
  }
}
