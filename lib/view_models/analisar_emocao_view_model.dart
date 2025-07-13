import 'dart:math';
import 'package:flutter/material.dart';

class AnalisarEmocaoViewModel extends ChangeNotifier {
  String _emocao = '';

  String get emocao => _emocao;

  void sortearEmocao(List<String> lista) {
    if (lista.isEmpty) return;
    final random = Random();
    _emocao = lista[random.nextInt(lista.length)];
    notifyListeners();
  }
}
