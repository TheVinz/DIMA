import 'package:flutter/material.dart';

Color getGradient(double score){
  int green = (score>2.5 ? 255 : score/0.5 * 50).round();
  int red = (score<=2.5 ? 255 : (2.5-score)/0.5 * 50).round();

  return Color.fromARGB(255, red, green, 0);
}

class LogoIcon extends StatelessWidget {

  final Color color;
  LogoIcon({this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      width: 99,
      child: Image.asset(
        'assets/polimilogo.png',
        height: 25,
        color: color,
      ),
    );;
  }
}
