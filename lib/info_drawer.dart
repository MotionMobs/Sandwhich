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
    var theme = Theme.of(context).textTheme;
    var headerTheme = theme.headline.copyWith(fontSize: 40);
    var subHeadTheme = theme.title.copyWith(fontSize: 32);
    var subTheme = theme.body1.copyWith(fontSize: 16);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    AssetStrings.logo,
                    width: 100.0,
                    height: 100.0,
                  ),
                  Text(
                    "Sandwhich",
                    style: headerText,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 16),
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
                    "For more information about the app, why it was built, or to get in touch with us please visit the app's website:",
                    style: infoTextStyle,
                  ),
                  SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async =>
                        await launchURL("https://sandwhich.mm.dev"),
                    child: Text(
                      "sandwhich.mm.dev",
                      style: infoLinkStyle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Follow Us",
                    style: infoTitleStyle,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "@sandwhich_app",
                    style: infoLinkStyle,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "@sandwhich_app",
                    style: infoLinkStyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
