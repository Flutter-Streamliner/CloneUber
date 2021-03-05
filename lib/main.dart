import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/global_variables.dart';
import 'package:uber_clone_app/providers/app_data.dart';
import 'package:uber_clone_app/screens/login_page.dart';
import 'package:uber_clone_app/screens/main_page.dart';
import 'package:uber_clone_app/screens/registration_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
      options: Platform.isIOS || Platform.isMacOS
          ? FirebaseOptions(
              appId: '1:993836699208:ios:21daffc4cf81311cfb527d',
              apiKey: iOsKey,
              projectId: 'uberclone-983d8',
              messagingSenderId: '993836699208',
              databaseURL:
                  'https://uberclone-983d8-default-rtdb.firebaseio.com',
            )
          : FirebaseOptions(
              appId: '1:993836699208:android:38e77634e960cf32fb527d',
              apiKey: androidKey,
              messagingSenderId: '993836699208',
              projectId: 'uberclone-983d8',
              databaseURL:
                  'https://uberclone-983d8-default-rtdb.firebaseio.com',
            ),
    );
  } catch (e) {
    print('try app catch $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Flutter Uber',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        //home: HomePage(),
        initialRoute: MainPage.routeName,
        routes: {
          RegistrationPage.routeName: (context) => RegistrationPage(),
          LoginPage.routeName: (context) => LoginPage(),
          MainPage.routeName: (context) => MainPage(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
