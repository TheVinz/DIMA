import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/filter.dart';

import 'exam_list.dart';

class SearchResult extends StatelessWidget {

  final Filter filter;

  SearchResult({this.filter});

  @override
  Widget build(BuildContext context) {
    return ExamList(filter: filter,);
  }
}
