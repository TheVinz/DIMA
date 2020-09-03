import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
          title: Text(review.author, style: TextStyle(fontWeight: FontWeight.w500, ),),
          leading: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 17.0,
                backgroundColor: AppColors.lightblue,
                child: Image.asset('assets/polimilogo.png',
                    color: Colors.black),
              ),
              RatingBarIndicator(
                  unratedColor: AppColors.lightblue.withAlpha(150),
                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  itemSize: 13.0,
                  rating: review.score,
                  itemCount: 5,
                  itemBuilder: (_, __) => Icon(Icons.star, color: Colors.yellow[800]))
            ],
          ),
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

