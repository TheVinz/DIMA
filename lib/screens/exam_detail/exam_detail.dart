import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/review_form.dart';
import 'package:polimi_reviews/screens/exam_detail/review_list.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';

class ExamDetail extends StatelessWidget {

  final Exam exam;
  final ReviewList _reviewList;
  ExamDetail({@required this.exam,}):
        _reviewList = ReviewList(examPath: exam.path,);


  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
        return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: ReviewForm(examPath: exam.path,));
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsPanel,
        child: Icon(Icons.comment),
        backgroundColor: AppColors.lightblue,
      ),
      body: StreamBuilder<Exam>(
        stream: DatabaseServices().examStream(exam.path),
        builder:(context, snapshot) {
          Exam exam = snapshot.hasData ? snapshot.data : this.exam;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Container(
                        padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
                        child: Image.asset('assets/polimilogo.png',
                          color: (exam.numReviews == 0 ? Colors.black : getGradient(exam.score)).withAlpha(100),
                        )),
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(exam.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: innerBoxIsScrolled ? 1 : 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

              ];
            },
            body: Padding(
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.0, bottom: 40.0, left: 20.0, right: 20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Consumer<FavsModel>(
                                    builder: (context, model, _) {
                                      bool isFav = model.items.contains(exam);
                                      return FlatButton.icon(
                                        icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.yellow[800]),
                                        onPressed: () =>
                                          isFav ? model.remove(exam, (context, animation) => Material()) : model.add(exam),
                                        label: Material(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Center(
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: exam.numReviews==0 ? AppColors.grey : getGradient(exam.score).withAlpha(100),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset('assets/polimilogo.png',
                                            color: exam.numReviews==0 ? Colors.grey[350] : AppColors.grey.withAlpha(150)),
                                        Text((exam.numReviews==0 ? '0' : exam.score.toStringAsFixed(2)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                          ),
                                          textAlign: TextAlign.center,),
                                      ]
                                  ),
                                ),
                              ),
                              Divider(height: 20, thickness: 1,),
                              _Entry(title: "Teaching professor", value: exam.professor),
                              Divider(height: 20, thickness: 1,),
                              _Entry(title: "CFU", value: exam.cfu.toString()),
                              Divider(height: 20, thickness: 2,),
                              Text(exam.description),
                            ],
                          ),
                        ),
                      ),
                      Text('Reviews', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
                      _reviewList,
                      SizedBox(height: 50.0,)
                    ]
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Entry extends StatelessWidget {

  final String title;
  final String value;

  _Entry({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0,),)),
        Expanded(child: Text(value, style: TextStyle(fontSize: 14.0), overflow: TextOverflow.visible, textAlign: TextAlign.center,))
      ],
    );
  }
}

