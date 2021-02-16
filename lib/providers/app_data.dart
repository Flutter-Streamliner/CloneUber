import 'package:flutter/material.dart';
import 'package:uber_clone_app/models/address.dart';

class AppData extends ChangeNotifier {
  Address pickeupAddress;
  Address destinationAddress;

  void updatePickedAddress(Address newAddress) {
    pickeupAddress = newAddress;
    notifyListeners();
  }

  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }
}
