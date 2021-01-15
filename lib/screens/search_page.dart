import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/brand_colors.dart';
import 'package:uber_clone_app/global_variables.dart';
import 'package:uber_clone_app/helpers/request_helper.dart';
import 'package:uber_clone_app/models/prediction.dart';
import 'package:uber_clone_app/providers/app_data.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  FocusNode _focusDestionation = FocusNode();
  bool _focused = false;

  void setFocus() {
    if (!_focused) {
      FocusScope.of(context).requestFocus(_focusDestionation);
      _focused = true;
    }
  }

  void searchPlace(String placeName) async {
    if (placeName.length <= 1) {
      return;
    }
    String apiKey = Platform.isAndroid ? androidKey : iOsKey;
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$apiKey&sessiontoken=1234567890';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      List jsonList = response['predictions'];
      List<Prediction> predictions = jsonList
          .map((prediction) => Prediction.fromJson(prediction))
          .toList() as List<Prediction>;
      print('PREDICTIONS = $predictions');
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    String address =
        Provider.of<AppData>(context).pickeupAddress.placeName ?? '';
    _pickupController.text = address;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 210,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          'Set Destination',
                          style:
                              TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: _pickupController,
                              decoration: InputDecoration(
                                hintText: 'Pickup location',
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 10, top: 8, bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (place) => searchPlace(place),
                              focusNode: _focusDestionation,
                              controller: _destinationController,
                              decoration: InputDecoration(
                                hintText: 'Where to?',
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 10, top: 8, bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
