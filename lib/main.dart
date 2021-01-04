import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_app/screens/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:993836699208:ios:bf6d3844ab2a413ffb527d',
            apiKey: 'AIzaSyArqKe0S8aYMYwRyeQ7oN1nxsHVrUOasdI',
            projectId: 'uberclone-983d8',
            messagingSenderId: '993836699208',
            databaseURL: 'https://uberclone-983d8-default-rtdb.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:993836699208:android:38e77634e960cf32fb527d',
            apiKey: 'AIzaSyDQS215TCmCUEo0fdClm4suRkhudCIi97Y',
            messagingSenderId: '993836699208',
            projectId: 'uberclone-983d8',
            databaseURL: 'https://uberclone-983d8-default-rtdb.firebaseio.com',
          ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Uber',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
