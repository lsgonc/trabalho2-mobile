import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DicasEstudoScreen extends StatelessWidget {
  const DicasEstudoScreen({super.key});

  void _showDialog(BuildContext context, String metodo) {
    final (title, description, url) = switch (metodo) {
      'pomodoro' => (
        'Técnica Pomodoro',
        'A Técnica Pomodoro consiste em dividir o tempo de estudo em blocos com pausas curtas.',
        'https://brasilescola.uol.com.br/dicas-de-estudo/tecnica-pomodoro-que-e-e-como-funciona.htm'
      ),
      'mnemonico' => (
        'Estudo Mnemônico',
        'O estudo mnemônico utiliza associações mentais para facilitar a memorização.',
        'https://www.educamaisbrasil.com.br/educacao/noticias/o-que-e-estudo-mnemonico-conheca-a-tecnica'
      ),
      'intercalacao' => (
        'Estudo Intercalado',
        'A técnica de intercalar disciplinas melhora a retenção e o aprendizado.',
        'https://www.educamaisbrasil.com.br/educacao/dicas/o-que-e-estudo-intercalado'
      ),
      _ => ('', '', '')
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Abrir site'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Dicas de Estudo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão 1
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDialog(context, 'pomodoro'),
                child: const Text(
                  'Técnica Pomodoro',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão 2
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDialog(context, 'mnemonico'),
                child: const Text(
                  'Estudo Mnemônico',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão 3
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDialog(context, 'intercalacao'),
                child: const Text(
                  'Estudo Intercalado',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
