class Pharmacy {
  final String name;
  final String address;
  final String phone;
  final String lat;
  final String lng;

  Pharmacy({
    required this.name,
    required this.address,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    String lat = '';
    String lng = '';

    if (json['loc'] != null && (json['loc'] as String).contains(',')) {
      final parts = (json['loc'] as String).split(',');
      lat = parts[0].trim();
      lng = parts[1].trim();
    }

    return Pharmacy(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      lat: lat,
      lng: lng,
    );
  }
}
