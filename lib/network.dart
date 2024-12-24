import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHandler {
  final Connectivity _connectivity;

  NetworkHandler() : _connectivity = Connectivity();

  Future<bool> checkConnectivity(BuildContext context) async {
    var result = await _connectivity.checkConnectivity();
    print(result.first);

    if (result.first == ConnectivityResult.none) {
      _showNoConnectionDialog(context);
      return false;
    }
    return true;
  }

  void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ネットワーク接続なし'),
          content: const Text('インターネットに接続されていません。接続を確認してください。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
