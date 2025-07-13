import 'package:flutter/material.dart';
import 'package:mobile/models/joke_model.dart';
import 'package:mobile/states/joke_state.dart';
import 'package:mobile/view_models/joke_view_model.dart';
import 'package:provider/provider.dart';


class JokeScreen extends StatefulWidget {
  final VoidCallback onNavigateToHistory;
  final VoidCallback onBackClick;
  final VoidCallback onShareClick;
  final VoidCallback onTechniquesClick;

  const JokeScreen({
    super.key,
    required this.onNavigateToHistory,
    required this.onBackClick,
    required this.onShareClick,
    required this.onTechniquesClick,
  });

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<JokeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Piadas"),
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackClick,
        ),
        actions: [
          TextButton.icon(
            onPressed: widget.onNavigateToHistory,
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: const Text(
              "Histórico",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _buildJokeState(viewModel),
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildJokeState(JokeViewModel viewModel) {
    final state = viewModel.jokeState;

    if (state is Loading) {
      return const CircularProgressIndicator();
    } else if (state is Error) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: viewModel.loadNewJoke,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4579FE)),
            child: const Text("Tentar novamente"),
          )
        ],
      );
    } else if (state is Success) {
      final Joke joke = state.joke;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Emoção aleatória", // Substitua pela lógica de emoção, se aplicável
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "Vamos ver se isso te faz rir:",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            joke.setup,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildAnswerBox(joke.punchline),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  showAnswer = false;
                });
                viewModel.loadNewJoke();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4579FE)),
              child: const Text("Conte outra"),
            ),
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildAnswerBox(String answer) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              showAnswer ? answer : "********",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                showAnswer = !showAnswer;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onTechniquesClick,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF31B768),
            minimumSize: const Size.fromHeight(54),
          ),
          child: const Text("Técnicas para se sentir melhor"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: widget.onShareClick,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD02F27),
            minimumSize: const Size.fromHeight(54),
          ),
          child: const Text("Agora não"),
        )
      ],
    );
  }
}
