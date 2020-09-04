import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/review_model.dart';
import 'package:polimi_reviews/screens/exam_detail/review_tile.dart';
import 'package:polimi_reviews/screens/exam_detail/reviews_filter.dart';
import 'package:polimi_reviews/shared/constants.dart';

class ReviewList extends StatelessWidget {

  final String examPath;
  final AnimatedListRemovedItemBuilder Function(Review) builder = (review) {
    AnimatedListRemovedItemBuilder result = (context, animation) {
      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: Offset(-1.0, 0.0),
            end: Offset.zero
          )
        ),
        child: Card(
          color: AppColors.grey,
          child: Column(
            children: [
              ListTile(
                title: Text(review.author),
                subtitle: Text(review.comment),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text('${review.timestamp.year}/${review.timestamp.month}/${review.timestamp.day}',
                        style: TextStyle(fontSize: 12.0,),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        )
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
