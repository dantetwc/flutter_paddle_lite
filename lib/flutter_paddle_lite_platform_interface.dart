import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_paddle_lite_method_channel.dart';

abstract class FlutterPaddleLitePlatform extends PlatformInterface {
  /// Constructs a FlutterPaddleLitePlatform.
  FlutterPaddleLitePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPaddleLitePlatform _instance = MethodChannelFlutterPaddleLite();

  /// The default instance of [FlutterPaddleLitePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPaddleLite].
  static FlutterPaddleLitePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPaddleLitePlatform] when
  /// they register themselves.
  static set instance(FlutterPaddleLitePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
