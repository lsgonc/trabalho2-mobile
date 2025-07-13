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
        ChangeNotifierProvider(create: (_) => AnalisarEmocaoViewModel()),
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
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white, // Ícones e texto
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF4579FE),
            minimumSize: const Size.fromHeight(54),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),

      home: HomeScreen(),
      routes: {
        '/joke_screen': (context) => JokeScreen(
          onNavigateToHistory: () => {
            Navigator.pushNamed(context, '/joke_history'),
          },
          onBackClick: () => {Navigator.pop(context)},
          onShareClick: () => {Navigator.pushNamed(context, '/')},
          onTechniquesClick: () => {
            Navigator.pushNamed(context, '/tecnicas_respiracao'),
          },
        ),
        '/dicas_estudo': (context) => DicasEstudoScreen(),
        '/tecnicas_respiracao': (context) => TecnicasRespiracaoScreen(),
        '/analisar_emocao': (context) => AnalisarEmocaoScreen(
          onBack: () => {Navigator.pop(context)},
          onAnalysisComplete: () => {
            Navigator.pushNamed(context, '/joke_screen'),
          },
        ),
        '/joke_history': (context) =>
            JokeHistoryScreen(onBackClick: () => {Navigator.pop(context)}),
      },
    );
  }
}
