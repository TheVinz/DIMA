import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/school.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/screens/home/favs_screen/favs_screen.dart';
import 'package:polimi_reviews/screens/home/search_screen/search_screen.dart';
import 'package:polimi_reviews/services/auth.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:polimi_reviews/shared/utils.dart';
import 'package:provider/provider.dart';

class TabIndexes{
  static final int search = 0;
  static final int favs = 1;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()];

  List<String> paths;
  int _currentTab = TabIndexes.search;

  Widget _buildOffstageNavigator(int index, Widget screen){
    return Offstage(
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => screen),
        observers: [HeroController()],
      ),
      offstage: _currentTab!=index,
    );
  }

  @override
  Widget build(BuildContext context) {

    final String uid = Provider.of<User>(context).uid;

    if(paths == null)
      DatabaseServices(uid:uid).favourites.then((value) => setState(() => paths = value));

    return paths==null? Container(color: Colors.white, child: Loading()) : WillPopScope(
      onWillPop: () async => ! await _navigatorKeys[_currentTab].currentState.maybePop(),
      child: ChangeNotifierProvider<FavsModel>(
        create: (_) => FavsModel(paths, uid:uid),
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[400],
            unselectedLabelStyle: TextStyle(fontSize: 10.0),
            selectedIconTheme: IconThemeData(size: 25.0),
            unselectedIconTheme: IconThemeData(size: 20.0),
            backgroundColor: AppColors.darkblue,
            currentIndex: _currentTab,
            onTap: (val) => val!=_currentTab ? this.setState(() => _currentTab = val) : null,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('Search')
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text('Saved')
              )
            ]
          ),
          body: Stack(
            children: [
              _buildOffstageNavigator(TabIndexes.search, SearchScreen()),
              _buildOffstageNavigator(TabIndexes.favs, FavsScreen())
            ],
          ),
        ),
      ),
    );
  }
}
