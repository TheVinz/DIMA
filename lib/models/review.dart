class Review{
  final double score;
  final String comment;
  final String author;
  final String path;
  final String userId;
  final DateTime timestamp;

  Review({this.score, this.comment, this.userId, this.author, this.path, this.timestamp});


  @override
  bool operator ==(Object other) {
    if(other.runtimeType != Review) return false;
    Review o = other;
    return o.path == this.path;
  }
}