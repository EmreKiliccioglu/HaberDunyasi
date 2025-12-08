import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:untitled5/pharmacy/api_model_pharmacy.dart';

class PharmacyService {
  Future<List<Pharmacy>> getPharmacies({required String city, String? district}) async {
    final String apiKey = dotenv.env['COLLECTAPI_KEY'] ?? '';
    final baseUrl = dotenv.env['PHARMACY_URL'] ?? '';
    final url = Uri.parse('$baseUrl?il=$city');

    final response = await http.get(
      url,
      headers: {
        'authorization': 'apikey $apiKey',
        'content-type': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true && body['result'] != null) {
        final List list = body['result'] as List;
        var pharmacies = list.map((e) => Pharmacy.fromJson(e as Map<String, dynamic>)).toList();

        if (district != null && district.isNotEmpty) {
          pharmacies = pharmacies
              .where((p) => p.address.toLowerCase().contains(district.toLowerCase()))
              .toList();
        }

        return pharmacies;
      } else {
        return [];
      }
    } else {
      throw Exception('API hatası: ${response.statusCode} - ${response.body}');
    }
  }

}