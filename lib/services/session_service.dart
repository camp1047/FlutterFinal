import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  final String baseUrl = 'https://movie-night-api.onrender.com';

  Future<String> startSession(String deviceId) async {
    final url = Uri.parse('$baseUrl/start-session?device_id=$deviceId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final sessionId = data['session_id'];
      await _saveSessionId(sessionId);
      return data['code'];
    } else {
      throw Exception('Error starting session: ${response.body}');
    }
  }

  Future<void> joinSession(String deviceId, String code) async {
    final url = Uri.parse('$baseUrl/join-session?device_id=$deviceId&code=$code');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final sessionId = data['session_id'];
      await _saveSessionId(sessionId);
    } else {
      throw Exception('Error joining session: ${response.body}');
    }
  }

  Future<bool> voteForMovie(int movieId, bool vote) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id') ?? '';

    final url = Uri.parse(
        '$baseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data['match'] as bool;
    } else {
      throw Exception('Error voting for movie: ${response.body}');
    }
  }

  Future<void> _saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionId);
  }
}
