import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';

class ReviewTile extends StatelessWidget {

  final Review review;
  final Animation<double> animation;
  ReviewTile(this.review, this.animation);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return SlideTransition(
      position: animation.drive(Tween(begin: Offset(1.0, 0), end: Offset.zero)),
      child: Card(
        child: ListTile(
          title: Text(review.author, style: TextStyle(fontWeight: FontWeight.w500),),
          leading: ScoreAvatar(review.score, radius: 16.0,),
          trailing: review.userId==user.uid ? GestureDetector(
                onTap: () =>  DatabaseServices().deleteReview(review),
                child: Icon(Icons.delete, color: AppColors.lightblue),
              ) : null,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(review.comment,),
              Container(
                alignment: Alignment.bottomRight,
                child: Text('${review.timestamp.year}/${review.timestamp.month}/${review.timestamp.day}',
                  style: TextStyle(fontSize: 12.0,), textAlign: TextAlign.end,),
              )
            ],
          ),
        ),
      ),
    );
  }
}

