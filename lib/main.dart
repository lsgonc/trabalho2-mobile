import 'package:flutter/material.dart';
import 'package:mobile/database/database.dart';
import 'package:mobile/repositories/joke_repository.dart';
import 'package:mobile/screens/analisar_emocao_screen.dart';
import 'package:mobile/screens/dicas_estudo_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/joke_history_screen.dart';
import 'package:mobile/screens/joke_screen.dart';
import 'package:mobile/screens/tecnicas_respiracao_screen.dart';
import 'package:mobile/services/joke_api_service.dart';
import 'package:mobile/view_models/analisar_emocao_view_model.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => JokeViewModel(repository: repository),
        ),
        ChangeNotifierProvider(
          create: (_) => AnalisarEmocaoViewModel(),
        ),
      ],
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
      home: HomeScreen(),
      routes: {
        '/joke_screen': (context) => JokeScreen(
          onNavigateToHistory: () => { Navigator.pushNamed(context, '/joke_history') },
          onBackClick: () => { Navigator.pop(context) },
          onShareClick: () => { Navigator.pushNamed(context, '/') },
          onTechniquesClick: () => { Navigator.pushNamed(context, '/tecnicas_respiracao') },
        ), 
        '/dicas_estudo': (context) => DicasEstudoScreen(),
        '/tecnicas_respiracao': (context) => TecnicasRespiracaoScreen(),
        '/analisar_emocao': (context) => AnalisarEmocaoScreen(
          onBack: () => { Navigator.pop(context)}, onAnalysisComplete: () => { Navigator.pushNamed(context, '/joke_screen')}),
        '/joke_history': (context) => JokeHistoryScreen(onBackClick: () => {Navigator.pop(context)})
      },
    );
  }
}
