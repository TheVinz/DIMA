import 'package:flutter/material.dart';
import 'package:polimi_reviews/screens/home/search_screen/search_form.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: SingleChildScrollView(
        child: SearchForm(),
      ),
    );
  }
}
