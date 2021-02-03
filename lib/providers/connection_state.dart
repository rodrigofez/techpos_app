import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class CheckConnectionState with ChangeNotifier {
  CheckConnectionState({
    @required this.port,
    @required this.address,
  }) {
    autoCheckConnectionStatus();
  }

  String port;
  String address;
  bool _internetOn;
  bool _serverOn;
  Timer _connectionTimer;
  bool isAuth;

  bool get internetOn {
    if (_internetOn == null) {
      return false;
    } else {
      return _internetOn;
    }
  }

  bool get serverOn {
    if (_serverOn == null) {
      return false;
    } else {
      return _serverOn;
    }
  }

  void autoCheckConnectionStatus() {
    _connectionTimer = Timer(Duration(seconds: 2), checkConnectionStatus);
  }

  void changeConnectionStatus(bool internet, bool server) {
    if (_internetOn != internet || _serverOn != server) {
      _internetOn = internet;
      _serverOn = server;
      print('CHANGE CONNECTION = $_serverOn');
      notifyListeners();
    }
  }

  Future<void> checkConnectionStatus() async {
    // print('CHECKCONNECTIONSTATUS EXECUTED');
    // print('_serverOn = $_serverOn');
    if (address == null || port == null) {
      changeConnectionStatus(false, false);
      return;
    }

    try {
      await http.head('http://$address:$port/flutter-signalr.html');
      // print(response.statusCode);
      autoCheckConnectionStatus();
      changeConnectionStatus(true, true);
    } catch (error) {
      int index = error.toString().indexOf('errno = ');
      int errorCode =
          int.parse(error.toString().substring(index + 8, index + 11).trim());

      if (errorCode == 101) {
        changeConnectionStatus(false, false);
      } else if (errorCode == 110) {
        changeConnectionStatus(true, false);
      }

      print(error.toString().indexOf('errno = '));
      print(error.toString().substring(index + 8, index + 11));

      autoCheckConnectionStatus();
    }
  }
}
