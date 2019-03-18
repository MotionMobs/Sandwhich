import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
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