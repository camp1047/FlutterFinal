import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_night_app/models/movie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBService {
  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String popularMoviesEndpoint = '/movie/popular';

  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    final url = Uri.parse('$baseUrl$popularMoviesEndpoint?api_key=$apiKey&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch popular movies: ${response.body}');
    }
  }
}
