import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tflite/tflite.dart';
import 'package:simple_share/simple_share.dart';
import 'package:sandwhich/utils.dart';

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

  GlobalKey _renderKey = new GlobalKey();

  void initState() {
    super.initState();
    initModel();
  }

  initModel() async {
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
    final image = File(widget.imagePath);

    final style = TextStyle(
      color: Colors.purpleAccent,
      fontSize: 36,
      fontWeight: FontWeight.w800,
    );

    return RepaintBoundary(
      key: _renderKey,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
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

                      return Column(
                        children: <Widget>[
                          classes.contains("sandwich")
                              ? Text(
                                  "SANDWICH!",
                                  style: style,
                                )
                              : Text(
                                  "not sandwich",
                                  style: style,
                                ),
                          Text(
                            classes.join(", "),
                            style: style,
                          )
                        ],
                      );
                    },
                  ),
                ),
                AroundShareMenu()
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: _shareImage,
          tooltip: 'Return to Camera',
          child: Icon(Icons.file_upload),
        ),
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
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.purpleAccent,
              size: 48,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () async => await launchURL("https://motionmobs.com"),
            child: Text(
              "MM",
              style: TextStyle(color: Colors.blueAccent, fontSize: 36),
            ),
          ),
        ),
      ],
    );
  }
}
