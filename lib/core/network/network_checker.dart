import 'package:connectivity_plus/connectivity_plus.dart';

abstract class Networkinfo {
  Future<bool> get isConnected;
}

class NetworkinfoImpl extends Networkinfo {
  final Connectivity connectivity;

  NetworkinfoImpl({required this.connectivity});
  Future<bool> hasInternet() async {
    final connectivityrslt = await connectivity.checkConnectivity();

    if (connectivityrslt == ConnectivityResult.none) {
      return false;
    } else if (connectivityrslt == ConnectivityResult.bluetooth) {
      return false;
    }

    return true;
  }

  @override
  Future<bool> get isConnected => hasInternet();
}
