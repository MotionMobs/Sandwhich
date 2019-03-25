import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sandwhich/mm_button.dart';
import 'package:tflite/tflite.dart';
import 'package:simple_share/simple_share.dart';
import 'package:sandwhich/utils/assets_utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:sandwhich/styles.dart';

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
      image = Image.file(
        File(widget.imagePath),
      );
  }

  @override
  void reassemble() {
    super.reassemble();
    initModel();
      image = Image.file(
        File(widget.imagePath),
      );
  }

  initModel() async {
    _res = await Tflite.loadModel(
      // model: "assets/ssd_mobilenet.tflite",
      // labels: "assets/ssd_mobilenet.txt",
      model: "assets/sandwich.tflite",
      labels: "assets/sandwich.txt",
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
      // print(currentUri);
      var parts = widget.imagePath.split(".");
      if (parts.length >= 2) {
        parts[parts.length - 2] = parts[parts.length - 2] + "-p";
      }
      String processedPath = parts.join(".");
      // print(processedPath);

      await File(processedPath).writeAsBytes(pngBytes);

      SimpleShare.share(uri: "$processedPath", type: "image/png");
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
                      child: image ?? SizedBox(),
                      aspectRatio: imageRatio,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: Tflite.runModelOnImage(
                      path: widget.imagePath,
                      // imageStd: 1,
                      // imageMean: 1,
                      // threshold: 0.3,
                      // numResults: 10,
                    ),
                    initialData: [],
                    builder: (context, snapshot) {
                      List recs = snapshot.data;
                      if (recs == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      print(recs);
                      // recs = recs.where((rec) => rec["index"] <= 1).toList();
                      final List<String> classes = List.from(recs.map((rec) => rec["label"]).toList());
                      print(classes);

                      return Container(
                                height: size.height / 2.5,
                                width: size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      gradientStart,
                                      gradientStop
                                    ],
                                  ),
                                ),
                                  child: SafeArea(
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              bottom: 0,
 child: classes.any((l)=>l.contains("sandwich"))
                                    ? FlareActor(
                                        AssetStrings.sandwichFlare,
                                        animation: "sandwich",
                                      )
                                    : FlareActor(
                                        AssetStrings.notSandwichFlare,
                                        animation: "not_sandwich",
                                      )),
                            Positioned(
                              top: 100,
                              child: Container(
                                width: size.width,
                                child: Text(
                                  recs.join(", "),
                                  style: style.copyWith(fontSize: 18.0),
                                ),
                              ),
                            ),
                          ],
                        ),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: _shareImage,
        tooltip: 'Return to Camera',
        child: Icon(Icons.share, size: 32.0),
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MMButton(),
            ),
          ),
        ],
      ),
    );
  }
}
