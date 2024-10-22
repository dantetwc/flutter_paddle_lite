import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paddle_lite/flutter_paddle_lite.dart';
import 'package:flutter_paddle_lite/flutter_paddle_lite_platform_interface.dart';
import 'package:flutter_paddle_lite/flutter_paddle_lite_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPaddleLitePlatform
    with MockPlatformInterfaceMixin
    implements FlutterPaddleLitePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPaddleLitePlatform initialPlatform = FlutterPaddleLitePlatform.instance;

  test('$MethodChannelFlutterPaddleLite is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPaddleLite>());
  });

  test('getPlatformVersion', () async {
    FlutterPaddleLite flutterPaddleLitePlugin = FlutterPaddleLite();
    MockFlutterPaddleLitePlatform fakePlatform = MockFlutterPaddleLitePlatform();
    FlutterPaddleLitePlatform.instance = fakePlatform;

    expect(await flutterPaddleLitePlugin.getPlatformVersion(), '42');
  });
}
