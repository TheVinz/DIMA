import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:provider/provider.dart';

class ReviewTile extends StatelessWidget {

  final Review review;
  final Animation<double> animation;
  ReviewTile(this.review, this.animation);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final isLiked = review.uidLikes.contains(user.uid);

    return SlideTransition(
      position: animation.drive(Tween(begin: Offset(1.0, 0), end: Offset.zero)),
      child: Padding(
        padding: user.uid==review.userId ? EdgeInsets.only(left: 20.0, right: 10.0) : EdgeInsets.only(left: 10.0, right: 20.0),
        child: GestureDetector(
          onDoubleTap: () => DatabaseServices(uid: user.uid).likeReview(review),
          child: Card(
            color: AppColors.grey.withAlpha(255),
            child: Column(
              children: [
                ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundColor: AppColors.lightblue,
                              child: Image.asset('assets/polimilogo.png',
                                  color: Colors.black),
                            ),
                            RatingBarIndicator(
                                unratedColor: AppColors.lightblue.withAlpha(150),
                                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                                itemSize: 10.0,
                                rating: review.score,
                                itemCount: 5,
                                itemBuilder: (_, __) => Icon(Icons.star, color: Colors.yellow[800])),
                          ],
                        ),
                        SizedBox(width: 10.0,),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: review.userId==user.uid ? 112.0 : 152),
                          child: Text(review.author, style: TextStyle(fontWeight: FontWeight.w500, ), overflow: TextOverflow.visible,)
                        ),
                        review.userId==user.uid ? Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () =>  DatabaseServices().deleteReview(review),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.delete, color: AppColors.lightblue)),
                            ),
                          ),
                        ) : Material(),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.comment,),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: FlatButton.icon(
                              padding: EdgeInsets.all(0),
                              onPressed: () => DatabaseServices(uid: user.uid).likeReview(review),
                              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red[500], size: 15.0,),
                              label: Text('${review.likes.toString()} likes', style: TextStyle(fontSize: 10.0),))
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Text('${review.timestamp.year}/${review.timestamp.month}/${review.timestamp.day}',
                            style: TextStyle(fontSize: 12.0,),
                            textAlign: TextAlign.end,

                          ),
                        ),
                      )
                    ]
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

