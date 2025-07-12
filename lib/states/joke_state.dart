import '../models/joke_model.dart';

sealed class JokeState {
  const JokeState();
}

class Loading extends JokeState {
  const Loading();
}

class Success extends JokeState {
  final Joke joke;
  const Success(this.joke);
}

class Error extends JokeState {
  final String message;
  const Error(this.message);
}
