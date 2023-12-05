import 'package:flutter/material.dart';
import 'package:movies/movies_ui.dart';

import 'movies_api.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<List<dynamic>>(
              future: fetchMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return MovieList(movies: snapshot.data!);
                }
              },
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MovieDetail(movie: args['movie']),
          );
        }
        return null;
      },
    );
  }
}
