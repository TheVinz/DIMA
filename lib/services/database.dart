import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polimi_reviews/models/filter.dart';
import 'package:polimi_reviews/models/review.dart';
import 'package:polimi_reviews/models/review_model.dart';
import 'package:polimi_reviews/models/school.dart';

class DatabaseServices {

  // Collection reference
  final CollectionReference schoolCollection = Firestore.instance.collection('schools');
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final String uid;

  DatabaseServices({this.uid});

  Future updateUserData(String name){
    return usersCollection.document(uid).setData({'name': name});
  }

  List<School> _schoolListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) => School(name: doc.documentID)).toList();
  }

  Stream<List<School>> get schools {
    return schoolCollection.snapshots().map(_schoolListFromSnapshot);
  }

  List<Degree> _degreeListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) => Degree(name: doc.documentID)).toList();
  }
  Stream<List<Degree>> getDegrees(String school) {
    return schoolCollection.document(school).collection('degrees')
        .snapshots().map(_degreeListFromSnapshot);
  }

  List<Exam> _examListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) =>
        Exam(
          name: doc.data['name'],
          path: doc.reference.path,
          cfu: doc.data['cfu'],
          professor: doc.data['professor'],
          description: doc.data['description'],
          score: (doc.data['total_score'] ?? 0),
          numReviews: (doc.data['num_reviews'] ?? 0),
        )).toList();
  }
  Stream<List<Exam>> getExams(Filter filter){
    return schoolCollection.document(filter.school).collection('degrees')
        .document(filter.degree).collection('exams').orderBy('name')
        .snapshots()
        .map(_examListFromSnapshot)
        .map((exams) => exams.where((element) =>
                    element.name
                        .toLowerCase()
                        .contains((filter.exam ?? '').toLowerCase()))
                    .toList());
  }

  Future submitReview(String examPath, Review review) async {

    DocumentReference oldReview = Firestore.instance.document(examPath).collection('reviews').document(uid);
    bool isUpdate = await oldReview.get().then(
        (doc) => doc.exists
    );

    if(!isUpdate){

      await Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot exam = await transaction.get(Firestore.instance.document(examPath));

        double totScore = exam.data['total_score'] ?? 0;
        int numReviews = exam.data['num_reviews'] ?? 0;

        await transaction.update(exam.reference, {
          'total_score': (totScore*numReviews + review.score)/(numReviews + 1),
          'num_reviews': numReviews + 1,
        });
      });

      return await oldReview
          .setData({
            'author' : await usersCollection.document(uid).get().then((doc) => doc.data['name']),
            'comment': review.comment,
            'score': review.score,
            'timestamp': FieldValue.serverTimestamp()});
    } else {
        await deleteReview(_reviewFromSnapshot(await oldReview.get()));
        return submitReview(examPath, review);
    }

  }

  Review _reviewFromSnapshot(DocumentSnapshot doc) {
    Timestamp ts = doc.data['timestamp'];
    return Review(
      userId: doc.documentID,
      author: doc.data['author'],
      comment: doc.data['comment'],
      score: doc.data['score'],
      path: doc.reference.path,
      likes: doc.data['likes'] ?? 0,
      uidLikes: List<String>.from(doc.data['uidLikes'] ?? []),
      timestamp: ts==null ? DateTime.now() : ts.toDate()
    );
  }
  void submitReviewsListener(String examPath, ReviewModel model){
    Firestore.instance
        .document(examPath)
        .collection('reviews')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .forEach((collection) => collection.documentChanges.forEach((element) {
          switch(element.type){
            case DocumentChangeType.added:
              model.add(_reviewFromSnapshot(element.document));
              break;
            case DocumentChangeType.removed:
              model.remove(_reviewFromSnapshot(element.document));
              break;
            case DocumentChangeType.modified:
              model.update(_reviewFromSnapshot(element.document));
          }
    }));
  }
  Future deleteReview(Review review) async {

    DocumentReference examReference = Firestore.instance.document(review.path).parent().parent();

    await Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(examReference);
      double totScore = snapshot.data['total_score'] ?? 0;
      int numReviews = snapshot.data['num_reviews'] ?? 0;
      await transaction.update(examReference, {
        'total_score': numReviews>1 ? (totScore*numReviews - review.score)/(numReviews-1) : 0.0,
        'num_reviews': numReviews-1,
      });
    });

    return await Firestore.instance.document(review.path).delete();
  }

  Future<String> getUserName(String userId){
    return usersCollection.document(userId).get().then((value) => value.data['name'].toString());
  }

  Future addFavourite(Exam exam){
    return usersCollection.document(uid).collection('favourites').add({'path': exam.path});
  }
  Future deleteFavourite(Exam exam) async{
    return usersCollection.document(uid).collection('favourites')
        .where('path', isEqualTo: exam.path)
        .getDocuments()
        .then((value) => value.documents.forEach((document) => document.reference.delete()));
  }
  Future<List<String>> get favourites {
    return usersCollection
      .document(uid)
      .collection('favourites')
      .getDocuments()
      .then((result) =>
        result.documents.map((doc) => (doc.data['path'].toString())).toList());
  }
  Future getExamFromPath(String path){
    return Firestore.instance.document(path).get().then((doc) =>
        Exam(
          name: doc.data['name'],
          path: doc.reference.path,
          cfu: doc.data['cfu'],
          professor: doc.data['professor'],
          description: doc.data['description'],
          score: (doc.data['total_score'] ?? 0.0),
          numReviews: (doc.data['num_reviews'] ?? 0),
        )
    );
  }

  Stream<Exam> examStream(String path){
    return Firestore
        .instance
        .document(path)
        .snapshots()
        .map((doc) =>
          Exam(
            name: doc.data['name'],
            path: doc.reference.path,
            cfu: doc.data['cfu'],
            professor: doc.data['professor'],
            description: doc.data['description'],
            score: (doc.data['total_score'] ?? 0),
            numReviews: (doc.data['num_reviews'] ?? 0),
          ));
  }

  Future likeReview(Review review) async {
    return await Firestore.instance.runTransaction((transaction) async {
      DocumentReference reviewRef = Firestore.instance.document(review.path);
      DocumentSnapshot snapshot = await transaction.get(reviewRef);
      List<String> uidLikes = List<String>.from(snapshot.data['uidLikes'] ?? []);
      uidLikes.contains(uid) ? uidLikes.remove(uid) : uidLikes.add(uid);
      int likes = uidLikes.length;
      await transaction.update(reviewRef, {
        'uidLikes': uidLikes,
        'likes' : likes,
      });
    });
  }

  Future<Review> getUserReview(String examPath) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .document(examPath)
        .collection('reviews')
        .document(uid)
        .get();
    return snapshot.data!=null ? _reviewFromSnapshot(snapshot) : null;
  }

}