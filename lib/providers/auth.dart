import 'dart:convert';
import 'dart:async';
import 'package:NodePos/config/querys.dart';
import 'package:NodePos/providers/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Config with ChangeNotifier {
  //server related properties
  String _address;
  String _port;
  String _secretKey;

  //localUser related data
  bool _isLogged;
  String _userName;
  bool _isAdmin;
  String _userRole;
  bool _isConfigured;

  //token related properties
  String _token;
  DateTime _expiryDate;
  String _refreshToken;
  Timer _authTimer;

  //settings data related properties
  List _ticketType;
  List _departments;
  List _entityType;
  List _screenMenu;
  List _automationCommand;
  List _terminal;
  List _entityScreen;

  //settings preferences related properties
  String selectedMenu = '';
  String selectedClientEntity = '';
  String selectedDepartment = '';
  String selectedTicket = '';
  List selectedEntities = [];
  List clientsList = [];
  List selectedTicketAutomation = [];
  List selectedOrderAutomation = [];

  bool get isConfigured {
    if (_isConfigured == null) {
      return false;
    }
    return _isConfigured;
  }

  bool get isAuth {
    return token != null;
  }

  String get uri {
    if (_address != null && _port != null) {
      return 'http://$_address:$_port/api/graphql';
    }
    return null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get address {
    return _address;
  }

  String get port {
    return _port;
  }

  String get secretKey {
    return _secretKey;
  }

  //Logout from server
  Future<void> logOut() async {
    _token = null;
    _port = null;
    _refreshToken = null;
    _address = null;
    _secretKey = null;
    _expiryDate = null;
    _authTimer = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authData');
  }

  Future<void> clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  //Initialize token refresh timer
  void _autoRefreshToken() {
    print('AUTOREFRESHTOKEN  EXECUTED');
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), refreshToken);
  }

  //Execute token refresh
  Future<void> refreshToken() async {
    print('REFRESHTOKEN  EXECUTED');
    final endpoint = 'http://$_address:$_port/Token';
    print(_refreshToken);

    Map<String, dynamic> form = {
      'grant_type': 'refresh_token',
      'refresh_token': _refreshToken,
      'client_id': 'nodepos',
    };

    String formData = Uri(queryParameters: form).query;
    try {
      final response = await http.post(
        endpoint,
        body: formData,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      var decodedResponse = json.decode(response.body);
      print(decodedResponse);

      if ((decodedResponse as Map).containsKey('error')) {
        _token = null;
        if(decodedResponse['error'] == 'invalid_grant'){
          await signIn(_address, _port, _secretKey);
        }
        // throw (decodedResponse['error']);
      }

      _token = decodedResponse['access_token'];
      _refreshToken = decodedResponse['refresh_token'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: decodedResponse['expires_in']));
      final prefs = await SharedPreferences.getInstance();
      final authData = json.encode({
        'token': _token,
        'port': _port,
        'address': _address,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate.toIso8601String(),
        'secretKey': _secretKey,
      });
      prefs.setString('authData', authData);

      print('token refrescado');
      _autoRefreshToken();
      notifyListeners();
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> signInLocalUser(pin) async {
    try {
      print(pin);
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
      _userRole = response['data']['name']['userRole']['name'];
      _isAdmin = response['data']['name']['isAdmin'];
      _userName = responseUserName;
      _isLogged = true;

      final prefs = await SharedPreferences.getInstance();
      final localUserData = json.encode({
        'userName': _userName,
        'userRole': _userRole,
        'isAdmin': _isAdmin,
        'isLogged': _refreshToken,
      });
      prefs.setString('localUserData', localUserData);
      notifyListeners();
      _isLogged = true;
      return {
        'isSuccessful': true,
        'error': null,
      };
    } catch (error) {
      print(error);
      return {
        'isSuccessful': false,
        'error': error.toString(),
      };
    }
  }

  Future<bool> checkConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isConfigured')) {
      _isConfigured = false;
    }
    final extractedData = json.decode(prefs.getString('isConfigured'));
    print(extractedData);
    _isConfigured = extractedData['isConfigured'];
    print(_isConfigured);
    return _isConfigured ? true : false;
  }

  Future<bool> checkAuth() async {
    print('CHECKLOGIN EXECUTED');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('authData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      //Prueba 24H autologgeo
      _token = extractedUserData['token'];
      _port = extractedUserData['port'];
      _refreshToken = extractedUserData['refreshToken'];
      _address = extractedUserData['address'];
      _secretKey = extractedUserData['secretKey'];
      _expiryDate = expiryDate;
      await refreshToken();
      notifyListeners();
      return false;
    }
    _token = extractedUserData['token'];
    _port = extractedUserData['port'];
    _refreshToken = extractedUserData['refreshToken'];
    _address = extractedUserData['address'];
    _secretKey = extractedUserData['secretKey'];
    _expiryDate = expiryDate;
    _autoRefreshToken();
    notifyListeners();
    // notifyListeners();
    return true;
  }

  //autologin to execute at start
  Future<bool> tryAutoLogin() async {
    print('TRYAUTOLOGIN EXECUTED');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('authData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      //Prueba 24H autologgeo
      _token = extractedUserData['token'];
      _port = extractedUserData['port'];
      _refreshToken = extractedUserData['refreshToken'];
      _address = extractedUserData['address'];
      _secretKey = extractedUserData['secretKey'];
      _expiryDate = expiryDate;
      refreshToken();
      return false;
    }
    _token = extractedUserData['token'];
    _port = extractedUserData['port'];
    _refreshToken = extractedUserData['refreshToken'];
    _address = extractedUserData['address'];
    _secretKey = extractedUserData['secretKey'];
    _expiryDate = expiryDate;
    _autoRefreshToken();
    return true;
  }

  //signIn server
  Future<Map> signIn(String address, String port, String secretKey) async {
    final endpoint = 'http://$address:$port/Token';

    _address = address;
    _port = port;
    _secretKey = secretKey;

    Map<String, dynamic> form = {
      'grant_type': 'client_credentials',
      'client_secret': secretKey,
      'client_id': 'nodepos',
    };

    String formData = Uri(queryParameters: form).query;

    try {
      final response = await http.post(
        endpoint,
        body: formData,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      var decodedResponse = json.decode(response.body);

      if ((decodedResponse as Map).containsKey('error')) {
        _token = null;
        throw (decodedResponse['error_description']);
      }
      _token = decodedResponse['access_token'];
      _refreshToken = decodedResponse['refresh_token'];

      _expiryDate =
          DateTime.now().add(Duration(seconds: decodedResponse['expires_in']));

      final prefs = await SharedPreferences.getInstance();
      final authData = json.encode({
        'token': _token,
        'port': _port,
        'address': _address,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate.toIso8601String(),
        'secretKey': _secretKey,
      });
      prefs.setString('authData', authData);
      _autoRefreshToken();
      print('autenticación completa');
      await getServerSettings(true);
      return {
        'token': _token,
        'uri': 'http://$_address:$_port/api/graphql',
      };
      // notifyListeners();
    } catch (error) {
      _token = null;

      // print('error inside func: ${error.toString()}');
      throw error;
    }
    notifyListeners();
  }

  Future<void> loadServerSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configData = json.decode(prefs.getString('serverConfigData'));

      //getting ticketTypes
      _ticketType = configData['TicketType'];

      //getting list of terminals
      _terminal = configData['Terminal'];

      //getting list of departments
      _departments = configData['Department'];

      //getting list of EntityType
      _entityType = configData['EntityType'];

      //getting list of screenMenus
      _screenMenu = configData['ScreenMenu'];

      //getting list of entityScreens
      _entityScreen = configData['EntityScreen'];

      //getting list of AutomationCommands
      _automationCommand = configData['AutomationCommand'];
    } catch (error) {
      throw error;
    }
  }

  Future<void> getServerSettings(bool isSignIn) async {
    // print('GETTING SETTINGS...');

    try {
      final endpoint = 'http://$address:$port/api/helper';

      Map<String, dynamic> form = {
        'query': 'baseconfig',
        'serial': '111',
      };

      String formData = Uri(queryParameters: form).query;

      final response = await http.post(
        endpoint,
        body: formData,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      var utfdecod = Utf8Decoder().convert(response.bodyBytes);
      // print(utfdecod);
      var decodedResponse = json.decode(utfdecod);

      //getting ticketTypes
      _ticketType = decodedResponse.firstWhere((element) =>
          (element as Map).containsKey('TicketType'))['TicketType'];

      //getting list of terminals
      _terminal = decodedResponse.firstWhere(
          (element) => (element as Map).containsKey('Terminal'))['Terminal'];

      //getting list of departments
      _departments = decodedResponse.firstWhere((element) =>
          (element as Map).containsKey('Department'))['Department'];

      //getting list of EntityType
      _entityType = decodedResponse.firstWhere((element) =>
          (element as Map).containsKey('EntityType'))['EntityType'];

      //getting list of screenMenu
      _screenMenu = decodedResponse.firstWhere((element) =>
          (element as Map).containsKey('ScreenMenu'))['ScreenMenu'];

      //getting list of entityScreens
      _entityScreen = decodedResponse.firstWhere((element) =>
          (element as Map).containsKey('EntityScreen'))['EntityScreen'];

      //getting list of AutomationCommands
      _automationCommand = decodedResponse.firstWhere((element) =>
          (element as Map)
              .containsKey('AutomationCommand'))['AutomationCommand'];

      // final forTickets = _automationCommand
      //     .where((element) => element['DisplayOnTickets'] == "True");
      // debugPrint(forTickets.toString(), wrapWidth: 1024);
      // print("ANTES DE:");
      debugPrint(_automationCommand.toString(), wrapWidth: 100);

      final prefs = await SharedPreferences.getInstance();
      final serverConfigData = json.encode({
        'TicketType': _ticketType,
        'Terminal': _terminal,
        'Department': _departments,
        'EntityScreen': _entityScreen,
        'EntityType': _entityType,
        'ScreenMenu': _screenMenu,
        'AutomationCommand': _automationCommand,
      });
      prefs.setString('serverConfigData', serverConfigData);
      // print('serverSettings successful: $_entityType');
      if (!isSignIn) {
        notifyListeners();
      }
    } catch (error) {
      _token = null;
      throw error;
    }
  }

  Future<void> saveServerPreferences({
    String newSelectedTicket,
    String newSelectedMenu,
    List newSelectedEntities,
    String newSelectedClientEntity,
    String newSelectedDepartment,
    List newSelectedTicketAutomation,
    List newSelectedOrderAutomation,
  }) async {
    selectedTicket = newSelectedTicket;
    selectedMenu = newSelectedMenu;
    selectedEntities = newSelectedEntities;
    selectedClientEntity = newSelectedClientEntity;
    selectedDepartment = newSelectedDepartment;
    selectedTicketAutomation = newSelectedTicketAutomation;
    selectedOrderAutomation = newSelectedOrderAutomation;
    try {
      final prefs = await SharedPreferences.getInstance();
      final serverPreferences = json.encode({
        'selectedMenu': newSelectedMenu,
        'selectedEntities': newSelectedEntities,
        'selectedClientEntity': newSelectedClientEntity,
        'selectedDepartment': newSelectedDepartment,
        'selectedTicket': newSelectedTicket,
        'selectedOrderAutomation': selectedOrderAutomation,
        'selectedTicketAutomation': selectedTicketAutomation,
      });
      await updateClients();
      prefs.setString('serverPreferences', serverPreferences);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setConfigured() async {
    try {
      _isConfigured = true;
      final prefs = await SharedPreferences.getInstance();
      final configuration = json.encode({
        'isConfigured': true,
      });
      prefs.setString('isConfigured', configuration);
      notifyListeners();
    } catch (error) {}
  }

  Future<void> loadServerPreferences() async {
    try {
      await loadClients();
      final prefs = await SharedPreferences.getInstance();
      final extractedServerPreferences =
          json.decode(prefs.getString('serverPreferences'));
      selectedMenu = extractedServerPreferences['selectedMenu'];
      selectedClientEntity = extractedServerPreferences['selectedClientEntity'];
      selectedEntities = extractedServerPreferences['selectedEntities'];
      selectedDepartment = extractedServerPreferences['selectedDepartment'];
      selectedTicket = extractedServerPreferences['selectedTicket'];
      selectedOrderAutomation =
          extractedServerPreferences['selectedOrderAutomation'];
      selectedTicketAutomation =
          extractedServerPreferences['selectedTicketAutomation'];
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateClients() async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().entity(selectedClientEntity),
        uri,
        token,
      );
      print(response['data']['getEntities']);
      final responseData = response['data']['getEntities'].toList();
      final clientsData = json.encode({
        'clientsData': responseData,
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('clients', clientsData);
      clientsList = responseData;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> loadClients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      clientsList = json.decode(prefs.getString('clients'))['clientsData'];
    } catch (error) {
      throw error;
    }
  }

  List get ticketType {
    if (_ticketType == null) {
      return [];
    }
    return _ticketType;
  }

  List get terminal {
    if (_terminal == null) {
      return [];
    }
    return _terminal;
  }

  List get department {
    if (_departments == null) {
      return [];
    }
    return _departments;
  }

  List get entityScreen {
    if (_entityScreen == null) {
      return [];
    }
    return _entityScreen;
  }

  List get entityType {
    if (_entityScreen == null) {
      return [];
    }
    return _entityType;
  }

  List get screenMenu {
    if (_screenMenu == null) {
      return [];
    }
    return _screenMenu;
  }

  List get automationCommand {
    if (_automationCommand == null) {
      return [];
    }
    return _automationCommand;
  }

  void setMenu(menu) {
    selectedMenu = menu;
    notifyListeners();
  }
}
