import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/helpers/request_helper.dart';
import 'package:uber_clone_app/models/address.dart';
import 'package:uber_clone_app/models/direction_details.dart';
import 'package:uber_clone_app/providers/app_data.dart';
import 'package:uber_clone_app/utils/connection.dart';

import '../global_variables.dart';
import 'request_helper.dart';

class HelperMethods {
  static String API_KEY = Platform.isAndroid ? androidKey : iOsKey;

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
        encodedPoints: response['routes'][0]['overview_polyline']['points ']);
    print('directionDetails = $directionDetails');
    return directionDetails;
  }
}
