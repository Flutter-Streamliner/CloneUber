import 'package:flutter/material.dart';
import 'package:uber_clone_app/brand_colors.dart';
import 'package:uber_clone_app/screens/registration_page.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = 'login';
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
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: BrandColors.colorGreen,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
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
}
