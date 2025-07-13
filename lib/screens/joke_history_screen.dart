import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../view_models/joke_view_model.dart';

class JokeHistoryScreen extends StatefulWidget {
  final VoidCallback onBackClick;

  const JokeHistoryScreen({super.key, required this.onBackClick});

  @override
  State<JokeHistoryScreen> createState() => _JokeHistoryScreenState();
}

class _JokeHistoryScreenState extends State<JokeHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega o histórico ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JokeViewModel>().loadJokeHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jokeHistory = context.watch<JokeViewModel>().jokeHistory;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Histórico de Piadas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackClick,
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: jokeHistory.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma piada exibida ainda.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.separated(
                itemCount: jokeHistory.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final joke = jokeHistory[index];
                  final dateText = DateFormat('dd/MM/yyyy HH:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(joke.displayedAt!));

                  return Card(
                    color: const Color(0xFF323435),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            joke.setup,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            joke.punchline,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Exibida em: $dateText',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
