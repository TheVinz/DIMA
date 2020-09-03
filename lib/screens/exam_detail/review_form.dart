import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewForm extends StatefulWidget {
  
  final String examPath;
  ReviewForm({@required this.examPath});
  
  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double score = 2.5;
  String comment = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    
    final User user = Provider.of<User>(context);
    
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Submit a review', style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,),
            ),
            SizedBox(height: 20.0,),
            Text('How much did you like this exam?', style: TextStyle(fontSize: 15.0),),
            SizedBox(height: 20.0,),
            Stack(children: [
              ScoreAvatar(radius: 25.0,),
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.white.withAlpha(100),
                child: Text(score.toString(),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              )
            ],),
            RatingBar(
              itemSize: 35.0,
              glow: false,
              initialRating: score,
              allowHalfRating: true,
              itemBuilder: (context, index) => Icon(Icons.star, color: Colors.yellow[800],),
              unratedColor: AppColors.grey,
              onRatingUpdate: (value) => this.setState(() => score = value),
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              minLines: 2,
              maxLines: 4,
              cursorColor: AppColors.lightblue,
              decoration: textInputDecoration.copyWith(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.lightblue)
                ),
                hintText: 'Comment...',),
              validator: (val) => (val==null || val=='') ? 'Please insert a comment' : null,
              onChanged: (val) => setState(() => comment=val),
            ),
            SizedBox(height: 20.0,),
            Visibility(
              visible: loading,
              child: Loading(),
            ),
            RaisedButton(
              child: Text("submit", style: TextStyle(color:Colors.white),),
              onPressed: () {
                if(_formKey.currentState.validate()) {
                  setState(() => loading = true);
                  DatabaseServices(uid: user.uid)
                      .submitReview(
                      widget.examPath, Review(comment: comment, score: score))
                      .then((value) {
                    setState(() => loading = false);
                    Navigator.pop(context);
                  });
                }
              })
          ],
        ),
      ),
    );
  }
}
