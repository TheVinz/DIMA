class Review{
  final double score;
  final String comment;
  final String author;
  final String path;
  final String userId;
  final DateTime timestamp;
  final int likes;
  final List<String> uidLikes;

  Review({this.score, this.comment, this.userId, this.author, this.path, this.timestamp, this.likes, this.uidLikes});


  @override
  bool operator ==(Object other) {
    if(other.runtimeType != Review) return false;
    Review o = other;
    return o.path == this.path;
  }
}