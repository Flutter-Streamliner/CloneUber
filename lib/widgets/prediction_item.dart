import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_app/brand_colors.dart';
import 'package:uber_clone_app/models/prediction.dart';

import '../helpers/helper_methods.dart';
import '../helpers/request_helper.dart';
import '../models/address.dart';
import '../providers/app_data.dart';
import 'progress_dialog.dart';

class PredictionItem extends StatelessWidget {
  final Prediction prediction;

  PredictionItem(this.prediction);

  void getPlaceDetails(String placeID, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog('Please wait...'),
    );
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=${HelperMethods.API_KEY}';
    var response = await RequestHelper.getRequest(url);
    Navigator.of(context).pop();
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address(
        placeName: response['result']['name'],
        placeId: placeID,
        latitude: response['result']['geometry']['location']['lat'],
        longitude: response['result']['geometry']['location']['lng'],
      );
      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => getPlaceDetails(prediction.placeId, context),
      padding: const EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(
                  OMIcons.locationOn,
                  color: BrandColors.colorDimText,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.mainText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        prediction.secondaryText,
                        style: TextStyle(
                            fontSize: 12, color: BrandColors.colorDimText),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
