import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone_app/screens/main_page.dart';
import 'package:uber_clone_app/screens/registration_page.dart';
import 'package:uber_clone_app/utils/connection.dart';
import 'package:uber_clone_app/widgets/confirm_button.dart';
import 'package:uber_clone_app/widgets/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showSnackBar(title) {
    final SnackBar snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void login() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProgressDialog('Logging you in'));
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .catchError((error) {
      Navigator.pop(context);
      PlatformException exception = error;
      showSnackBar(exception.message);
    });

    if (userCredential != null && userCredential.user != null) {
      // verify login
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('/users/${userCredential.user.uid}');
      userRef.once().then((snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.routeName, (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Sign In as a Rider',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ConfirmButton(
                        title: 'LOGIN',
                        onPressed: () async {
                          // check network availability
                          if (!await Connection.checkConnection()) {
                            showSnackBar('No internet');
                            return;
                          }
                          if (!_emailController.text.contains('@')) {
                            showSnackBar('Please enter a valid email address');
                            return;
                          }
                          if (_passwordController.text.trim().length < 8) {
                            showSnackBar('Please enter a valid password');
                            return;
                          }
                          login();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationPage.routeName, (route) => false);
                  },
                  child: Text('Don\'t have an account, sign up here'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
