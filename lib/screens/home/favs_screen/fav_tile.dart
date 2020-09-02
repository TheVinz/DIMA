import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/exam_detail.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';

class FavTile extends StatelessWidget {

  final Exam exam;
  final FavsModel model;

  FavTile({this.exam, this.model});

  AnimatedListRemovedItemBuilder _builder(Exam exam) {
    Function builder = (BuildContext context, Animation<double> animation) {
      return SlideTransition(
          position: animation.drive(Tween(
              begin: Offset(-1.0, 0.0),
              end: Offset.zero)
          ),
          child: Card(
              child: ListTile(
                title: Text(exam.name),
                subtitle: Text(exam.professor),
                leading: CircleAvatar(
                  backgroundColor: exam.numReviews == 0
                      ? AppColors.grey
                      : getGradient(exam.score),
                  child: Image.asset(
                      'assets/polimilogo.png', color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(exam.cfu.toString()),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.delete_sweep),
                    )
                  ],
                ),
              )
          )
      );
    };
    return builder;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<Exam>(
      stream: DatabaseServices().examStream(exam.path),
      builder: (context, snapshot) {
        Exam exam = snapshot.hasData ? snapshot.data : this.exam;

        return Card(
          child: ListTile(
            onTap: () => Navigator.push(context, PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder: transitionsBuilder,
                pageBuilder: (context, _, __) => ExamDetail(exam: exam,))),
            title: Text(exam.name),
            subtitle: Text(exam.professor),
            leading: CircleAvatar(
              backgroundColor: exam.numReviews==0 ? AppColors.grey : getGradient(exam.score),
              child: Image.asset('assets/polimilogo.png', color: Colors.black),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(exam.cfu.toString()),
                GestureDetector(
                  onTap: () => model.remove(exam, _builder(exam)),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.delete_sweep, color: AppColors.lightblue),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
