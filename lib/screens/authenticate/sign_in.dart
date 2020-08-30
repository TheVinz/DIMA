import 'package:flutter/material.dart';
import 'package:polimi_reviews/services/auth.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:polimi_reviews/shared/utils.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email;
  String password;
  String error = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? Container(child: Loading(), color: Colors.white) :
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
              padding: EdgeInsets.all(5.0),
              child: LogoIcon(color: Colors.white)),
          backgroundColor: AppColors.darkblue,
          elevation: 0.0,
          title: Text("Sign in"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text("register", style: TextStyle(fontSize: 10.0, color: Colors.white),),
              onPressed: () {
                widget.toggleView();
            },)
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Center(
                  child: Image.asset('assets/polimilogo.png',
                    color: AppColors.grey,
                    width: double.infinity,
                  )
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0,),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) => val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val){
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0,),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Password'),
                          obscureText: true,
                          validator: (val) => val.length<6 ? 'Enter a password 6+ chars long' : null,
                          onChanged: (val){
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 20.0,),
                        RaisedButton(
                          color: AppColors.lightblue,
                          child: Text("SignIn", style: TextStyle(color: Colors.white),),
                          onPressed: () async{
                            if(_formKey.currentState.validate()){
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth.signIn(email, password);
                              if(result == null){
                                setState(() {
                                  loading = false;
                                  error = 'Could not sign in with those credentials';
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 20.0,),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
