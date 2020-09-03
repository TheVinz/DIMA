import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/services/database.dart';

class FavsModel extends ChangeNotifier {
  final _items = <Exam>[];
  final String uid;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  FavsModel(List<String> paths, {@required this.uid}){
    DatabaseServices db = DatabaseServices(uid: uid);
    paths.forEach((path) async {
      Exam exam = await db.getExamFromPath(path);
      _items.insert(0, exam);
      _listKey.currentState.insertItem(0);
      notifyListeners();
    });
  }

  List<Exam> get items => List.unmodifiable(_items);

  GlobalKey<AnimatedListState> get listKey => _listKey;

  void add(Exam item) {
    _items.insert(0, item);
    _listKey.currentState.insertItem(0);
    notifyListeners();
    DatabaseServices(uid: uid).addFavourite(item);
    _items.forEach((element) {print(element.name);});
  }

  Future remove(Exam item, AnimatedListRemovedItemBuilder builder) {
    final index = _items.indexOf(item);
    _listKey.currentState.removeItem(index, builder, duration: Duration(milliseconds: 500));
    Exam e = _items.removeAt(index);
    assert(e==item);
    notifyListeners();
    return DatabaseServices(uid: uid).deleteFavourite(item);

  }
}