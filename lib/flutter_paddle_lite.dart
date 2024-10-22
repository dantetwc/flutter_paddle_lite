
import 'flutter_paddle_lite_platform_interface.dart';

class FlutterPaddleLite {
  Future<String?> getPlatformVersion() {
    return FlutterPaddleLitePlatform.instance.getPlatformVersion();
  }
}
