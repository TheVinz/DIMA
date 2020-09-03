import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/filter.dart';
import 'package:polimi_reviews/services/auth.dart';
import 'package:polimi_reviews/shared/utils.dart';

import 'exam_list.dart';

class SearchResult extends StatelessWidget {

  final Filter filter;

  SearchResult({this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Search result', style: TextStyle(fontSize: 18.0),),
        actions: [
          FlatButton.icon(onPressed:() => AuthService().signOut(),
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text('logout', style: TextStyle(color: Colors.white, fontSize: 10.0),))
        ],
      ),
      body: ExamList(filter: filter,)
    );
  }
}
