import 'package:flutter/material.dart';
import 'package:polimi_reviews/screens/home/search_screen/search_form.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
      child: SingleChildScrollView(
        child: SearchForm(),
      ),
    );
  }
}
