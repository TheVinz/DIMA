import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/screens/home/favs_screen/fav_tile.dart';
import 'package:provider/provider.dart';

class FavsScreen extends StatefulWidget {
  @override
  _FavsScreenState createState() => _FavsScreenState();
}

class _FavsScreenState extends State<FavsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavsModel>(
      builder: (context, model, child) =>
        AnimatedList(
          key: model.listKey,
          itemBuilder: (context, index, animation) =>
            FavTile(
              exam: model.items[index],
              animation: animation,
              model: model),
        ));
  }
}
