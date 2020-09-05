import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polimi_reviews/models/user.dart';
import 'package:polimi_reviews/services/database.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future register(String email, String password, String name) async {

    QuerySnapshot snapshot = await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .getDocuments();

    if(snapshot.documents.length>0){
      throw 'Username already in use';
    }

    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      
      await DatabaseServices(uid: user.uid).updateUserData(name);
      
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      switch(e){
        case 'ERROR_INVALID_EMAIL':
          throw 'Invalid email';
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw 'Email already in use';
      }
      return null;
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}