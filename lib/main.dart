import 'package:flutter/material.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/repositories/joke_repository.dart';
import 'package:mobile/screens/joke_screen.dart';
import 'package:mobile/services/joke_api_service.dart';
import 'package:mobile/view_models/joke_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final jokeDao = await db.getJokeDao();
  final api = JokeApiService(
    client: http.Client(),
    baseUrl: 'https://official-joke-api.appspot.com',
  );
  final repository = JokeRepository(api: api, jokeDao: jokeDao);

  runApp(
    ChangeNotifierProvider(
      create: (_) => JokeViewModel(repository: repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piadas App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: JokeScreen(
        onNavigateToHistory: () {
          // TODO: Navegar para histórico
        },
        onBackClick: () {
          // TODO: Ação de voltar
        },
        onShareClick: () {
          // TODO: Compartilhar piada
        },
        onTechniquesClick: () {
          // TODO: Abrir técnicas para se sentir melhor
        },
      ),
    );
  }
}
