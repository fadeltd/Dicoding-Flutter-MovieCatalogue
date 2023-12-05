import 'package:flutter/material.dart';
import 'package:movies/movies_api.dart';

String imageUrl(path, size) {
  return 'https://image.tmdb.org/t/p/w$size/$path';
}

class MovieList extends StatefulWidget {
  final List<dynamic> movies;

  const MovieList({
    super.key,
    required this.movies,
  });

  @override
  MovieListState createState() => MovieListState();
}

class MovieListState extends State<MovieList> {
  late List<dynamic> filteredMovies;
  bool isSearchExpanded = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMovies = widget.movies;
    searchController.addListener(() {
      filterMovies();
    });
  }

  void filterMovies() {
    setState(() {
      filteredMovies = widget.movies.where((movie) {
        final title = movie['title'].toString().toLowerCase();
        return title.contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchExpanded
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  filterMovies();
                },
              )
            : const Text('Popular Movies'),
        actions: [
          isSearchExpanded
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSearchExpanded = false;
                      searchController.clear();
                      filterMovies();
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearchExpanded = true;
                    });
                  },
                ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredMovies.length,
        itemBuilder: (context, index) {
          var movie = filteredMovies[index];
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
            onTap: () async {
              dynamic movieDetail = await fetchMovieDetail(movie['id']);
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/detail',
                  arguments: {'movie': movieDetail});
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
    int votePercentage = (movie['vote_average'] * 10).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${movie['title']} (${movie['release_date'].substring(0, 4)})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Image.network(
                    imageUrl(movie['poster_path'], 300),
                    height: 300,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Add border
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        movie['status'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$votePercentage%',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${_formatReleaseDate(movie['release_date'])} (${movie['production_countries'][0]['iso_3166_1']}) • ${_getGenres(movie['genres'])} • ${_convertToHours(movie['runtime'])}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${movie['overview']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    DateTime parsedDate = DateTime.tryParse(releaseDate) ?? DateTime.now();
    String formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    return formattedDate;
  }

  String _getGenres(List<dynamic> genres) {
    List genreNames = genres.map((genre) => genre['name']).toList();
    return genreNames.join(', ');
  }

  String _convertToHours(int minutes) {
    int hours = minutes ~/ 60;
    int minutesRemaining = minutes % 60;
    return '${hours}h ${minutesRemaining}m';
  }
}
