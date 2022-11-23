import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:odev_baslangic_shared_pref_start/gradesPage.dart';
import 'package:odev_baslangic_shared_pref_start/login_page.dart';
import 'Student.dart';
import 'dbHelper.dart';

class StudentRegisterPage extends StatefulWidget {
  const StudentRegisterPage({super.key});

  @override
  State<StudentRegisterPage> createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  List<Student> lstStudent = <Student>[];
  TextEditingController txtName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtStudentNumber = TextEditingController();

  DataBaseHelper dbhelper = DataBaseHelper();

  int selectedId = -1;

  @override
  void initState() {
    super.initState();

    setState(() {
      getStudents();
    });
  }

  getStudents() async {
    var result = await dbhelper.getAllStudent();
    setState(() {
      lstStudent = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Text("Student Register"),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (Route<dynamic> route) => false);
              });
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: txtName,
                decoration: const InputDecoration(
                    label: Text('Name'), border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: txtLastName,
                decoration: const InputDecoration(
                    label: Text('Lastname'), border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: txtStudentNumber,
                decoration: const InputDecoration(
                    label: Text('School Number'), border: OutlineInputBorder()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: saveStudent,
                  child: const Text('Save'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orange.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: updateStudent,
                  child: const Text('Update'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900),
                  ),
                )
              ],
            ),
            lstStudent.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: lstStudent.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GradesPage(
                                        personId: lstStudent[index].id!),
                                  ),
                                );
                              },
                              leading: Icon(
                                Icons.person_pin_rounded,
                                size: 38,
                                color: Colors.red,
                              ),
                              title: Text(
                                  "${lstStudent[index].name} ${lstStudent[index].lastname!}"),
                              subtitle: Text(
                                  "School ID:${lstStudent[index].studentnumber!}"),
                              iconColor: Colors.red,
                              trailing: GestureDetector(
                                onTap: () {
                                  deleteStudent(lstStudent[index].id!);
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

  saveStudent() {
    Student student = Student(txtName.text.toString(),
        txtLastName.text.toString(), txtStudentNumber.text.toString());
    save(student);
  }

  Future<void> save(Student student) async {
    dbhelper.insertStudent(student);
    setState(() {
      getStudents();
    });
  }

  updateStudent() {
    Student student = Student.withId(selectedId, txtName.text.toString(),
        txtLastName.text.toString(), txtStudentNumber.text.toString());

    update(student);
  }

  Future<void> update(Student student) async {
    dbhelper.updateStudent(student);
    setState(() {
      getStudents();
    });
  }

  deleteStudent(int id) {
    delete(id);
  }

  Future<void> delete(int id) async {
    await dbhelper.deleteStudent(id);
    setState(() {
      getStudents();
    });
  }
}
