import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../daos/joke_dao.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Database? _database;
  JokeDao? _jokeDao;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Inicializa o banco
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jokes (
        id INTEGER PRIMARY KEY,
        type TEXT,
        setup TEXT,
        punchline TEXT,
        displayedAt INTEGER
      )
    ''');
  }

  Future<JokeDao> getJokeDao() async {
    if (_jokeDao != null) return _jokeDao!;
    final db = await database;
    _jokeDao = JokeDao(db);
    return _jokeDao!;
  }
}
