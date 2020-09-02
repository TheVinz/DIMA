class Review{
  final double score;
  final String comment;
  final String userId;
  final String path;
  final DateTime timestamp;

  Review({this.score, this.comment, this.userId, this.path, this.timestamp});


  @override
  bool operator ==(Object other) {
    if(other.runtimeType != Review) return false;
    Review o = other;
    return o.path == this.path;
  }
}