import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odev_baslangic_shared_pref_start/student_register_page.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isValid = false;

  Future<void> register() async {
    if (isValid) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((user) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(emailController.text)
            .set({
          "UserEmail": emailController.text,
          "UserPassword": passwordController.text,
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: new Text("Password isnt matched the credentials")));
    }
  }

  login() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((user) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => StudentRegisterPage()),
          (Route<dynamic> route) => false);
    });
  }

  bool _passwordVisible = true;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade900,
          title: Text("LoginPage"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: !_passwordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                FlutterPwValidator(
                  controller: passwordController,
                  minLength: 6,
                  uppercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  width: 300,
                  height: 130,
                  onSuccess: () {
                    isValid = true;
                    login();
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content:
                            new Text("Password is matched the credentials")));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      color: Colors.orange.shade700,
                      child: Text(
                        "Login",
                      ),
                      onPressed: login,
                    ),
                    MaterialButton(
                      color: Colors.orange.shade700,
                      child: Text(
                        "Register",
                      ),
                      onPressed: register,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
