import 'package:flutter/material.dart';
import 'package:uber_clone_app/brand_colors.dart';

class ConfirmButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Color color;

  ConfirmButton(
      {@required this.title,
      this.onPressed,
      this.color = BrandColors.colorGreen});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
