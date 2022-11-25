import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:odev_baslangic_shared_pref_start/grades.dart';
import 'package:path/path.dart';
import 'dbHelper.dart';
import 'grades.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key, required this.personId});

  final int personId;
  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  DataBaseHelper dbHelper = DataBaseHelper();

  TextEditingController txtClass = TextEditingController();
  TextEditingController txtGrade = TextEditingController();
  List<Grades> lstGrades = <Grades>[];

  int selectedId = -1;

  @override
  void initState() {
    super.initState();
    setState(() {
      getGrades();
    });
  }

  void getGrades() async {
    List<Grades> gradeFuture = await dbHelper.getAllGrades();
    setState(() {
      lstGrades = gradeFuture;
    });
  }

  String user_choice = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: const Text("Student Grades"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Choice Class",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButton(
                    hint: Text(user_choice),
                    items: [
                      DropdownMenuItem(child: Text("Math"), value: "Math"),
                      DropdownMenuItem(child: Text("Physic"), value: "Physic"),
                      DropdownMenuItem(
                          child: Text("Biology"), value: "Biology"),
                      DropdownMenuItem(
                          child: Text("Chemistry"), value: "Chemistry"),
                      DropdownMenuItem(
                          child: Text("Geometry"), value: "Geometry"),
                      DropdownMenuItem(
                          child: Text("English"), value: "English"),
                      DropdownMenuItem(
                          child: Text("Literature"), value: "Literature"),
                    ],
                    onChanged: (Object? value) {
                      setState(() {
                        user_choice = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: txtGrade,
                decoration: const InputDecoration(
                    label: Text('Enter Grade'), border: OutlineInputBorder()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: saveGrade,
                  child: const Text('Save'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orange.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: updateGrade,
                  child: const Text('Update'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900),
                  ),
                )
              ],
            ),
            lstGrades.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: lstGrades.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            background: Card(
                              child: Icon(
                                Icons.delete,
                              ),
                              color: Colors.red,
                              margin: EdgeInsets.all(4),
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction) =>
                                {deleteGrade(lstGrades[index].id!)},
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 1.0, right: 8, left: 8, bottom: 1),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      txtClass.text = lstGrades[index]
                                          .studentnumber
                                          .toString();
                                      txtGrade.text = lstGrades[index]
                                          .description
                                          .toString();
                                      selectedId = lstGrades[index].id!;
                                    });
                                  },
                                  leading: const Icon(Icons.label),
                                  title: Text(
                                      "Lesson: ${lstGrades[index].studentnumber!}"),
                                  subtitle: Text(
                                      "Grade: ${lstGrades[index].description.toString()}"),
                                  iconColor: Colors.red,
                                  trailing: GestureDetector(
                                    onTap: () {
                                      deleteGrade(lstGrades[index].id!);
                                    },
                                    child: const Icon(Icons.delete),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const Card(),
          ],
        ),
      ),
    );
  }

  saveGrade() {
    if (user_choice.isNotEmpty) {
      Grades grade =
          Grades(user_choice, txtGrade.text.toString(), widget.personId);
      dataSave(grade);
    }
  }

  dataSave(Grades grade) async {
    await dbHelper.insert(grade);
    setState(() {
      getGrades();
      user_choice = "";
      txtGrade.text = "";
    });
  }

  updateGrade() {
    if (selectedId > 0) {
      update(Grades.withId(selectedId, user_choice.toString(),
          txtGrade.text.toString(), widget.personId));
    }
  }

  Future<void> update(Grades grade) async {
    await dbHelper.update(grade);
    setState(() {
      getGrades();
      user_choice = "";
      txtGrade.text = "";
      selectedId = -1;
    });
  }

  deleteGrade(int id) {
    delete(id);
  }

  Future<void> delete(int id) async {
    await dbHelper.delete(id);
    setState(() {
      getGrades();
    });
  }
}
