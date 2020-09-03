import 'package:flutter/material.dart';

import 'constants.dart';

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
    );
  }
}

final RouteTransitionsBuilder transitionsBuilder = (context, animation, secondaryAnimation, child) {
  return FadeTransition(
    opacity: animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease))),
    child: child,
  );
};

class ScoreAvatar extends StatelessWidget {

  final double radius;
  ScoreAvatar({this.radius=30.0});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lightblue,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/polimilogo.png', color: Colors.black),
        ],
      ),
    );
  }
}
