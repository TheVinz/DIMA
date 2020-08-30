import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          color: AppColors.lightblue,
          size: 50.0,
        )
      ),
    );
  }
}
