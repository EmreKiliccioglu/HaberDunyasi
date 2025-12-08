import 'package:flutter/material.dart' hide MenuBar;
import 'package:untitled5/core/menu.dart';
import 'package:untitled5/pharmacy/api_model_pharmacy.dart';
import '../core/cities.dart';
import '../l10n/app_localizations.dart';

class UiPharmacy extends StatefulWidget {
  final String title;
  final TextEditingController cityController;
  final TextEditingController districtController;
  final VoidCallback onSearch;
  final List<Pharmacy> pharmacies;
  final bool isLoading;
  final Function(String lat, String lng) onNavigate;
  final bool userLoggedIn;
  final String favoriteCity;
  final Function(String city) onFavoritePressed;
  final String? error;

  const UiPharmacy({
    super.key,
    required this.title,
    required this.cityController,
    required this.districtController,
    required this.onSearch,
    required this.pharmacies,
    required this.isLoading,
    required this.onNavigate,
    required this.userLoggedIn,
    required this.favoriteCity,
    required this.onFavoritePressed,
    this.error,
  });

  @override
  State<UiPharmacy> createState() => _UiPharmacyState();
}

class _UiPharmacyState extends State<UiPharmacy> {
  bool cityDropdownOpen = false;
  bool districtDropdownOpen = false;
  List<String> filteredCities = List.from(turkiyeSehirleri);
  List<String> filteredDistricts = [];

  @override
  void initState() {
    super.initState();
    if (widget.userLoggedIn && widget.favoriteCity.isNotEmpty) {
      widget.cityController.text = widget.favoriteCity;
    }
    _updateDistricts(widget.cityController.text);
    widget.cityController.addListener(() {
      _updateDistricts(widget.cityController.text);
    });
  }

  void _updateDistricts(String city) {
    if (ilceHaritasi.containsKey(city)) {
      setState(() {
        filteredDistricts = List.from(ilceHaritasi[city]!);
      });
    } else {
      setState(() {
        filteredDistricts = [];
      });
    }
  }

  void filterCities(String value) {
    setState(() {
      filteredCities = turkiyeSehirleri
          .where((c) => c.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void filterDistricts(String value) {
    setState(() {
      filteredDistricts = (ilceHaritasi[widget.cityController.text] ?? [])
          .where((d) => d.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void selectCity(String city) {
    widget.cityController.text = city;
    cityDropdownOpen = false;

    districtDropdownOpen = false;
    widget.districtController.clear();

    if (ilceHaritasi.containsKey(city)) {
      filteredDistricts = List.from(ilceHaritasi[city]!);
    } else {
      filteredDistricts = [];
    }
    setState(() {});
  }

  void selectDistrict(String district) {
    widget.districtController.text = district;
    districtDropdownOpen = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MenuBar.build(title: widget.title, context: context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // ŞEHİR ALANI
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: widget.cityController,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText:
                                    AppLocalizations.of(context)!.cityHint,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                  ),
                                  onTap: () {
                                    cityDropdownOpen = true;
                                    widget.cityController.clear();
                                    districtDropdownOpen = false;
                                    widget.districtController.clear();
                                    setState(() {});
                                  },
                                  onChanged: filterCities,
                                ),
                              ),
                              Icon(cityDropdownOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                            ],
                          ),
                        ),

                        if (cityDropdownOpen)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: Card(
                              margin: const EdgeInsets.only(top: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredCities.length,
                                itemBuilder: (context, index) {
                                  final c = filteredCities[index];

                                  return ListTile(
                                    title: Text(c),

                                    // FAVORİ ŞEHİR
                                    trailing: widget.userLoggedIn
                                        ? IconButton(
                                      icon: Icon(
                                        widget.favoriteCity == c
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: widget.favoriteCity == c
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        widget.onFavoritePressed(c);
                                        widget.cityController.text = c;

                                        setState(() {});
                                      },
                                    )
                                        : null,

                                    onTap: () => selectCity(c),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // İLÇE ALANI
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: widget.districtController,
                                  enabled: ilceHaritasi.containsKey(
                                      widget.cityController.text),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: ilceHaritasi.containsKey(
                                        widget.cityController.text)
                                        ? AppLocalizations.of(context)!
                                        .districtHint
                                        : AppLocalizations.of(context)!
                                        .noDistrict,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                  ),
                                  onTap: () {
                                    if (ilceHaritasi.containsKey(
                                        widget.cityController.text)) {
                                      setState(() {
                                        districtDropdownOpen = true;
                                        widget.districtController.clear();
                                      });
                                    }
                                  },
                                  onChanged: filterDistricts,
                                ),
                              ),
                              Icon(districtDropdownOpen
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        if (districtDropdownOpen)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: Card(
                              margin: const EdgeInsets.only(top: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredDistricts.length,
                                itemBuilder: (context, index) {
                                  final d = filteredDistricts[index];
                                  return ListTile(
                                    title: Text(d),
                                    onTap: () => selectDistrict(d),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ARA BUTONU
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: widget.onSearch,
                      child: Text(AppLocalizations.of(context)!.search),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: widget.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : widget.error != null
                  ? Center(
                child: Text(widget.error ?? ''),
              )
                  : _buildList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    if (widget.pharmacies.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context)!.noOnDutyPharmacy));
    }

    return ListView.builder(
      itemCount: widget.pharmacies.length,
      itemBuilder: (context, index) {
        final p = widget.pharmacies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                    '${AppLocalizations.of(context)!.address}: ${p.address}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${AppLocalizations.of(context)!.phone} : ${p.phone}'),
                    IconButton(
                      icon: const Icon(Icons.navigation),
                      color: Colors.blue,
                      onPressed: () {
                        if (p.lat.isNotEmpty && p.lng.isNotEmpty) {
                          widget.onNavigate(p.lat, p.lng);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
