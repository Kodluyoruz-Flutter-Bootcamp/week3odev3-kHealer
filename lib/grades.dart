class Grades {
  int? id;
  String? studentnumber;
  String? description;
  int? personId;

  Grades(this.studentnumber, this.description, this.personId);

  Grades.withId(this.id, this.studentnumber, this.description, this.personId);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["studentnumber"] = studentnumber;
    map["description"] = description;
    map["personId"] = personId;

    return map;
  }

  Grades.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    studentnumber = map["studentnumber"];
    description = map["description"];
    personId = map["personId"];
  }
}
