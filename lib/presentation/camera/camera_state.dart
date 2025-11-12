import 'dart:io';
import 'package:ours/repository/camera_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_state.g.dart';

@riverpod
class CameraStateNotifier extends _$CameraStateNotifier {
  @override
  FutureOr<String?> build() {
    return null;
  }

  void uploadVideo({required File videoFile}) async {
    state = const AsyncValue.loading();

    CameraRepository cameraRepository = ref.watch(cameraRepositoryProvider);
    AsyncValue<String> result = await cameraRepository.uploadVideo(videoFile: videoFile);

    if (result.hasValue) {
      state = AsyncValue.data(result.value);
    } else if (result.hasError) {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }
}