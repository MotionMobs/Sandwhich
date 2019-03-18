import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

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

  @override
  Widget build(BuildContext context) {
    final image = File(widget.imagePath);

    return Scaffold(
      appBar: AppBar(
        title: Text("Is a Sandwich?"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.file(image),
                  FutureBuilder(
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
                      final style = TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      );
                      return Center(
                        child: Column(
                          children: <Widget>[
                            classes.contains("sandwich")
                                ? Text(
                                    "SANDWICH!",
                                    style: style,
                                  )
                                : Text("not sandwich"),
                            Text(
                              classes.join(", "),
                              style: style,
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
