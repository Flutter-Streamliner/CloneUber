import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:uber_clone_app/brand_colors.dart';
import 'package:uber_clone_app/models/prediction.dart';

class PredictionItem extends StatelessWidget {
  final Prediction prediction;

  PredictionItem(this.prediction);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
