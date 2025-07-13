import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TecnicasRespiracaoScreen extends StatelessWidget {
  const TecnicasRespiracaoScreen({super.key});

  void _showDialog(BuildContext context, String tecnica) {
    final (title, description, url) = switch (tecnica) {
      '478' => (
        'Técnica 4-7-8',
        'A Técnica 4-7-8 consiste em inspirar por 4 segundos, segurar por 7 e expirar por 8, auxiliando no relaxamento.',
        'https://www.cnnbrasil.com.br/saude/respiracao-4-7-8-como-usar-a-tecnica-para-dormir-ou-reduzir-a-ansiedade/'
      ),
      'alternadas' => (
        'Respiração Alternada',
        'A respiração alternada (Nadi Shodhana) equilibra os canais de energia e reduz o estresse.',
        'https://www.artofliving.org/br-pt/yoga/yoga-e-respiracao/tecnica-de-respiracao-das-narinas-alternadas-nadi-shodhan-pranayama'
      ),
      'relaxamento' => (
        'Relaxamento Muscular',
        'O relaxamento muscular progressivo ajuda a reduzir a tensão corporal e mental.',
        'https://www.psymeetsocial.com/blog/artigos/relaxamento-muscular-progressivo'
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
        title: const Text('Técnicas de Respiração'),
        backgroundColor: const Color(0xFF1E1E1E),
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
                onPressed: () => _showDialog(context, '478'),
                child: const Text(
                  'Técnica 4-7-8',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão 2
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDialog(context, 'alternadas'),
                child: const Text(
                  'Respiração Alternada',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botão 3
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDialog(context, 'relaxamento'),
                child: const Text(
                  'Relaxamento Muscular',
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
