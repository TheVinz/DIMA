import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/review_model.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/screens/exam_detail/review_tile.dart';
import 'package:polimi_reviews/screens/exam_detail/reviews_filter.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatelessWidget {

  final String examPath;
  final AnimatedListRemovedItemBuilder Function(Review) builder = (review) {
    AnimatedListRemovedItemBuilder result = (context, animation) {

      final User user = Provider.of<User>(context);
      final isLiked = review.uidLikes.contains(user.uid);

      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: Offset(-1.0, 0.0),
            end: Offset.zero
          )
        ),
        child: Padding(
          padding: user.uid==review.userId ? EdgeInsets.only(left: 20.0, right: 10.0) : EdgeInsets.only(left: 10.0, right: 20.0),
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
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.delete, color: AppColors.lightblue)),
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
                                onPressed: () => {},
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
      );
    };
    return result;
  };
  ReviewList({@required this.examPath});

  @override
  Widget build(BuildContext context) {

    final ReviewModel model = ReviewModel(
        examPath: examPath,
        builder: builder
    );

    return  Column(
      children: [
        ReviewsFilter(model),
        AnimatedList(
        initialItemCount: model.items.length,
          key: model.listKey,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index, animation) => ReviewTile(model.items[index], animation),
        ),
      ],
    );

  }
}
