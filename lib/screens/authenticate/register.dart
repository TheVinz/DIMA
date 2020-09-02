import 'package:flutter/material.dart';
import 'package:polimi_reviews/services/auth.dart';
import 'package:polimi_reviews/shared/constants.dart';
import 'package:polimi_reviews/shared/loading.dart';
import 'package:polimi_reviews/shared/utils.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _mailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  String email;
  String password;
  String name;
  String error = '';
  bool loading = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return loading ? Container(child: Loading(), color: Colors.white,) : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.all(5.0),
            child: LogoIcon(color: Colors.white)),
          backgroundColor: AppColors.darkblue,
          elevation: 0.0,
          title: Text("Sign up"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.person, color: Colors.white),
              label: Text("sign in", style: TextStyle(fontSize: 10.0, color: Colors.white),),
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
              Container(
                alignment: Alignment.center,
                child: Image.asset('assets/polimilogo.png', color: AppColors.grey,),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      TextFormField(
                        focusNode: _mailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _mailFocus.unfocus();
                          FocusScope.of(context).requestFocus(_nameFocus);
                        },
                        decoration: textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Insert an email' : null,
                        onChanged: (val){
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        focusNode: _nameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _nameFocus.unfocus();
                          FocusScope.of(context).requestFocus(_passFocus);
                        },
                        decoration: textInputDecoration.copyWith(hintText: 'Display name'),
                        validator: (val) => val.length<6 ? "Insert a 6+ chars name" : null,
                        onChanged: (val){
                          setState(() => name = val);
                        },
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        focusNode: _passFocus,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _nameFocus.unfocus();
                        },
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => obscurePassword = !obscurePassword),
                            child: Icon(
                                obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.lightblue),
                          )
                        ),
                        obscureText: obscurePassword,
                        validator: (val) => val.length<6 ? "Insert a 6+ chars password" : null,
                        onChanged: (val){
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: AppColors.lightblue,
                        child: Text("Register", style: TextStyle(color: Colors.white),),
                        onPressed: () async{
                          if(_formKey.currentState.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.register(email, password, name);
                            if(result == null){
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
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
            ]
          ),
        ),
      ),
    );
  }
}
