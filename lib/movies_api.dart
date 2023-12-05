import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = '<API_KEY>';

Future<List<dynamic>> fetchMovies() async {
  final Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json', 
  };

  final Uri uri = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1');

  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['results'];
  } else {
    throw Exception('Failed to load movies');
  }
}

Future<dynamic> fetchMovieDetail(int movieId) async {
  final Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json', 
  };

  final Uri uri = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId');

  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load movies');
  }
}
