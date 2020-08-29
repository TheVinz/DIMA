import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/exam_detail.dart';
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
        leading: CircleAvatar(
          backgroundColor: exam.numReviews==0 ? Colors.grey : getGradient(exam.score),
        ),
        title: Text(exam.name),
        subtitle: Text(exam.professor),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${exam.cfu}'),
            GestureDetector(
              onTap: () => isFav ? model.remove(exam, (c, a) => Container()) : model.add(exam),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red,)
                )
              ),
            )
          ]
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ExamDetail(exam: exam,)
          ));
        },
      ),
    );
  }
}
