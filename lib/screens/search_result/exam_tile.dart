import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/exam_detail.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';

class ExamTile extends StatelessWidget {

  final Exam exam;
  final FavsModel model;
  ExamTile({@required this.exam, @required this.model});

  @override
  Widget build(BuildContext context) {

    final bool isFav = model.items.contains(exam);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
      child: ListTile(
        leading: Hero(
          tag: '${exam.path}_avatar',
          child: CircleAvatar(
            backgroundColor: exam.numReviews==0 ? AppColors.grey : getGradient(exam.score),
            child: Image.asset('assets/polimilogo.png',
              color: Colors.black),
          ),
        ),
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
        subtitle: Hero(tag: '${exam.path}_prof', child: Text(exam.professor)),
        trailing: GestureDetector(
          onTap: () => isFav ? model.remove(exam, (c, a) => Container()) : model.add(exam),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.yellow[800],)
          ),
        ),
        onTap: () {
          Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 700),
              transitionsBuilder: transitionsBuilder,
              pageBuilder: (context, _, __) => ExamDetail(exam: exam,)));
        },
      ),
    );
  }
}
