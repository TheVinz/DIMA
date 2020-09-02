import 'package:flutter/material.dart';

class AppColors{
    static const Color darkblue = Color.fromARGB(255, 15,44,83);
    static const Color lightblue = Color.fromARGB(255, 84,122,176);
    static const Color grey = Color.fromARGB(255, 233,233,233);
}

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lightblue, width: 2.0)
    ),
  );

final RouteTransitionsBuilder transitionsBuilder = (context, animation, secondaryAnimation, child) {
        final begin = Offset(0.0, 1.0);
        final end = Offset.zero;
        final curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
            position: animation.drive(tween),
            child: child,
        );
    };