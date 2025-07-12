import '../models/joke_model.dart';
import '../services/joke_api_service.dart';
import '../daos/joke_dao.dart';

class JokeRepository {
  final JokeApiService api;
  final JokeDao jokeDao;

  JokeRepository({
    required this.api,
    required this.jokeDao,
  });

  Future<Joke?> getRandomJoke() async {
    try {
      final joke = await api.getRandomJoke();

      // Adiciona timestamp atual
      final jokeWithDate = Joke(
        id: joke.id,
        type: joke.type,
        setup: joke.setup,
        punchline: joke.punchline,
        displayedAt: DateTime.now().millisecondsSinceEpoch,
      );

      await jokeDao.insertJoke(jokeWithDate);
      return jokeWithDate;
    } catch (e) {
      // Em caso de erro, tenta pegar do banco local
      final localJoke = await jokeDao.getRandomJoke();
      return localJoke; // Pode retornar null
    }
  }

  Future<List<Joke>> getJokeHistory() async {
    return await jokeDao.getAllJokes();
  }
}
