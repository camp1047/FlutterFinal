import 'package:flutter/material.dart';
import 'package:movie_night_app/services/session_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_night_app/components/card.dart';

class MovieSelectionScreen extends StatefulWidget {
  final String sessionId;
  const MovieSelectionScreen({super.key, required this.sessionId});

  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  final String tmdbApiKey = "f760fcfff2cec3d20957363861774f82";
  final String tmdbBaseUrl = "https://api.themoviedb.org/3";
  final List _movies = [];
  bool _loading = true;
  int _currentIndex = 0;
  double _swipeOffset = 0.0;
  double _swipeDirection = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final url = Uri.parse('$tmdbBaseUrl/movie/popular?api_key=$tmdbApiKey&page=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _movies.addAll(jsonDecode(response.body)['results']);
        _loading = false;
      });
    } else {
      throw Exception("Failed to fetch movies");
    }
  }

  Future<void> _voteMovie(bool vote) async {
    final movieId = _movies[_currentIndex]['id'];
    await SessionService().voteForMovie(movieId, vote);

    setState(() {
      _swipeOffset = 0.0;
      _swipeDirection = 0.0;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentIndex++;
    });

    if (_currentIndex >= _movies.length) {
      _fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentIndex >= _movies.length) {
      return const Center(child: Text("No more movies"));
    }

    final movie = _movies[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Select Movies")),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _swipeOffset += details.delta.dx;
            });
          },
          onPanEnd: (details) {
            final isSwipeRight = _swipeOffset > 100;
            final isSwipeLeft = _swipeOffset < -100;

            if (isSwipeRight || isSwipeLeft) {
              _swipeDirection = _swipeOffset > 0 ? 1.0 : -1.0;
              _voteMovie(isSwipeRight);
            } else {
              setState(() {
                _swipeOffset = 0.0;
              });
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(_swipeOffset, 0),
                child: Transform.rotate(
                  angle: _swipeOffset / 500, // Add rotation effect
                  child: SwipeableMovieCard(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    title: movie['title'],
                    description: movie['overview'],
                  ),
                ),
              ),
              if (_swipeDirection > 0)
                Positioned(
                  left: 50,
                  top: 200,
                  child: const Icon(Icons.thumb_up, size: 100, color: Colors.green),
                ),
              if (_swipeDirection < 0)
                Positioned(
                  right: 50,
                  top: 200,
                  child: const Icon(Icons.thumb_down, size: 100, color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
