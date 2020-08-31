import 'package:flutter/material.dart';
import 'package:polimi_reviews/screens/home/search_screen/search_form.dart';
import 'package:polimi_reviews/services/auth.dart';
import 'package:polimi_reviews/shared/utils.dart';

class SearchScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        children: [
          AppBar(
            elevation: 0.0,
            leading: Padding(
                padding: EdgeInsets.all(5.0),
                child: LogoIcon(color: Colors.white)),
            title: Text('Polimi Reviews', style: TextStyle(fontSize: 18.0),),
            actions: [
              FlatButton.icon(onPressed:() => AuthService().signOut(),
                  icon: Icon(Icons.person, color: Colors.white,),
                  label: Text('logout', style: TextStyle(color: Colors.white, fontSize: 10.0),))
            ],
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                child: SingleChildScrollView(
                  child: SearchForm(),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
