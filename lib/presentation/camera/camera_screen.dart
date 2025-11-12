import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late List<CameraDescription> _cameras;
  late CameraController controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.high);

    await controller.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: CameraPreview(controller),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Implement video recording
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.videocam),
              ),
            ),
          ),
        ]
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
