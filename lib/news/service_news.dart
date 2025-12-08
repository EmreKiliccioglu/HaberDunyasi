import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import '../core/global.dart';
import 'api_model_news.dart';

class NewsService {
  Future<List<NewsItem>> getNews({String? category, required BuildContext context}) async {
    final String apiKey = dotenv.env['COLLECTAPI_KEY'] ?? '';
    String baseUrl = dotenv.env['NEWS_URL'] ?? '';

    final locale = appLocale.value.languageCode;

    if (locale == 'en') {
      baseUrl = baseUrl.replaceAll('country=tr', 'country=en');
    }
    final url = category != null ? Uri.parse('$baseUrl?tag=$category') : Uri.parse(baseUrl);

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
        return list.map((e) => NewsItem.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('API hatası: ${response.statusCode} - ${response.body}');
    }
  }
}
