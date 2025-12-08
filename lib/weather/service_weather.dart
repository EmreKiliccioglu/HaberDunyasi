import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../core/cities.dart';
import 'api_model_weather.dart';

class WeatherService {
  final String _apiKey = dotenv.env['COLLECTAPI_KEY'] ?? '';
  final String _baseUrl = dotenv.env['WEATHER_URL'] ?? '';

  Future<List<Weather>> getWeather(String city) async {
    final normalizedCity = normalizeCityName(city);

    final url = Uri.parse('$_baseUrl?lang=tr&city=$normalizedCity');

    final response = await http.get(
      url,
      headers: {
        "Authorization": 'apikey $_apiKey',
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Weather.fromJson(e)).toList();
    } else {
      throw Exception('API isteği başarısız: ${response.statusCode}');
    }
  }

}
