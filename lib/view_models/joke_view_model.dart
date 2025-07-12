import 'package:flutter/foundation.dart';
import '../models/joke_model.dart';
import '../repositories/joke_repository.dart';
import '../states/joke_state.dart';

class JokeViewModel extends ChangeNotifier {
  final JokeRepository repository;

  JokeState jokeState = const Loading();
  List<Joke> jokeHistory = [];

  JokeViewModel({required this.repository}) {
    loadNewJoke();
  }

  Future<void> loadNewJoke() async {
    jokeState = const Loading();
    notifyListeners();

    try {
      final joke = await repository.getRandomJoke();
      if (joke != null) {
        jokeState = Success(joke);
      } else {
        jokeState = const Error("Nenhuma piada disponível");
      }
    } catch (e) {
      jokeState = Error(e.toString());
    }

    notifyListeners();
  }

  Future<void> loadJokeHistory() async {
    jokeHistory = await repository.getJokeHistory();
    notifyListeners();
  }
}
