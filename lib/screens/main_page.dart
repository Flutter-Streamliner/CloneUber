import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/brand_colors.dart';
import 'package:uber_clone_app/helpers/helper_methods.dart';
import 'package:uber_clone_app/providers/app_data.dart';
import 'package:uber_clone_app/screens/search_page.dart';
import 'package:uber_clone_app/styles/styles.dart';
import 'package:uber_clone_app/widgets/brand_divider.dart';

import '../helpers/helper_methods.dart';
import '../providers/app_data.dart';
import '../widgets/progress_dialog.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'main';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapControllerCompleter = Completer();
  GoogleMapController _mapController;
  double mapBottomPadding = 0;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double searchSheetHeight = Platform.isIOS ? 300 : 275;

  Position currentPosition;

  void setupPositionLocator() async {
    currentPosition = await _determinePosition();

    LatLng pos = LatLng(currentPosition.latitude, currentPosition.longitude);
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom: 14);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    try {
      String address = await HelperMethods.findCordinateAddress(pos, context);
      print('address = $address');
    } catch (e) {
      print('failed to findCordinateAddress $e');
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permantly denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permission are denied (actual value: $permission).');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Container(
          width: 250,
          color: Colors.white,
          child: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Container(
                  color: Colors.white,
                  height: 160,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/user_icon.png',
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Johny Luck',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Brand-Bold'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('View Profile'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                BrandDivider(),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(OMIcons.cardGiftcard),
                  title: Text('Free Rides', style: kDrawerItemStyle),
                ),
                ListTile(
                  leading: Icon(OMIcons.creditCard),
                  title: Text('Payments', style: kDrawerItemStyle),
                ),
                ListTile(
                  leading: Icon(OMIcons.history),
                  title: Text('Ride History', style: kDrawerItemStyle),
                ),
                ListTile(
                  leading: Icon(OMIcons.contactSupport),
                  title: Text('Support', style: kDrawerItemStyle),
                ),
                ListTile(
                  leading: Icon(OMIcons.info),
                  title: Text('About', style: kDrawerItemStyle),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _mapControllerCompleter.complete(controller);
                _mapController = controller;
                setState(() {
                  mapBottomPadding = Platform.isAndroid ? 280 : 270;
                });
                setupPositionLocator();
              },
            ),
            // Menu
            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.menu, color: Colors.black87),
                  ),
                ),
              ),
            ),
            // Search
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: searchSheetHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text('Nice to see you!', style: TextStyle(fontSize: 10)),
                      Text(
                        'Where are you going?',
                        style:
                            TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                          if (response == 'getDirection') {
                            await getDirection();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Search Destination'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Row(
                        children: [
                          Icon(OMIcons.home, color: BrandColors.colorDimText),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 90,
                                child: Expanded(
                                  child: Text(
                                    Provider.of<AppData>(context)
                                                .pickeupAddress !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .pickeupAddress
                                            .placeName
                                        : 'Add Home',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Your residental address',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: BrandColors.colorDimText),
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BrandDivider(),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Icon(OMIcons.workOutline,
                              color: BrandColors.colorDimText),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add Work'),
                              SizedBox(
                                height: 3,
                              ),
                              Text('Your office address',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: BrandColors.colorDimText)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickeupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;
    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog('Please wait'),
    );
    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);
    Navigator.pop(context);
    print(thisDetails);
  }
}
