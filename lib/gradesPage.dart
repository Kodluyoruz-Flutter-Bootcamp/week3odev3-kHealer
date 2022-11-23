import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text("Student Grades"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: txtClass,
                decoration: const InputDecoration(
                    label: Text('Class'), border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: txtGrade,
                decoration: const InputDecoration(
                    label: Text('Grade'), border: OutlineInputBorder()),
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
                          return Card(
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  txtClass.text =
                                      lstGrades[index].studentnumber.toString();
                                  txtGrade.text =
                                      lstGrades[index].description.toString();
                                  selectedId = lstGrades[index].id!;
                                });
                              },
                              leading: Icon(Icons.label),
                              title: Text(
                                  "Lesson: ${lstGrades[index].studentnumber!}"),
                              subtitle: Text(
                                  "Grade: ${lstGrades[index].description.toString()}"),
                              iconColor: Colors.red,
                              trailing: GestureDetector(
                                onTap: () {
                                  deleteGrade(lstGrades[index].id!);
                                },
                                child: Icon(Icons.delete),
                              ),
                            ),
                          );
                        }),
                  )
                : Card(),
          ],
        ),
      ),
    );
  }

  saveGrade() {
    if (txtClass.text.isNotEmpty) {
      Grades grade = Grades(
          txtClass.text.toString(), txtGrade.text.toString(), widget.personId);
      dataSave(grade);
    }
  }

  dataSave(Grades grade) async {
    await dbHelper.insert(grade);
    setState(() {
      getGrades();
      txtClass.text = "";
      txtGrade.text = "";
    });
  }

  updateGrade() {
    if (selectedId > 0) {
      update(Grades.withId(selectedId, txtClass.text.toString(),
          txtGrade.text.toString(), widget.personId));
    }
  }

  Future<void> update(Grades grade) async {
    await dbHelper.update(grade);
    setState(() {
      getGrades();
      txtClass.text = "";
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
