import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';

class ReviewForm extends StatefulWidget {
  
  final String examPath;
  ReviewForm({@required this.examPath});
  
  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double score = 0;
  String comment = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    
    final User user = Provider.of<User>(context);
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text('Submit a review', style: TextStyle(fontWeight: FontWeight.w600),),
          SizedBox(height: 10.0,),
          TextFormField(
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 4,
            decoration: textInputDecoration.copyWith(hintText: 'Comment...',),
            validator: (val) => (val==null || val=='') ? 'Please insert a comment' : null,
            onChanged: (val) => setState(() => comment=val),
          ),
          SizedBox(height: 20.0,),
          Text('How much did you like this exam?', textAlign: TextAlign.left,),
          Slider(
            label: score.toString(),
            value: score,
            activeColor: getGradient(score),
            inactiveColor: getGradient(score),
            min: 0.0,
            max: 5.0,
            divisions: 10,
            onChanged: (val) => setState(() => score = val),
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
    );
  }
}
