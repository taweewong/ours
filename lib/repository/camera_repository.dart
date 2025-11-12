import 'dart:io';
import 'package:ours/datasource/network/camera_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_repository.g.dart';

abstract class CameraRepository {
  Future<AsyncValue<String>> uploadVideo({required File videoFile});
}

class CameraRepositoryImpl extends CameraRepository {
  CameraService service;

  CameraRepositoryImpl(this.service);

  @override
  Future<AsyncValue<String>> uploadVideo({required File videoFile}) async {
    return AsyncValue.guard(() async {
      final downloadUrl = await service.uploadVideo(videoFile: videoFile);
      return downloadUrl;
    });
  }
}

@Riverpod(keepAlive: true)
CameraRepository cameraRepository(ref) {
  CameraService cameraService = ref.watch(cameraServiceProvider);
  return CameraRepositoryImpl(cameraService);
}