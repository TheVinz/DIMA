import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/review_model.dart';
import 'package:polimi_reviews/screens/exam_detail/review_tile.dart';
import 'package:polimi_reviews/services/database.dart';

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
          child: ListTile(
            title: Text(''),
            subtitle: Text(review.comment),
          ),
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

    return  AnimatedList(
          initialItemCount: model.items.length,
          key: model.listKey,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index, animation) => ReviewTile(model.items[index], animation),
        );
  }
}
