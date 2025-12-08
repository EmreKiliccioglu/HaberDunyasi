import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:untitled5/finance/api_model_finance.dart';

class MarketService {
  final String _apiKey = dotenv.env['COLLECTAPI_KEY'] ?? '';

  Future<List<MarketItem>> fetch(String baseUrl, String type) async {
    //Apiye istek atma
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "authorization": "apikey $_apiKey",
        "content-type": "application/json",
      },
    );
    //HTTP CEVAP KONTROLÜ
    if (response.statusCode != 200) {
      throw Exception('API isteği başarısız: ${response.statusCode}');
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final dynamic resultData = data['result'];

    List<dynamic> jsonList = resultData is List ? resultData : [];

    return jsonList.map((e) => MarketItem.fromJson(e, type)).toList();
  }
}



