import 'package:meta/meta.dart';

class DirectionDetails {
  final String distanceText;
  final String durationText;
  final int distanceValue;
  final int durationValue;
  final String encodedPoints;

  DirectionDetails(
      {@required this.distanceText,
      @required this.durationText,
      @required this.distanceValue,
      @required this.durationValue,
      @required this.encodedPoints});
}
