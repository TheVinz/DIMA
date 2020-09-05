import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/favs_model.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/screens/home/favs_screen/favs_screen.dart';
import 'package:polimi_reviews/screens/home/offstage_navigator.dart';
import 'package:polimi_reviews/screens/home/search_screen/search_screen.dart';
import 'package:polimi_reviews/services/database.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:provider/provider.dart';

class TabIndexes{
  static final int search = 0;
  static final int favs = 1;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()];

  List<String> paths;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    final String uid = Provider.of<User>(context).uid;

    if(paths == null)
      DatabaseServices(uid:uid).favourites.then((value) => setState(() => paths = value));

    return paths==null? Container(color: Colors.white, child: Loading()) :
    WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_tabController.index].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_tabController.index != TabIndexes.search) {
            // select 'main' tab
            _tabController.animateTo(TabIndexes.search);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: ChangeNotifierProvider<FavsModel>(
        create: (_) => FavsModel(paths, uid:uid),
        child: Scaffold(
          bottomNavigationBar: Container(
            color: AppColors.darkblue,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.lightblue,
              indicatorColor: Colors.white,
              tabs: [
                Tab (
                  icon: Icon(Icons.search,),
                  text: 'Search'
                ),
                Tab(
                  icon: Icon(Icons.favorite_border,),
                  text: 'Saved'
                )
              ]
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              OffstageNavigator(SearchScreen(), _navigatorKeys[0]),
              OffstageNavigator(FavsScreen(), _navigatorKeys[1])
            ],
          ),
        ),
      ),
    );
  }
}
