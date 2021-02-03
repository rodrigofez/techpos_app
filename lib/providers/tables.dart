import 'dart:async';
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:NodePos/config/querys.dart';
import 'package:NodePos/providers/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Table {
  int id;
  String type;
  String name;
  String state;

  Table({
    @required id,
    type = 'Mesas',
    @required state,
    @required name,
  });
}

class Entities with ChangeNotifier {
  Map _entities = {};
  String token;
  String uri;
  Timer _refreshTimer;
  bool _isSuccessful;
  List entitiesName;

  bool get isSuccessful {
    print(_isSuccessful);
    if (_isSuccessful == null) {
      return false;
    }
    return _isSuccessful;
  }

  Entities({this.token, this.uri, this.entitiesName}){
    if(this.uri != null){
    launchWebView();
    }
  }

  void _autoRefreshTables({@required entityName}) {
    print('AUTOREFRESHTABLES EXECUTED');
    if (_refreshTimer != null) {
      _refreshTimer.cancel();
    }
    _refreshTimer = Timer(Duration(seconds: 1000), checkChanges);
  }

  Future<void> launchWebView() async {
    

    final webViewUri = uri.replaceFirst(new RegExp(r'/api/graphql'), '/flutter-signalr.html');
    print('ESTA ES LA URI DEL WEBVIEW $webViewUri');
    final flutterWebViewPlugin = FlutterWebviewPlugin();

    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();

    StreamSubscription<WebViewStateChanged> _onStateChanged;
    StreamSubscription<WebViewHttpError> _onHttpError;

    
      final Set<JavascriptChannel> jsChannels = [
        JavascriptChannel(
            name: 'Print',
            onMessageReceived: (JavascriptMessage message) {
              print("************************WEBVIEW DESDE PROVIDER************************");
              notifyListeners();
            }),
      ].toSet();

      

      // _onStateChanged = flutterWebViewPlugin.onStateChanged
      //     .listen((WebViewStateChanged state) {
      //   if (state.type == WebViewState.startLoad) {
      //     // print(state.type);
      //   }
      // });

      // if(flutterWebViewPlugin.)

      flutterWebViewPlugin.launch(
        webViewUri,
        hidden: true,
        appCacheEnabled: true,
        javascriptChannels: jsChannels,
        clearCache: true,
      );

    
  }

  Future<void> checkChanges({@required entityName}) async {
    print('CHECKCHANGESTABLES  EXECUTED');
    print('CHECKCHANGES');
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().entity(entityName),
        uri,
        token,
      );
      List<dynamic> mapResponse = response['data']['getEntities'];

      // print('PRUEBA: ${mapResponse.length}');
      // print(response['data']['getEntities'][0]['name']);
      _autoRefreshTables(entityName: entityName);
      _entities.update(entityName, (value) => mapResponse,
          ifAbsent: () => mapResponse);
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData = json.decode(prefs.getString('entities'));
      // print('PREFSS');
      // print(extractedUserData['tables']);
      // print('QUERY');
      // print(mapResponse);
      if (extractedUserData['entities'].toString() != mapResponse.toString()) {
        print('SON DIFERENTES');
        notifyListeners();
      }
      // if(extractedUserData['tables'] != mapResponse){
      //   print('FALSOOOOO');
      // }

      // print(mapResponse.length);

    } catch (error) {
      throw error;
    }
  }

  List<dynamic> storedEntities({@required entityType}) {
    print('STORED ENTITIES EXECUTED $_entities');
    print('ENTITY TYPE IN STOREDENTITITES $entityType');
    if (_entities[entityType] == null) {
      return [];
    }
    return _entities[entityType];
  }

  // Future<List<dynamic>> getTables()

  Future<List<dynamic>> getEntities({@required entityName}) async {
    print('GETTABLES EXECUTED');
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().entity(entityName),
        uri,
        token,
      );
      List<dynamic> mapResponse = response['data']['getEntities'];
      _isSuccessful = true;

      _entities.update(entityName, (value) => mapResponse,
          ifAbsent: () => mapResponse);
      // print(_entities);
      final prefs = await SharedPreferences.getInstance();
      final entitiesData = json.encode({
        'entities': _entities,
      });
      prefs.setString(
        'entities',
        entitiesData,
      );
      // print(mapResponse.length);
      // print(_entities);
      return _entities[entityName];
    } catch (error) {
      _isSuccessful = false;
      final prefs = await SharedPreferences.getInstance();
      final extractedUserData = json.decode(prefs.getString('entities'));
      print('No hay conexión');
      _entities = extractedUserData['entities'];
      throw (error);
    }
  }

  Future<bool> checkEntityState({entityType, entityName}) async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().checkEntityState(entityType, entityName),
        uri,
        token,
      );

      final finalstate = (response['data']['getEntity']['states'] as List)
          .firstWhere((element) => element['stateName'] == 'Status')['state'];

      if (finalstate == 'Available') {
        return true;
      }

      return false;
    } catch (error) {
      return null;
    }
  }

  // Future<List<dynamic>> refreshTables({@required entityName}) async {
  //   print('REFRESHTABLES');
  //   try {
  //     dynamic response = await DataGQL().cQuery(
  //       SambaQuery().tables(entityName),
  //       uri,
  //       token,
  //     );
  //     List<dynamic> mapResponse = response['data']['getEntities'];

  //     // print('PRUEBA: ${mapResponse.length}');
  //     // print(response['data']['getEntities'][0]['name']);
  //     _autoRefreshTables(entityName: entityName);
  //     _entities.update(entityName, (value) => mapResponse,
  //         ifAbsent: () => mapResponse);
  //     final prefs = await SharedPreferences.getInstance();
  //     final entitiesData = json.encode({
  //       'entities': _entities,
  //     });
  //     prefs.setString('entities', entitiesData);
  //     // print(mapResponse.length);
  //     notifyListeners();
  //     return _entities[entityName];
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
