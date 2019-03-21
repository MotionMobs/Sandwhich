import 'package:flutter/material.dart';
import 'package:sandwhich/styles.dart';
import 'package:sandwhich/utils/assets_utils.dart';
import 'package:sandwhich/utils/utils.dart';

class InfoDrawer extends StatefulWidget {
  InfoDrawer({Key key}) : super(key: key);

  _InfoDrawerState createState() => _InfoDrawerState();
}

class _InfoDrawerState extends State<InfoDrawer> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.9,
      child: Drawer(
        child: Container(
          color: bgColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "About Sandwhich",
                          style: infoTitleStyle,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "This app was built using TensorFlow Lite and Flutter. We trained the model to correctly identify sandwiches.",
                          style: infoTextStyle,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "For more information about the app, why it was built, or to get in touch with us follow us on Twitter or visit the app's website:",
                          style: infoTextStyle,
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async =>
                              await launchURL("https://twitter.com/SandwhichApp"),
                          child: Text(
                            "@SandwhichApp",
                            style: infoLinkStyle,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async =>
                              await launchURL("https://sandwhich.mm.dev"),
                          child: Text(
                            "sandwhich.mm.dev",
                            style: infoLinkStyle,
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Built by",
                          style: infoTitleStyle,
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async =>
                              await launchURL("https://motionmobs.com"),
                          child: Image.asset(
                            AssetStrings.mmLogo,
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
