import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/filter.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/search_result/exam_tile.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:provider/provider.dart';

class ExamList extends StatefulWidget {

  final Filter filter;

  ExamList({@required this.filter});

  @override
  _ExamListState createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {

  @override
  Widget build(BuildContext context) {

    final FavsModel model = Provider.of<FavsModel>(context);

    return StreamBuilder<List<Exam>>(
      stream: DatabaseServices().getExams(this.widget.filter),
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) => ExamTile(exam: snapshot.data[index], model: model,))
      : Loading();
      }
    );
  }
}
