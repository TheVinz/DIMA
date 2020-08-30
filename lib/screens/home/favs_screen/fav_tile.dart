import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/exam_detail.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';

class FavTile extends StatelessWidget {

  final Exam exam;
  final FavsModel model;
  final Animation animation;
  FavTile({this.exam, this.animation, this.model});

  @override
  Widget build(BuildContext context) {

    final AnimatedListRemovedItemBuilder builder = (BuildContext context, Animation<double> animation) {
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
                  backgroundColor: exam.numReviews==0 ? AppColors.grey : getGradient(exam.score),
                  child: Image.asset('assets/polimilogo.png', color: Colors.black),
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

    return Card(
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => ExamDetail(exam: exam,)
        )),
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
              onTap: () => model.remove(exam, builder),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.delete_sweep),
              ),
            )
          ],
        ),
      ),
    );
  }
}