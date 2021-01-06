import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone_app/screens/login_page.dart';
import 'package:uber_clone_app/screens/main_page.dart';
import 'package:uber_clone_app/widgets/confirm_button.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

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

  void registerUser() async {
    auth.UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((error) {
      // check error and display message
      PlatformException exception = error;
      showSnackBar(exception.message);
    });
    if (credential.user != null) {
      print('Registration successful');
      DatabaseReference newUserRef = FirebaseDatabase.instance
          .reference()
          .child('users/${credential.user.uid}');
      // Prepare data to be saved on user table
      Map userMap = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };
      newUserRef.set(userMap);
      // Take the user to main page
      Navigator.pushNamedAndRemoveUntil(
          context, MainPage.routeName, (route) => false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
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
                  'Create a Rider\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Full name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full name',
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
                      // Email
                      TextField(
                        controller: emailController,
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
                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone number',
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
                      // Password
                      TextField(
                        controller: passwordController,
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
                        title: 'REGISTER',
                        onPressed: () async {
                          // check network availability
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet');
                            return;
                          }

                          if (fullNameController.text.trim().length < 3) {
                            showSnackBar('Please provide a valid full name');
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Please provide a correct email address');
                            return;
                          }
                          if (emailController.text.trim().length < 5) {
                            showSnackBar(
                                'Please provide a valid email address');
                            return;
                          }
                          if (phoneController.text.trim().length < 10) {
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }
                          if (passwordController.text.trim().length < 8) {
                            showSnackBar(
                                'Password must be at least 8 characters');
                            return;
                          }
                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.routeName, (route) => false);
                  },
                  child: Text('Already have a Rider account? Log in'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
