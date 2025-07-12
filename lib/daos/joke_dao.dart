import 'package:sqflite/sqflite.dart';
import '../models/joke_model.dart';

class JokeDao {
  final Database db;

  JokeDao(this.db);

  Future<void> insertJoke(Joke joke) async {
    await db.insert(
      'jokes',
      joke.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Joke?> getRandomJoke() async {
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM jokes ORDER BY RANDOM() LIMIT 1',
    );

    if (maps.isNotEmpty) {
      return Joke.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Joke>> getAllJokes() async {
    final List<Map<String, dynamic>> maps =
        await db.query('jokes', orderBy: 'id DESC');

    return maps.map((map) => Joke.fromMap(map)).toList();
  }
}
