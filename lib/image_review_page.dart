import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sandwhich/mm_button.dart';
import 'package:simple_share/simple_share.dart';
import 'package:sandwhich/utils/assets_utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:sandwhich/styles.dart';

class ImageReviewPage extends StatelessWidget {
  final String imagePath;
  final List<String> classes;

  ImageReviewPage({Key key, @required this.imagePath, @required this.classes})
      : super(key: key);

  final GlobalKey _renderKey = new GlobalKey();
  final style = const TextStyle(
    color: Colors.purpleAccent,
    fontSize: 36,
    fontWeight: FontWeight.w800,
  );

  _shareImage() async {
    try {
      RenderRepaintBoundary boundary =
          _renderKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

      var parts = imagePath.split(".");
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
    final image = Image.file(File(imagePath));
    final imageRatio = (image?.width ?? 1) / (image?.height ?? 1);
    print(image);

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
                  child: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.center,
                        end: FractionalOffset.bottomCenter,
                        colors: [gradientStart, gradientStop],
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: size.height / 2.5,
                              width: size.width,
                              child: classes.any((l) => l.contains("sandwich"))
                                  ? FlareActor(
                                      AssetStrings.sandwichFlare,
                                      animation: "sandwich",
                                    )
                                  : FlareActor(
                                      AssetStrings.notSandwichFlare,
                                      animation: "not_sandwich",
                                    ),
                            ),
                          ),
                          Align(alignment: Alignment.center,child: Text(classes.join(",")),)
                        ],
                      ),
                    ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: IconButton(
                icon: const Icon(
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
