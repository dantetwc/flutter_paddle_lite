import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paddle_lite/flutter_paddle_lite.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CameraController? cameraController;
  late Predictor predictor;
  bool isPredicting = false;

  @override
  void initState() {
    super.initState();
    initPredictor();
    initCamera();
  }

  Future<void> initPredictor() async {
    predictor = Predictor(
        "models/human_pp_humansegv2_lite_192x192_inference_model_with_softmax.nb");
    await predictor.initialize();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    var camera = cameras.first;
    for (var cam in cameras) {
      if (cam.lensDirection == CameraLensDirection.front) {
        camera = cam;
        break;
      }
    }

    cameraController = CameraController(camera, ResolutionPreset.max);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: ClipRect(
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                  width: cameraController!
                                      .value.previewSize?.height,
                                  height: cameraController!
                                      .value.previewSize?.width,
                                  child: CameraPreview(cameraController!))))),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (isPredicting) {
                      return;
                    }

                    setState(() {
                      isPredicting = true;
                    });
                    final image = await cameraController!.takePicture();
                    final directory = await getTemporaryDirectory();
                    final path =
                        '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';
                    final file = File(path);
                    await file.writeAsBytes(await image.readAsBytes());
                    final result = await predictor.runOnImage(path);

                    setState(() {
                      isPredicting = false;
                    });
                  },
                  child: const Text('Take Picture'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
