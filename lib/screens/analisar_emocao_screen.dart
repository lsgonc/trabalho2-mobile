import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../view_models/analisar_emocao_view_model.dart';

class AnalisarEmocaoScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onAnalysisComplete;

  const AnalisarEmocaoScreen({
    super.key,
    required this.onBack,
    required this.onAnalysisComplete,
  });

  @override
  State<AnalisarEmocaoScreen> createState() => _AnalisarEmocaoScreenState();
}

class _AnalisarEmocaoScreenState extends State<AnalisarEmocaoScreen> {
  CameraController? _cameraController;
  bool _cameraPermissionGranted = false;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      _initializeCamera();
    } else {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        _initializeCamera();
      } else {
        setState(() {
          _cameraPermissionGranted = false;
        });
      }
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera =
        cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    setState(() {
      _cameraPermissionGranted = true;
      _isAnalyzing = true;
    });

    // Simula análise
    Future.delayed(const Duration(seconds: 3), () {
      final viewModel = context.read<AnalisarEmocaoViewModel>();
      viewModel.sortearEmocao(['Feliz', 'Triste', 'Ansioso', 'Calmo']); // Exemplo
      widget.onAnalysisComplete();
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Analisando Emoção'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _cameraPermissionGranted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Detectando expressão facial...',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  if (_cameraController != null && _cameraController!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: CameraPreview(_cameraController!),
                    ),
                  const CircularProgressIndicator(),
                  const Text(
                    'Analisando...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Permissão da câmera é necessária para continuar.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _checkCameraPermission,
                    child: const Text('Solicitar Permissão'),
                  ),
                ],
              ),
      ),
    );
  }
}
