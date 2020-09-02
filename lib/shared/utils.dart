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

class ScoreAvatar extends StatelessWidget {

  final double score;

  ScoreAvatar(this.score);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: getGradient(score).withAlpha(100),
      child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/polimilogo.png', color: AppColors.grey.withAlpha(150)),
            Text((score.toStringAsFixed(2)),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,),
          ]
      ),
    );
  }
}

final emptyScoreAvatar = CircleAvatar(
  radius: 30.0,
  backgroundColor: AppColors.grey,
  child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/polimilogo.png', color: Colors.grey[400]),
        Text('0',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center,),
      ]
  ),
);

final RouteTransitionsBuilder transitionsBuilder = (context, animation, secondaryAnimation, child) {
  return FadeTransition(
    opacity: animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.fastOutSlowIn))),
    child: child,
  );
};