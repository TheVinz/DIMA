import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/screens/exam_detail/review_tile.dart';
import 'package:polimi_reviews/services/database.dart';

class ReviewList extends StatelessWidget {

  final String examPath;
  ReviewList({@required this.examPath});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: DatabaseServices().getReviews(examPath),
      builder: (context, snapshot){
        return snapshot.hasData && snapshot.data.length>0 ? ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) => ReviewTile(review: snapshot.data[index]),
        ) : Container(
          child: Text('No review found.')
        );
      },
    );
  }
}
