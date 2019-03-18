import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HamburgerBar extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  HamburgerBar(this.scaffoldKey, {Key key}) : super(key: key);
  static String assetName = 'assets/sandwhich.svg';
  final Widget svg = new SvgPicture.asset(
    assetName,
    semanticsLabel: 'Sandwhich Logo',
    color: Colors.white,
    height: 32,
    width: 32,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FlatButton(
        child: svg,
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }
}
