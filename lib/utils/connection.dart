import 'package:connectivity/connectivity.dart';

class Connection {
  static Future<bool> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return false;
    }
    return true;
  }
}
