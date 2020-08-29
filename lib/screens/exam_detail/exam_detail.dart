import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/review_form.dart';
import 'package:polimi_reviews/screens/exam_detail/review_list.dart';
import 'package:polimi_reviews/services/database.dart';

class ExamDetail extends StatelessWidget {

  final Exam exam;
  ExamDetail({@required this.exam});

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: ReviewForm(examPath: exam.path,));
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsPanel,
        child: Icon(Icons.comment),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 40.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Text(exam.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,),
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

