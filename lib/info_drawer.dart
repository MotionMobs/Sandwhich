import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDrawer extends StatefulWidget {
  InfoDrawer({Key key}) : super(key: key);

  _InfoDrawerState createState() => _InfoDrawerState();
}

class _InfoDrawerState extends State<InfoDrawer> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      try{
      await launch(url);
      }catch(e){
        print("exception back from launching $url: $e");
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var bgColor = Colors.white.withOpacity(.8);
    var theme = Theme.of(context).textTheme;
    var headerTheme = theme.headline.copyWith(fontSize: 40);
    var subHeadTheme = theme.title.copyWith(fontSize: 32);
    var subTheme = theme.body1.copyWith(fontSize: 16);
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Sandwhich?",
              style: headerTheme,
            ),
            SizedBox(height: 40),
            Text(
              "*About the App",
              style: subHeadTheme,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "*Made by MotiobMobs",
                    style: subTheme,
                  ),
                  Text(
                    "*Made using TensorFlow Lite and Flutter",
                    style: subTheme,
                  ),
                  Text(
                    "*Taught the _____ model what a sandwhich was!",
                    style: subTheme,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async => await _launchURL("https://sandwhich.mm.dev"),
              child: Text(
                "*Brochure Site",
                style: subHeadTheme,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async => await _launchURL("https://motionmobs.com"),
              child: Text(
                "*MotionMobs",
                style: subHeadTheme,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "*@ us on Socials!",
              style: subHeadTheme,
            ),
          ],
        ),
      ),
    );
  }
}
