import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';

class JokeApiService {
  final http.Client client;
  final String baseUrl;

  JokeApiService({
    required this.client,
    required this.baseUrl,
  });

  Future<Joke> getRandomJoke() async {
    final response = await client.get(Uri.parse('$baseUrl/random_joke'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Joke.fromMap(data);
    } else {
      throw Exception('Failed to load joke');
    }
  }
}
