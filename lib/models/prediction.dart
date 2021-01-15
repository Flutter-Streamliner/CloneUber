import 'package:meta/meta.dart';

class Prediction {
  final String placeId;
  final String mainText;
  final String secondaryText;

  Prediction(
      {@required this.placeId,
      @required this.mainText,
      @required this.secondaryText});

  static Prediction fromJson(Map<String, dynamic> json) {
    return Prediction(
        placeId: json['place_id'],
        mainText: json['structured_formatting']['main_text'],
        secondaryText: json['structured_formatting']['secondary_text']);
  }
}
