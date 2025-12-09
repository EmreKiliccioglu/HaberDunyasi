import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
    _getUserLocation();
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

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // KONUM AÇIK MI
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _error = "Konum servisleri kapalı!");
        return;
      }

      // KONUM İZİN DURUMU
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _error = "Konum izni verilmedi!");
          return;
        }
      }

      // KALICI REDDEDİLMİŞ Mİ KONTROL
      if (permission == LocationPermission.deniedForever) {
        setState(() => _error = "Konum izni kalıcı olarak engellenmiş!");
        return;
      }

      // KONUMU AL
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );
      debugPrint("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      List<Placemark> placemarks = [];
      try {
        placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
      } catch (e) {
        debugPrint("Geocoding hatası: $e");
      }

      String? city;
      String? district;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city = place.administrativeArea;
        district = place.subAdministrativeArea ?? place.locality;
        debugPrint("Şehir: $city, İlçe: $district");
      } else {
        debugPrint("Placemark bulunamadı.");
      }

      setState(() {
        if (city != null && city.isNotEmpty) {
          _cityController.text = city;
        }
        if (district != null && district.isNotEmpty) {
          _districtController.text = district;
        }
      });

      if ((_cityController.text).trim().isNotEmpty) {
        _fetchData();
      }
    } catch (e) {
      debugPrint("Konum alma hatası: $e");
      setState(() => _error = "Konum alınırken bir hata oluştu.");
    }
  }

  void findNear() async {
    if (_pharmacies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Önce eczaneleri listeleyin.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // KULLANICI KONUMU
      Position pos = await Geolocator.getCurrentPosition();

      double userLat = pos.latitude;
      double userLng = pos.longitude;

      Pharmacy? nearest;
      double nearestDistance = double.infinity;

      // EN YAKIN ECZANE
      for (var p in _pharmacies) {
        if (p.lat.isEmpty || p.lng.isEmpty) continue;

        double lat = double.parse(p.lat);
        double lng = double.parse(p.lng);

        double distance = Geolocator.distanceBetween(
          userLat,
          userLng,
          lat,
          lng,
        );
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearest = p;
        }
      }

      if (nearest == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Yakın eczane bulunamadı.")),
        );
        return;
      }
      // NAVİGASYONDA GÖSTER
      _openMaps(nearest.lat, nearest.lng);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
    setState(() => _isLoading = false);
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
      onFindNearest: findNear,
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
