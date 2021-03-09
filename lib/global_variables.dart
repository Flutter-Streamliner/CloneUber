import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:uber_clone_app/models/user.dart';

const String androidKey = 'AIzaSyAXw7GcRdCoQE7S1yEF1aplSAiR2mIJPGs';
const String iOsKey = 'AIzaSyCfAG7BfkyrZkusIdRPOoBUPFp56trfW_o';

final CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

firebaseAuth.User firebaseUser;
User currentUserInfo;
