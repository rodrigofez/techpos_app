import 'dart:convert';

import 'package:NodePos/config/querys.dart';
import 'package:NodePos/providers/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  bool _isLogged;
  dynamic userData;
  String token;
  String uri;

  //localUser related data
  String _userName;
  bool _isAdmin;
  String _userRole;

  String get userRole => _userRole;
  String get userName => _userName;

  User({this.token, this.uri});

  Future<Map<String, dynamic>> signInLocalUser(pin) async {
    try {
      print('dentro de try');
      print(pin);
      print(uri);
      print(token);
      dynamic response = await DataGQL().cQuery(
        SambaQuery().userLogIn(pin),
        uri,
        token,
      );
      print(response);

      var responseUserName = response['data']['name']['name'];
      if (responseUserName == '*') {
        return {
          'isSuccessful': false,
          'error': 'No existe el usuario',
        };
      }
      print('Hay reespuesta');

      _userRole = response['data']['name']['userRole']['name'];
      _isAdmin = response['data']['name']['isAdmin'];
      _userName = responseUserName.toString();

      _isLogged = true;

      final prefs = await SharedPreferences.getInstance();
      final authUserData = json.encode({
        'userName': _userName,
        'userRole': _userRole,
        'isAdmin': _isAdmin,
        'isLogged': _isLogged,
      });
      prefs.setString('authUserData', authUserData);
      notifyListeners();
      _isLogged = true;
      return {
        'isSuccessful': true,
        'error': null,
      };
    } catch (error) {
      return {
        'isSuccessful': false,
        'error': error.toString(),
      };
    }
  }

  bool get isLogged {
    if (_isLogged == null) {
      return false;
    } else {
      return _isLogged;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authUserData')) {
      return false;
    }
    
    final extractedUserData = json.decode(prefs.getString('authUserData'));
    print(extractedUserData);
    final isAlreadyLogged = extractedUserData['isLogged'];
    print('Corre hasta aca $isAlreadyLogged');
  
    if (!isAlreadyLogged) {
      // notifyListeners();
      return false;
    }
      _userName = extractedUserData['userName'];
    _userRole = extractedUserData['userRole'];
    _isAdmin = extractedUserData['isAdmin'];
    _isLogged = true;
    return true;
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final authUserData = json.encode({
      'userName': '',
      'userRole': '',
      'isAdmin': '',
      'isLogged': false,
    });
    _isLogged = false;
    prefs.setString('authUserData', authUserData);
    notifyListeners();
  }
}
