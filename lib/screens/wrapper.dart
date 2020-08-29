import 'package:flutter/material.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user == null)
      return Authenticate();
    else return Home();
  }
}
