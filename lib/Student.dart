class Student {
  int? id;
  String? name;
  String? lastname;
  String? studentnumber;

  Student(this.name, this.lastname, this.studentnumber);

  Student.withId(this.id, this.name, this.lastname, this.studentnumber);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map["id"] = id;
    map["name"] = name;
    map["lastname"] = lastname;
    map["studentnumber"] = studentnumber;

    return map;
  }

  Student.getMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    lastname = map["lastname"];
    studentnumber = map["studentnumber"];
  }
}
