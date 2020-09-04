import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/services/database.dart';

class ReviewModel {

  static const String mostLikedFirst = 'Most liked first';
  static const String latestFirst = 'Latest first';
  static const String ratingAsc = 'Rating ascending';
  static const String ratingDesc = 'Rating descending';
  static const List<String> filterValues = [latestFirst, mostLikedFirst, ratingAsc, ratingDesc];

  final List<Review> _items = [];
  final String examPath;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final AnimatedListRemovedItemBuilder Function(Review) builder;

  String _currentFilter = latestFirst;

  ReviewModel({@required this.examPath, @required this.builder}){
    DatabaseServices db = DatabaseServices();
    db.submitReviewsListener(examPath, this);
  }

  List<Review> get items => List.unmodifiable(_items);
  String get currentFilter => _currentFilter;

  GlobalKey<AnimatedListState> get listKey => _listKey;

  void add(Review item) {
    int index = _items.indexWhere((a) {
      switch(_currentFilter){
        case mostLikedFirst:
          return a.likes.compareTo(item.likes) > 0;
        case latestFirst:
          return item.timestamp.compareTo(a.timestamp) > 0;
          break;
        case ratingAsc:
          return a.score.compareTo(item.score) > 0;
          break;
        case ratingDesc:
          return item.score.compareTo(a.score) > 0;
          break;
      }
      return false;
    });
    if(index < 0) index = items.length;
    _items.insert(index, item);
    _listKey.currentState.insertItem(index, duration: Duration(milliseconds: 500));
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

  void sort(String filter){

    if(filter==_currentFilter)
      return;

    switch(filter){
      case mostLikedFirst:
        _items.sort((a,b) => b.likes.compareTo(a.likes));
        break;
      case latestFirst:
        _items.sort((a,b) => b.timestamp.compareTo(a.timestamp));
        break;
      case ratingAsc:
        _items.sort((a,b) => a.score.compareTo(b.score));
        break;
      case ratingDesc:
        _items.sort((a,b) => b.score.compareTo(a.score));
        break;
    }

    _currentFilter = filter;

    _listKey.currentState.setState(() {});
  }
}