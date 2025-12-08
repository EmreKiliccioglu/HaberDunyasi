import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../l10n/app_localizations.dart';
import 'ui_pharmacy.dart';
import 'package:untitled5/pharmacy/api_model_pharmacy.dart';
import 'package:untitled5/pharmacy/service_pharmcy.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPharmacy extends StatefulWidget {
  const MainPharmacy({super.key});

  @override
  State<MainPharmacy> createState() => _MainPharmacyState();
}

class _MainPharmacyState extends State<MainPharmacy> {
  final PharmacyService _service = PharmacyService();
  final TextEditingController _cityController = TextEditingController(text: 'Ankara');
  final TextEditingController _districtController = TextEditingController();

  List<Pharmacy> _pharmacies = [];
  bool _isLoading = false;
  String? _error;

  String? favoriteCity;
  bool userLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCity();
  }

  // FAVORİ ŞEHİRİ FIRESTORE'DAN YÜKLEME
  Future<void> _loadFavoriteCity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _fetchData();
      return;
    }

    userLoggedIn = true;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("settings")
        .doc("favorite_pharmacy_city")
        .get();

    if (doc.exists && doc.data()!.containsKey("city")) {
      favoriteCity = doc["city"];
      _cityController.text = favoriteCity!;
      _districtController.clear();
      _fetchData();
    } else {
      _fetchData();
    }

    setState(() {});
  }

  // FAVORİ ŞEHİRİ KAYDET
  Future<void> _setFavoriteCity(String city) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("settings")
        .doc("favorite_pharmacy_city")
        .set({"city": city});

    setState(() {
      favoriteCity = city;
    });
  }

// FAVORİ ŞEHİR SİLME
  Future<void> removeFavoriteCity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("settings")
        .doc("favorite_pharmacy_city")
        .delete();

    setState(() {
      favoriteCity = null;
    });
  }

  // API VERİ ÇEKME
  bool _canSearch = true;

  void _fetchData() async {
    if (!_canSearch) return;
    _canSearch = false;
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.selectCity;
        _pharmacies = [];
        _isLoading = false;
      });

      // KİLİDİ AÇ
      Future.delayed(const Duration(seconds: 1), () {
        _canSearch = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _service.getPharmacies(
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
      );
      setState(() => _pharmacies = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
      Future.delayed(const Duration(seconds: 1), () {
        _canSearch = true;
      });
    }
  }

  // GOOGLE MAPS AÇMA
  void _openMaps(String lat, String lng) {
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UiPharmacy(
      title: AppLocalizations.of(context)!.onDutyPharmacy,
      cityController: _cityController,
      districtController: _districtController,
      onSearch: _fetchData,
      pharmacies: _pharmacies,
      isLoading: _isLoading,
      onNavigate: _openMaps,
      error: _error,
      userLoggedIn: userLoggedIn,
      favoriteCity: favoriteCity ?? "",
        onFavoritePressed: (city) async {
          if (favoriteCity == city) {
            await removeFavoriteCity();
          } else {
            await _setFavoriteCity(city);
          }
        }
    );
  }
}
