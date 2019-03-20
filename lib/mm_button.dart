import 'package:flutter/material.dart';
import 'package:sandwhich/utils/utils.dart';

class MMButton extends StatelessWidget {
  const MMButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async => await launchURL("https://motionmobs.com"),
      child: Text(
        "MM",
        style: TextStyle(color: Colors.blueAccent, fontSize: 36),
      ),
    );
  }
}
