import 'dart:io';

import 'package:flutter/material.dart';

class ImageReviewPage extends StatefulWidget {
  final String imagePath;

  const ImageReviewPage({Key key, @required this.imagePath}) : super(key: key);

  @override
  _ImageReviewPageState createState() => _ImageReviewPageState();
}

class _ImageReviewPageState extends State<ImageReviewPage> {
  @override
  Widget build(BuildContext context) {
    final image = File(widget.imagePath);

    return Scaffold(
      appBar: AppBar(
        title: Text("Is a Sandwich?"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image.file(image),
            // Text(widget.imagePath),
          ],
        ),
      ),
    );
  }
}
