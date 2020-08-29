class School {
  final String name;

  School({this.name});
}

class Degree {
  final String name;

  Degree({this.name});
}

class Exam {
  final String name;
  final int cfu;
  final String professor;
  final String path;
  final String description;
  final double score;
  final int numReviews;

  Exam({this.name, this.cfu, this.professor, this.path, this.description, this.score, this.numReviews});

  @override
  bool operator == (
      Object other
      ){
    if(other.runtimeType != Exam)
      return false;
    Exam oth = other;
    return this.path == oth.path;
  }

  @override // TODO: implement hashCode
  int get hashCode => super.hashCode;
}