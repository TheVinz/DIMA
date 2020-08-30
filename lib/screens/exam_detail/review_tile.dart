import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:provider/provider.dart';

class ReviewTile extends StatefulWidget {

  final Review review;
  ReviewTile({@required this.review});

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {

  String author;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(author == null){
      DatabaseServices().getAuthor(widget.review)
          .then((value) {
            if(ModalRoute.of(context).isCurrent)
              setState(() => author = value);
          });
    }

    return Padding(
      padding: widget.review.userId==user.uid ? EdgeInsets.only(left: 20.0) : EdgeInsets.only(right: 20.0),
      child: Card(
        child: ListTile(
          title: widget.review.userId==user.uid ? Row(
              children: [
                Text(author ?? ''),
                FlatButton.icon(
                    onPressed: () {
                      DatabaseServices().deleteReview(widget.review);
                      },
                    icon: Icon(Icons.delete),
                    label: Text('delete'))
              ]) : Text(author ?? ''),
          trailing: Text(widget.review.score.toString()),
          subtitle: Text(widget.review.comment),
        ),
      ),
    );
  }
}

