import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_paddle_lite_platform_interface.dart';

/// An implementation of [FlutterPaddleLitePlatform] that uses method channels.
class MethodChannelFlutterPaddleLite extends FlutterPaddleLitePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_paddle_lite');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String> createPredictor(String modelPath) async {
    final predictor =
        await methodChannel.invokeMethod<String>('createPredictor', modelPath);
    return predictor!;
  }

  @override
  Future<void> runOnImage(String instanceId, String imagePath) async {
    await methodChannel.invokeMethod<void>('runOnImage', <String, String>{
      'instanceId': instanceId,
      'imagePath': imagePath,
    });
  }
}
