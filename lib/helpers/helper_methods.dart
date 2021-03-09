import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/helpers/request_helper.dart';
import 'package:uber_clone_app/models/address.dart';
import 'package:uber_clone_app/models/direction_details.dart';
import 'package:uber_clone_app/models/user.dart';
import 'package:uber_clone_app/providers/app_data.dart';
import 'package:uber_clone_app/utils/connection.dart';

import '../global_variables.dart';
import 'request_helper.dart';

class HelperMethods {
  static String API_KEY = Platform.isAndroid ? androidKey : iOsKey;

  static void getCurrentUserInfo() async {
    firebaseUser = firebaseAuth.FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/$userId');
    userRef.once().then((DataSnapshot snapshot) {
      if (snapshot?.value != null) {
        currentUserInfo = User.fromSnapshot(snapshot);
        print('my name is ${currentUserInfo.name}');
      }
    });
  }

  static Future<String> findCordinateAddress(
      LatLng position, BuildContext context) async {
    String placeAddress = '';

    if (!await Connection.checkConnection()) {
      return placeAddress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$API_KEY';
    var response = await RequestHelper.getRequest(url);
    print('response=$response');
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
      Address pickedupAddress = Address(
          latitude: position.latitude,
          longitude: position.longitude,
          placeName: placeAddress);

      Provider.of<AppData>(context, listen: false)
          .updatePickedAddress(pickedupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$API_KEY';
    print('request url = $url');
    var response = await RequestHelper.getRequest(url);
    print('getDirectionDetails response = $response');
    if (response == 'failed') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails(
        distanceText: response['routes'][0]['legs'][0]['distance']['text'],
        durationText: response['routes'][0]['legs'][0]['duration']['text'],
        distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
        durationValue: response['routes'][0]['legs'][0]['duration']['value'],
        encodedPoints: response['routes'][0]['overview_polyline']['points']);
    print('directionDetails = $directionDetails');
    return directionDetails;
  }

  static int estimateFares(DirectionDetails details) {
    // per km = $0.3
    // per minute = $0.2
    // base fare = $3

    double baseFare = 3;
    double distanceFare = (details.distanceValue / 1000) * 0.3;
    double timeFare = (details.durationValue / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;
    return totalFare.truncate();
  }
}
