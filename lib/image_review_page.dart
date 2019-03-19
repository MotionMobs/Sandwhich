import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sandwhich/mm_button.dart';
import 'package:tflite/tflite.dart';
import 'package:simple_share/simple_share.dart';

class ImageReviewPage extends StatefulWidget {
  final String imagePath;

  const ImageReviewPage({Key key, @required this.imagePath}) : super(key: key);

  @override
  _ImageReviewPageState createState() => _ImageReviewPageState();
}

class _ImageReviewPageState extends State<ImageReviewPage> {
  String _res = "";
  List classes;
  bool sandwich;

  Image image;

  GlobalKey _renderKey = new GlobalKey();

  final style = TextStyle(
    color: Colors.purpleAccent,
    fontSize: 36,
    fontWeight: FontWeight.w800,
  );

  void initState() {
    super.initState();
    initModel();
  }

  @override
  void reassemble(){
    super.reassemble();
    initModel();
  }

  initModel() async {
    image = Image.file(
      File(widget.imagePath),
    );
    _res = await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  _shareImage() async {
    try {
      RenderRepaintBoundary boundary =
          _renderKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

      Uri currentUri = Uri.parse(widget.imagePath);
      print(currentUri);
      var parts = widget.imagePath.split(".");
      if (parts.length >= 2) {
        parts[parts.length - 2] = parts[parts.length - 2] + "-p";
      }
      var processedPath = parts.join(".");
      print(processedPath);

      await File(processedPath).writeAsBytes(pngBytes);

      SimpleShare.share(uri: processedPath);
    } catch (e) {
      print("exception trying to render/share image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final imageRatio = (image?.width ?? 1) / (image?.height ?? 1);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          RepaintBoundary(
            key: _renderKey,
            child: Stack(
              children: <Widget>[
                Transform.scale(
                  scale: imageRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      child: image,
                      aspectRatio: imageRatio,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: Tflite.detectObjectOnImage(
                      path: widget.imagePath,
                      model: "SSDMobileNet",
                      numResultsPerClass: 1,
                      threshold: 0.3,
                      imageStd: 255.0,
                      blockSize: 16,
                    ),
                    initialData: [],
                    builder: (context, snapshot) {
                      List recs = snapshot.data;
                      if (recs == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      final classes =
                          recs.map((rec) => rec["detectedClass"]).toList();
                      print(classes);

                      return SafeArea(
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: classes.contains("sandwich")
                                  ? Text(
                                      "SANDWICH!",
                                      style: style,
                                    )
                                  : Text(
                                      "not sandwich",
                                      style: style,
                                    ),
                            ),
                            Positioned(
                              top: 100,
                              child: Container(
                                width: size.width,
                                child: Text(
                                  classes.join(", "),
                                  style: style,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AroundShareMenu(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _shareImage,
        tooltip: 'Return to Camera',
        child: Icon(Icons.file_upload),
      ),
    );
  }
}

class AroundShareMenu extends StatelessWidget {
  const AroundShareMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.purpleAccent,
                size: 48,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: MMButton(),
          ),
        ],
      ),
    );
  }
}
