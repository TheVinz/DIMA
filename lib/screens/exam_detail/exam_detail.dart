import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:polimi_reviews/external/custom_nested_scroll_view.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/screens/exam_detail/review_form.dart';
import 'package:polimi_reviews/screens/exam_detail/review_list.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
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
  final ScrollController _scroll = ScrollController();


  @override
  void initState() {
    super.initState();
    exam = widget.exam;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
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
    _controller.dispose();

    super.dispose();
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

    return WillPopScope(
      onWillPop: () => _scroll
          .animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease)
          .then((_) async {
            await _controller.reverse();
            Navigator.of(context).pop();
            return true;
          })
      ,
      child: Scaffold(
        floatingActionButton: FadeTransition(
          opacity: _scoreAnimation,
          child: FloatingActionButton(
            onPressed: scrollable ? _showSettingsPanel : null,
            child: Icon(Icons.comment),
            backgroundColor: AppColors.lightblue,
          ),
        ),
        body: CustomNestedScrollView(
          controller: _scroll,
          physics: scrollable ? ScrollPhysics() : NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  Consumer<FavsModel>(
                    builder: (_, model, __) => GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                          child: Icon(model.items.contains(exam) ? Icons.favorite : Icons.favorite_border, color: Colors.red[800])),
                      onTap: () => model.items.contains(exam) ?
                        model.remove(exam, (context, animation) => Material())
                        : model.add(exam),
                    ),
                  ),
                ],
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
                      child: Image.asset('assets/polimilogo.png',
                        color: Colors.black,
                      )),
                  title: Hero(
                    flightShuttleBuilder: (flightContext, animation, direction, fromHeroContext, toHeroContext, ) {
                      final Hero toHero = toHeroContext.widget;
                      final Text widget = toHero.child;
                      return FadeTransition(
                        opacity: animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease))),
                        child: Container(
                          color: AppColors.darkblue.withAlpha(100),
                          child: Text(widget.data,
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),)),
                      );
                    },
                    tag: '${exam.path}_name',
                    child: Text(exam.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
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
                                Text('Users rating',
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.0,),
                                Center(
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: '${exam.path}_avatar',
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundColor: exam.numReviews==0 ? AppColors.grey : AppColors.lightblue,
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset('assets/polimilogo.png', color: Colors.black),
                                                FadeTransition(
                                                  opacity: _scoreAnimation,
                                                  child: CircleAvatar(
                                                    radius: 30.0,
                                                    backgroundColor: Colors.white.withAlpha(100),
                                                    child: Text((exam.numReviews==0 ? '' : exam.score.toStringAsFixed(2)),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24.0,
                                                      ),
                                                      textAlign: TextAlign.center,),
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                      Hero(
                                        tag: '${exam.path}_rating',
                                        child: RatingBarIndicator(
                                            unratedColor: AppColors.lightblue.withAlpha(150),
                                            itemSize: 25.0,
                                          rating: exam.numReviews==0 ? 5 : exam.score,
                                          itemCount: 5,
                                          itemBuilder: (_, __) => Icon(Icons.star, color: exam.numReviews==0 ? AppColors.grey : Colors.yellow[800])),
                                      )
                                    ],
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
      ),
    );
  }
}
