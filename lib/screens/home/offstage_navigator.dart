import 'package:flutter/material.dart';

class OffstageNavigator extends StatefulWidget {

  final Widget screen;
  final GlobalKey<NavigatorState> navigatorKey;
  OffstageNavigator(this.screen, this.navigatorKey);

  @override
  _OffstageNavigatorState createState() => _OffstageNavigatorState();
}

class _OffstageNavigatorState extends State<OffstageNavigator>
    with AutomaticKeepAliveClientMixin<OffstageNavigator>{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return  Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => widget.screen),
      observers: [HeroController()],
    );
  }
}
