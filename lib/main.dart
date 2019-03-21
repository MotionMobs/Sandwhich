import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sandwhich/image_review_page.dart';
import 'package:sandwhich/info_drawer.dart';
import 'package:sandwhich/mm_button.dart';
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
        fontFamily: 'RobotoMono',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _res = "";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController controller;
  int currentCamera = 0;

  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    controller =
        CameraController(cameras[currentCamera], ResolutionPreset.medium);
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
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: InfoDrawer(),
      body: Stack(
        children: <Widget>[
          controller.value.isInitialized
              ? Transform.scale(
                  scale: controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      child: CameraPreview(controller),
                      aspectRatio: controller.value.aspectRatio,
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.width / 10,
                child: FlatButton(
                  child: Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 44.0, right: 24),
              child: IconButton(
                icon: Icon(
                  Icons.switch_camera,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (cameras.length > 1) {
                    currentCamera = (currentCamera + 1) % cameras.length;
                    loadCamera();
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MMButton(),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 72.0,
        height: 72.0,
        child: FloatingActionButton(
          backgroundColor: Colors.white30,
          shape:
              CircleBorder(side: BorderSide(color: Colors.white, width: 2.5)),
          elevation: 2.0,
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
          child: Icon(Icons.camera_alt, color: Colors.white, size: 28),
        ),
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
