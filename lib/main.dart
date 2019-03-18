import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandwhich/image_review_page.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

void main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SandWhich',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SandWhich?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _res = "";

  CameraController controller;

  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() async {
    await Tflite.close();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _takePicture().then((path) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageReviewPage(
                      imagePath: path,
                    ),
              ),
            );
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized) {
      // TODO: show snackbar
      print("no camera selected! show snackbar");
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = "${extDir.path}/pictures/sandwhich";
    await Directory(dirPath).create(recursive: true);
    final String filePath = "$dirPath/${timestamp()}.jpg";

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      // TODO: show snackbar
      print("show snackbar here");
      return null;
    }

    return filePath;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}
