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