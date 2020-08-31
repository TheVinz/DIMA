import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:provider/provider.dart';

class ReviewTile extends StatelessWidget {

  final Review review;
  ReviewTile(this.review);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return FutureBuilder<String>(
      future: DatabaseServices().getAuthor(review),
      builder: (context, author) => Padding(
        padding: review.userId==user.uid ? EdgeInsets.only(left: 20.0) : EdgeInsets.only(right: 20.0),
        child: Card(
          child: ListTile(
            title: Text(author.data ?? ''),
            trailing: review.userId==user.uid ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(review.score.toString()),
                GestureDetector(
                  onTap: () => DatabaseServices().deleteReview(review),
                  child: Icon(Icons.delete),
                ),
              ],
            ) : Text(review.score.toString()),
            subtitle: Text(review.comment),
          ),
        ),
      ),
    );
  }
}

