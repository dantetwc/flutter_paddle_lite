import 'package:flutter_paddle_lite/flutter_paddle_lite_platform_interface.dart';

class Predictor {
  String modelPath;
  late String _instanceId;

  Predictor(this.modelPath);

  Future<void> initialize() async {
    _instanceId =
        await FlutterPaddleLitePlatform.instance.createPredictor(modelPath);
  }

  Future<List> runOnImage(String imagePath) async {
    // return await FlutterPaddleLitePlatform.instance.run(_instanceId, input);
    await FlutterPaddleLitePlatform.instance.runOnImage(_instanceId, imagePath);

    return [];
  }

  dispose() {
    // FlutterPaddleLitePlatform.instance.dispose(_instanceId);
    throw UnimplementedError("dispose() has not been implemented.");
  }
}
