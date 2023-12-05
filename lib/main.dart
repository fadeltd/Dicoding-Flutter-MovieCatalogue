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
        '/detail': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          if (arguments != null && arguments.containsKey('movie')) {
            return MovieDetail(movie: arguments['movie']);
          } else {
            // Handle the case when arguments or 'movie' is null
            return const Scaffold(
              body: Center(
                child: Text('Invalid movie details'),
              ),
            );
          }
        },
      },
    );
  }
}
