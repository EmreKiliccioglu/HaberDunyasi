import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api_model_football.dart';

//Api Url ve Api Key tanımlamaları
class FootballService {
  final String apiKey = dotenv.env['COLLECTAPI_KEY'] ?? '';
  final String leaguesUrl = dotenv.env['FOOTBALL_URL'] ?? '';
  final String pointUrl = dotenv.env['POINT_URL'] ?? '';
  final String fixtureUrl = dotenv.env['FIXTURE_URL'] ?? '';
  final String statsUrl = dotenv.env['STATICS_URL'] ?? '';

  Future<List<FootballLeague>> getLeagues() async {

    await Future.delayed(Duration(milliseconds: 300));

    final response = await http.get(
      Uri.parse(leaguesUrl),
      headers: {
        "authorization": "apikey $apiKey",
        "content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      debugPrint("LEAGUES RESULT TYPE: ${decoded["result"].runtimeType}");

      final data = decoded["result"] as List;
      return data.map((e) => FootballLeague.fromJson(e)).toList();
    } else {
      throw Exception("Ligler getirilemedi");
    }
  }

  Future<List<FootballStanding>> getStandings(String leagueKey) async {
    final url = pointUrl.replaceAll("{league}", leagueKey);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "authorization": "apikey $apiKey",
        "content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => FootballStanding.fromJson(e)).toList();
    } else if (response.statusCode == 429) {
      throw Exception("API rate limit aşıldı, lütfen 1 saniye bekleyin.");
    } else {
      throw Exception("Puan durumu getirilemedi");
    }
  }

  Future<List<FootballFixture>> getFixtures(String leagueKey) async {

    await Future.delayed(Duration(milliseconds: 300));

    final url = fixtureUrl.replaceAll("{league}", leagueKey);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "authorization": "apikey $apiKey",
        "content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => FootballFixture.fromJson(e)).toList();
    } else if (response.statusCode == 429) {
      throw Exception("API rate limit aşıldı, lütfen 1 saniye bekleyin.");
    } else {
      throw Exception("Puan durumu getirilemedi");
    }
  }

  Future<List<FootballStats>> getStats(String leagueKey) async {
    final url = statsUrl.replaceAll("{league}", leagueKey);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "authorization": "apikey $apiKey",
        "content-type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => FootballStats.fromJson(e)).toList();
    } else if (response.statusCode == 429) {
      throw Exception("API rate limit aşıldı, lütfen 1 saniye bekleyin.");
    } else {
      throw Exception("Puan durumu getirilemedi");
    }
  }
}
