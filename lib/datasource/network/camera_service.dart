import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_service.g.dart';

abstract class CameraService {
  Future<String> uploadVideo({required File videoFile});
}

class CameraServiceImpl extends CameraService {
  @override
  Future<String> uploadVideo({required File videoFile}) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final videoRef = storageRef.child('videos/parking_record.mp4');

      // Upload the file
      await videoRef.putFile(videoFile);

      // Get the download URL
      final downloadUrl = await videoRef.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception("Failed to upload video: ${e.message}");
    }
  }
}

@Riverpod(keepAlive: true)
CameraService cameraService(ref) {
  return CameraServiceImpl();
}