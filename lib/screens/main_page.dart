import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:uber_clone_app/brand_colors.dart';
import 'package:uber_clone_app/styles/styles.dart';
import 'package:uber_clone_app/widgets/brand_divider.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'main';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();
  double mapBottomPadding = 0;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double searchSheetHeight = Platform.isIOS ? 300 : 275;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                setState(() {
                  mapBottomPadding = Platform.isAndroid ? 280 : 270;
                });
              },
            ),
            // Menu
            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
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
                      Container(
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
                              Text('Add Home'),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Your residental address',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: BrandColors.colorDimText),
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
}
