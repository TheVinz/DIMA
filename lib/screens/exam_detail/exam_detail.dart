import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polimi_reviews/external/custom_nested_scroll_view.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/review_form.dart';
import 'package:polimi_reviews/screens/exam_detail/review_list.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';

class ExamDetail extends StatefulWidget {

  final Exam exam;
  ExamDetail({@required this.exam});

  @override
  _ExamDetailState createState() => _ExamDetailState();
}

class _ExamDetailState extends State<ExamDetail> with SingleTickerProviderStateMixin {

  Exam exam;
  ReviewList _reviewList;
  AnimationController _controller;
  Animation _scoreAnimation;
  bool scrollable = false;


  @override
  void initState() {
    super.initState();
    exam = widget.exam;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );
    _reviewList = ReviewList(examPath: exam.path,);
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(transitionDuration, () {
        if(this.mounted){
          _controller.forward();
          setState(() => scrollable = true);
        }
      });
    });

    DatabaseServices().examStream(exam.path).listen((event) {
      if(this.mounted) setState(() => exam = event);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
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
      floatingActionButton: FadeTransition(
        opacity: _scoreAnimation,
        child: FloatingActionButton(
          onPressed: scrollable ? _showSettingsPanel : null,
          child: Icon(Icons.comment),
          backgroundColor: AppColors.lightblue,
        ),
      ),
      body: CustomNestedScrollView(
        physics: scrollable ? ScrollPhysics() : NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: innerBoxIsScrolled ?
                Text(
                  exam.name,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.fade,
                ) : null,
              actions: innerBoxIsScrolled ? [
                Consumer<FavsModel>(
                  builder: (_, model, __) => GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                        child: Icon(model.items.contains(exam) ? Icons.star : Icons.star_border, color: Colors.yellow[800])),
                    onTap: () => model.items.contains(exam) ?
                      model.remove(exam, (context, animation) => Material())
                      : model.add(exam),
                  ),
                ),
              ] : [],
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
                titlePadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: !innerBoxIsScrolled ?
                  Hero(
                    flightShuttleBuilder: (flightContext, animation, direction, fromHeroContext, toHeroContext, ) {
                      final Hero toHero = toHeroContext.widget;
                      final Text widget = toHero.child;
                      return FadeTransition(
                        opacity: animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease))),
                        child: Container(
                          color: AppColors.darkblue.withAlpha(100),
                          child: Text(widget.data,
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,)),
                      );
                    },
                    tag: '${exam.path}_name',
                    child: Text(exam.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        backgroundColor: AppColors.darkblue.withAlpha(200)
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ) : null,
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(5),
            child:
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.0, bottom: 40.0, left: 20.0, right: 20.0),
                          child: Column(
                            children: [
                              Center(
                                child: Hero(
                                  flightShuttleBuilder: (flightContext, animation, direction, fromHeroContext, toHeroContext, ) {
                                    final Color target = exam.numReviews==0 ? Colors.grey[400] : AppColors.grey.withAlpha(150);
                                    final a = target.alpha;
                                    final r = target.red;
                                    final g = target.green;
                                    final b = target.blue;
                                    double tmp = 1-animation.value;
                                    return CircleAvatar(
                                      backgroundColor: exam.numReviews==0 ? AppColors.grey : getGradient(exam.score).withAlpha((100+animation.value * (255-100)).round()),
                                      child: Image.asset('assets/polimilogo.png', color:
                                          Color.fromARGB(a+(animation.value*(255-a)).round(),
                                              (tmp*(r)).round(),
                                              (tmp*(g)).round(),
                                              (tmp*(b)).round()),),
                                      );
                                  },
                                  tag: '${widget.exam.path}_avatar',
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: exam.numReviews==0 ? AppColors.grey : getGradient(exam.score).withAlpha(100),
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset('assets/polimilogo.png', color: exam.numReviews==0 ? Colors.grey[400] : AppColors.grey.withAlpha(150)),
                                          FadeTransition(
                                            opacity: _scoreAnimation,
                                            child: Text((exam.numReviews==0 ? '0' : exam.score.toStringAsFixed(2)),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                              ),
                                              textAlign: TextAlign.center,),
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                              ),
                              Divider(height: 20, thickness: 1,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text('Teaching professor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0,),)),
                                  Expanded(child: Hero(
                                    tag: '${exam.path}_prof',
                                    child: Text(exam.professor, style: TextStyle(fontSize: 16.0), overflow: TextOverflow.visible, textAlign: TextAlign.center,
                                    )))
                                ],
                              ),
                              Divider(height: 20, thickness: 1,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text('CFU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0,),)),
                                  Expanded(child: Text(exam.cfu.toString(), style: TextStyle(fontSize: 16.0), overflow: TextOverflow.visible, textAlign: TextAlign.center,))
                                ],
                              ),
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
      ),
    );
  }
}
