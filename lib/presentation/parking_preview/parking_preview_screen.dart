import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ParkingPreviewScreen extends ConsumerStatefulWidget {
  const ParkingPreviewScreen({super.key});

  @override
  ConsumerState<ParkingPreviewScreen> createState() =>
      _ParkingPreviewScreenState();
}

class _ParkingPreviewScreenState extends ConsumerState<ParkingPreviewScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Check if local file exists first
      final directory = await getApplicationDocumentsDirectory();
      final localPath = p.join(directory.path, 'parking_record_video.mp4');
      final localFile = File(localPath);

      if (await localFile.exists()) {
        // Play from local file
        _controller = VideoPlayerController.file(localFile);
      } else {
        // Get video from Firebase Storage
        final storageRef = FirebaseStorage.instance.ref();
        final videoRef = storageRef.child('videos/parking_record_video.mp4');
        final downloadUrl = await videoRef.getDownloadURL();

        // Play from network URL
        _controller = VideoPlayerController.networkUrl(Uri.parse(downloadUrl));
      }

      await _controller!.initialize();
      await _controller!.setLooping(true);
      await _controller!.play();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load video: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Parking Preview', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
                ? _buildErrorMessage()
                : _buildVideoPlayer(),
      ),
      floatingActionButton: _controller != null && _controller!.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              },
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }

  Widget _buildVideoPlayer() {
    if (_controller != null && _controller!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      return const Text(
        'Video not available',
        style: TextStyle(color: Colors.white),
      );
    }
  }

  Widget _buildErrorMessage() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      _errorMessage!,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );
}
