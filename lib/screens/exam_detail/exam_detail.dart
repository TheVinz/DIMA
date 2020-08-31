import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/review_form.dart';
import 'package:polimi_reviews/screens/exam_detail/review_list.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';

class ExamDetail extends StatefulWidget {

  final Exam exam;
  final FavsModel model;
  ExamDetail({@required this.exam, @required this.model});

  @override
  _ExamDetailState createState() => _ExamDetailState();
}

class _ExamDetailState extends State<ExamDetail> {

  Exam exam;
  bool isFav;
  Function listener;

  @override
  void dispose() {
    // TODO: implement dispose
    widget.model.removeListener(listener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    exam = widget.exam;
    isFav = widget.model.items.contains(exam);

    listener = () {
      if(this.mounted)
        setState(() => isFav = widget.model.items.contains(exam));
    };

    widget.model.addListener(listener);

    DatabaseServices().examStream(exam.path).listen((event) {
      if(this.mounted) setState(() => exam = event);
    });
  }

  void _toggleFav(){
    isFav ? widget.model.remove(exam, (context, animation) => Container())
      : widget.model.add(exam);
  }

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                    padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
                    child: Image.asset('assets/polimilogo.png',
                      color: (exam.numReviews == 0 ? Colors.black : getGradient(exam.score)).withAlpha(100),
                    )),
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Text(exam.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
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
                              FlatButton.icon(
                                icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.yellow[800]),
                                onPressed: _toggleFav,
                                label: Material(),
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
                                  Image.asset('assets/polimilogo.png', color: AppColors.grey.withAlpha(150)),
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
                  ReviewList(examPath: exam.path,),
                  SizedBox(height: 50.0,)
                ]
            ),
          ),
        ),
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

