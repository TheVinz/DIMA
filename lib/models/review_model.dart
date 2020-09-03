import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/services/database.dart';

class ReviewModel {
  final List<Review> _items = [];
  final String examPath;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final AnimatedListRemovedItemBuilder Function(Review) builder;

  ReviewModel({@required this.examPath, @required this.builder}){
    DatabaseServices db = DatabaseServices();
    db.submitReviewsListener(examPath, this);
  }

  List<Review> get items => List.unmodifiable(_items);

  GlobalKey<AnimatedListState> get listKey => _listKey;

  void add(Review item) {
    _items.insert(0, item);
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 500));
  }

  void remove(Review item) {
    final index = _items.indexOf(item);
    if(_listKey.currentState != null)
      _listKey.currentState.removeItem(index, builder(item), duration: Duration(milliseconds: 500));
    Review e = _items.removeAt(index);
    assert(e==item);
  }

  void update(Review item){
    final int index = _items.indexOf(item);
    _items[index] = item;
    if (_listKey.currentState!=null) _listKey.currentState.setState(() {});
  }
}