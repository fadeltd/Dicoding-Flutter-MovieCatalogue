import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchMovies() async {
  const String apiKey = '';

  final Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json', 
  };

  final Uri uri = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?language=en-ID&page=1');

  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['results'];
  } else {
    throw Exception('Failed to load movies');
  }
}
