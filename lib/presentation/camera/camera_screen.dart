import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ours/presentation/camera/camera_state.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late List<CameraDescription> _cameras;
  late CameraController controller;
  bool _isCameraInitialized = false;
  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;

  XFile? videoFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.high);

    await controller.initialize();

    // Get zoom levels
    _maxZoomLevel = await controller.getMaxZoomLevel();
    _minZoomLevel = await controller.getMinZoomLevel();
    _currentZoomLevel = _minZoomLevel;

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to camera state for upload status
    ref.listen<AsyncValue<String?>>(cameraStateNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (downloadUrl) {
          if (downloadUrl != null) {
            // Upload successful, navigate back
            Navigator.of(context).pop(); // Close dialog
            context.pop(); // Navigate back to previous screen
          }
        },
        error: (err, _) {
          Navigator.of(context).pop(); // Close dialog
          print('DEBUG_CAMERA: ${err.toString()}');
          showInSnackBar('Upload failed: ${err.toString()}');
        },
      );
    });

    if (!_isCameraInitialized || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Camera', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: CameraPreview(controller),
            ),
          ),
          // Zoom slider
          Positioned(
            right: 16,
            top: 100,
            bottom: 100,
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                width: 200,
                child: Row(
                  children: [
                    Icon(Icons.zoom_out, color: Colors.white, size: 20),
                    Expanded(
                      child: Slider(
                        value: _currentZoomLevel,
                        min: _minZoomLevel,
                        max: _maxZoomLevel,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: (value) async {
                          setState(() {
                            _currentZoomLevel = value;
                          });
                          await controller.setZoomLevel(value);
                        },
                      ),
                    ),
                    Icon(Icons.zoom_in, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  if (controller.value.isRecordingVideo) {
                    onStopButtonPressed();
                  } else {
                    onVideoRecordButtonPressed();
                  }
                },
                backgroundColor:
                    controller.value.isRecordingVideo
                        ? Colors.red
                        : Colors.grey,
                child:
                    controller.value.isRecordingVideo
                        ? Icon(Icons.stop)
                        : Icon(Icons.videocam),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        _saveVideo();
        // TODO: _startVideoPlayer();
      }
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController cameraController = controller;

    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController cameraController = controller;

    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> _saveVideo() async {
    XFile? video = videoFile;
    if (video == null) {
      return;
    }
    try {
      final savedFile = await _saveFileToInternalStorage(videoFile!);
      showInSnackBar('Video saved!');

      // Show upload dialog
      _showUploadDialog();

      // Start upload to Firebase
      ref.read(cameraStateNotifierProvider.notifier).uploadVideo(videoFile: savedFile);
    } catch (e) {
      showInSnackBar('Error saving video: $e');
      print("DEBUG_CAMERA: Error saving video: $e");
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Uploading video...'),
            ],
          ),
        );
      },
    );
  }

  Future<File> _saveFileToInternalStorage(XFile xfile) async {
    final directory = await getApplicationDocumentsDirectory();
    final targetPath = p.join(directory.path, 'parking_record_video.mp4');

    final previousFile = File(targetPath);

    // Delete existing file if it exists (to overwrite)
    if (await previousFile.exists()) {
      await previousFile.delete();
    }

    // Copy the recorded video to the target path
    final sourceFile = File(xfile.path);
    final resultFile = await sourceFile.copy(targetPath);

    return resultFile;
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
