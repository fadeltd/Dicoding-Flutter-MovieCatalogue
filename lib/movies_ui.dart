import 'package:flutter/material.dart';

String imageUrl(path, size) {
  return 'https://image.tmdb.org/t/p/w$size/$path';
}

class MovieList extends StatelessWidget {
  final List<dynamic> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          var movie = movies[index];
          return ListTile(
            leading: Image.network(
              imageUrl(movie['poster_path'], 200),
              width: 50,
              height: 75,
              fit: BoxFit.cover,
            ),
            title: Text(movie['title']),
            subtitle: Text(
              'Release Date: ${movie['release_date']}\nRating: ${movie['vote_average'].toStringAsFixed(2)}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetail(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MovieDetail extends StatelessWidget {
  final dynamic movie;

  const MovieDetail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl(movie['poster_path'], 300),
              height: 300,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              'Release Date: ${movie['release_date']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Rating: ${movie['vote_average']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Overview: ${movie['overview']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
