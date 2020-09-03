import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                leading:Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: exam.numReviews==0 ? AppColors.grey : AppColors.lightblue,
                      child: Image.asset('assets/polimilogo.png',
                          color: Colors.black),
                    ),
                    RatingBarIndicator(
                        unratedColor: AppColors.lightblue.withAlpha(150),
                        itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        itemSize: 13.0,
                        rating: exam.numReviews==0 ? 5 : exam.score,
                        itemCount: 5,
                        itemBuilder: (_, __) => Icon(Icons.star, color: exam.numReviews==0 ? AppColors.grey : Colors.yellow[800]))
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(exam.cfu.toString()),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.delete, color: AppColors.lightblue),
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
                transitionDuration: transitionDuration,
                transitionsBuilder: transitionsBuilder,
                pageBuilder: (context, _, __) => ExamDetail(exam: exam,))),
            title: Hero(
                flightShuttleBuilder: (flightContext, animation, direction, fromHeroContext, toHeroContext, ) {
                  final Hero toHero = toHeroContext.widget;
                  final Text widget = toHero.child;
                  return FadeTransition(
                    opacity: animation.drive(Tween(begin: 1.0, end: 0.0)),
                    child: Text(widget.data, style: TextStyle(fontSize: 16.0),),
                  );
                },
                tag: '${exam.path}_name',
                child: Text(exam.name)),
            subtitle: Hero(child: Text(exam.professor), tag: '${exam.path}_prof'),
            leading: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Hero(
                  tag: '${exam.path}_avatar',
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: exam.numReviews==0 ? AppColors.grey : AppColors.lightblue,
                    child: Image.asset('assets/polimilogo.png',
                        color: Colors.black),
                  ),
                ),
                Hero(
                  tag: '${exam.path}_rating',
                  child: RatingBarIndicator(
                      unratedColor: AppColors.lightblue.withAlpha(150),
                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      itemSize: 13.0,
                      rating: exam.numReviews==0 ? 5 : exam.score,
                      itemCount: 5,
                      itemBuilder: (_, __) => Icon(Icons.star, color: exam.numReviews==0 ? AppColors.grey : Colors.yellow[800])),
                )
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(exam.cfu.toString()),
                GestureDetector(
                  onTap: () => model.remove(exam, _builder(exam)),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.delete, color: AppColors.lightblue),
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
