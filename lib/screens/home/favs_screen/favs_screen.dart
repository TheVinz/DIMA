import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/screens/home/favs_screen/fav_tile.dart';
import 'package:polimi_reviews/services/auth.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';

class FavsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            elevation: 0.0,
            leading: Padding(
                padding: EdgeInsets.all(5.0),
                child: LogoIcon(color: Colors.white)),
            title: Text('Saved exams', style: TextStyle(fontSize: 18.0),),
            actions: [
              FlatButton.icon(onPressed:() => AuthService().signOut(),
                  icon: Icon(Icons.person, color: Colors.white,),
                  label: Text('logout', style: TextStyle(color: Colors.white, fontSize: 10.0),))
            ],
          ),
          Expanded(
            child: Consumer<FavsModel>(
                builder: (context, model, child) =>
                    AnimatedList(
                      key: model.listKey,
                      itemBuilder: (context, index, animation) =>
                          FavTile(
                              exam: model.items[index],
                              model: model),
                    )),
          ),
        ],
      ),
    );
  }
}
