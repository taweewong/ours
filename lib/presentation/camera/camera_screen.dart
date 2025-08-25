import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() =>
      _CameraScreenState();
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

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double aspectRatio = 0;

    if (isPortrait) {
      aspectRatio =
          controller.value.previewSize!.height /
          controller.value.previewSize!.width;
    } else {
      aspectRatio =
          controller.value.previewSize!.width /
          controller.value.previewSize!.height;
    }

    return SafeArea(
      child: SafeArea(
        child: SizedBox.expand(
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
