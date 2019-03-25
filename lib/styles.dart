import 'package:flutter/material.dart';

Color bgColor = const Color(0xFF6616C5).withOpacity(0.8); // coralish#FC9E97coralish
Color primaryColor = const Color(0xFFF7D838); // yellow
Color secondaryColor = const Color(0xFFF68282); // redish
Color tertiaryColor = const Color(0xFF8ADB68); // greenish

Color gradientStart = Color(0xff000000).withOpacity(0.0); // light blue
Color gradientStop = Color(0xff000000).withOpacity(0.8);

TextStyle buttonTextStyle = const TextStyle(
  color: const Color.fromRGBO(255, 255, 255, 0.5),
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

TextStyle headerText = const TextStyle(
  fontSize: 48.0,
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w700,
  color: const Color(0xFFF7D838),
);

TextStyle infoTextStyle = const TextStyle(
  color: const Color(0XFFFFFFFF),
  fontSize: 16.0,
  height: 1.8,
  fontFamily: 'RobotoMono',
  fontWeight: FontWeight.normal,
);

TextStyle infoLinkStyle = const TextStyle(
  color: const Color(0xFFF7D838),
  fontSize: 18.0,
  height: 1.8,
  fontFamily: 'RobotoMono',
  fontWeight: FontWeight.w700,
  decoration: TextDecoration.underline
);

TextStyle infoTitleStyle = const TextStyle(
  color: const Color(0XFFFAFAFA),
  fontSize: 20.0,
  height: 1.0,
  fontFamily: 'Rubik',
  fontWeight: FontWeight.w500,
);
