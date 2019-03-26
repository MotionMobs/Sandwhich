import "package:flutter/material.dart";
import "dart:async";
import "package:sandwhich/utils/assets_utils.dart";
import "package:sandwhich/styles.dart";
import "package:sandwhich/main.dart";

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

Widget _cautionHighlighted(BuildContext context) {
  Paint paint = Paint();
  paint.color = primaryColor;
  return Text(
    '  Please use caution  ',
    style: TextStyle(
      background: paint,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 1.4,),
  );
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: bgColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AssetStrings.logo,
                width: screenSize.width / 1,
                height: screenSize.height / 8,
              ),
              Text(
                "Sandwhich",
                style: headerText,
              ),
              SizedBox(height: 40.0),
              Text(
                "All identified sandwiches may not be edible.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              _cautionHighlighted(context)
            ],
          ),
        ],
      ),
    );
  }
}
