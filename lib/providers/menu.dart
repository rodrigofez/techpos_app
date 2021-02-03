import 'dart:async';
import 'dart:convert';

import 'package:NodePos/config/querys.dart';
import 'package:NodePos/providers/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu {
  String name;
  List<dynamic> categories;
  String selectedMenu;

  Menu(
    this.name,
    this.categories,
  );
}

class Menus with ChangeNotifier {
  String token;
  String uri;
  Map<String, dynamic> _menus = {};
  Map<String, dynamic> _orderTags = {};
  bool isLoading = false;
  List _itemsOrderTags = [];
  int _contadorItems = 0;
  int _nItems = 0;
  bool _isUpdating = false;
  DateTime _lastTagsUpdate;
  String selectedMenu;

  bool get isUpdating {
    return _isUpdating;
  }

  Menus({this.token, this.uri, this.selectedMenu});

  int get contadorItems {
    return _contadorItems;
  }

  int get nItems {
    return _nItems;
  }

  Future<void> downloadMenu({tempToken, tempUri, tempMenu}) async {
    final backupList = _itemsOrderTags;
    _itemsOrderTags = [];
    _isUpdating = true;
    notifyListeners();
    try {
      // print('GETMENU  EXECUTED');
      isLoading = true;
      try {
        dynamic response = await DataGQL().cQuery(
          SambaQuery().menu(tempMenu),
          tempUri,
          tempToken,
        );
        // print(response);
        List<dynamic> menuCategories =
            response['data']['getMenu']['categories'];

        _menus[tempMenu] = menuCategories;
        final prefs = await SharedPreferences.getInstance();
        final menusData = json.encode({
          'menus': _menus,
        });
        // print('luego');
        prefs.setString('menus', menusData);
        // print(_menus);
        isLoading = false;
        notifyListeners();
        // print('SE PUDOOOOO');
      } catch (error) {
        final prefs = await SharedPreferences.getInstance();
        final extractedMenu = json.decode(prefs.getString('menus'))['menus'];
        _menus = extractedMenu;
        isLoading = false;
        notifyListeners();
        throw error;
      }
      // print((_menus[tempMenu] as List)
      //     .expand((element) => element['menuItems'])
      //     .toList()
      //     .length);

      final itemsList = (_menus[tempMenu] as List)
          .expand((element) => element['menuItems'])
          .toList();

      final nItems = (_menus[tempMenu] as List)
          .expand((element) => element['menuItems'])
          .toList()
          .length;

      _nItems = nItems;

      int contador = 0;

      for (int iter = 0; iter < nItems; iter++) {
        _contadorItems++;
        notifyListeners();
        // print(itemsList[iter]['name']);
        _itemsOrderTags.add([]);
        if (itemsList[iter]['product'] == null) {
          _itemsOrderTags[iter] = {
            'productId': 0,
            'portions': [],
          };
          continue;
        }
        int productId = itemsList[iter]['product']['id'];
        int nPortions = itemsList[iter]['product']['portions'].toList().length;
        _itemsOrderTags[iter] = {
          'productId': productId,
          'portions': [],
        };
        for (int iter2 = 0; iter2 < nPortions; iter2++) {
          _itemsOrderTags[iter]['portions'].add([]);
          contador++;
          // print(contador);
          try {
            dynamic response = await DataGQL().cQuery(
              SambaQuery().orderTagsGroups(
                productId: productId.toString(),
                portion: itemsList[iter]['product']['portions'][iter2]['name'],
              ),
              tempUri,
              tempToken,
            );

            List<dynamic> orderTagsList = response['data']['product'];

            _itemsOrderTags[iter]['portions'][iter2] = {
              'name': itemsList[iter]['product']['portions'][iter2]['name'],
              'price': itemsList[iter]['product']['portions'][iter2]['price'],
              'tags': orderTagsList,
            };
            // print(_itemsOrderTags[iter]);
            // print('LONGITUD LISTA ${_itemsOrderTags.length}');
          } catch (error) {
            _itemsOrderTags = backupList;
            // print(error);
            throw error;
          }
        }
      }
      final prefs = await SharedPreferences.getInstance();
      _lastTagsUpdate = DateTime.now();
      prefs.setString(
          'itemsOrderTags',
          json.encode({
            'orderTags': _itemsOrderTags,
            'lastUpdate': _lastTagsUpdate.toIso8601String(),
          }));
      // print('FINALIZADO: ${_itemsOrderTags.toString()}');
      _isUpdating = false;
      _contadorItems = 0;
      notifyListeners();
    } catch (error) {
      _isUpdating = false;
      _contadorItems = 0;
      notifyListeners();
      throw error;
    }
  }

  Future<void> updateMenu() async {
    final backupList = _itemsOrderTags;
    _itemsOrderTags = [];
    _isUpdating = true;
    notifyListeners();
    try {
      await getMenu();
      // print((_menus[selectedMenu] as List)
      //     .expand((element) => element['menuItems'])
      //     .toList()
      //     .length);

      final itemsList = (_menus[selectedMenu] as List)
          .expand((element) => element['menuItems'])
          .toList();

      final nItems = (_menus[selectedMenu] as List)
          .expand((element) => element['menuItems'])
          .toList()
          .length;

      _nItems = nItems;

      int contador = 0;

      for (int iter = 0; iter < nItems; iter++) {
        _contadorItems++;
        notifyListeners();
        // print(itemsList[iter]['name']);
        _itemsOrderTags.add([]);
        if (itemsList[iter]['product'] == null) {
          _itemsOrderTags[iter] = {
            'productId': 0,
            'portions': [],
          };
          continue;
        }
        int productId = itemsList[iter]['product']['id'];
        int nPortions = itemsList[iter]['product']['portions'].toList().length;
        _itemsOrderTags[iter] = {
          'productId': productId,
          'portions': [],
        };
        for (int iter2 = 0; iter2 < nPortions; iter2++) {
          _itemsOrderTags[iter]['portions'].add([]);
          contador++;
          // print(contador);
          try {
            dynamic response = await DataGQL().cQuery(
              SambaQuery().orderTagsGroups(
                productId: productId.toString(),
                portion: itemsList[iter]['product']['portions'][iter2]['name'],
              ),
              uri,
              token,
            );

            List<dynamic> orderTagsList = response['data']['product'];

            _itemsOrderTags[iter]['portions'][iter2] = {
              'name': itemsList[iter]['product']['portions'][iter2]['name'],
              'price': itemsList[iter]['product']['portions'][iter2]['price'],
              'tags': orderTagsList,
            };
            // print(_itemsOrderTags[iter]);
            // print('LONGITUD LISTA ${_itemsOrderTags.length}');
          } catch (error) {
            _itemsOrderTags = backupList;
            // print(error);
            throw error;
          }
        }
      }
      final prefs = await SharedPreferences.getInstance();
      _lastTagsUpdate = DateTime.now();
      prefs.setString(
          'itemsOrderTags',
          json.encode({
            'orderTags': _itemsOrderTags,
            'lastUpdate': _lastTagsUpdate.toIso8601String(),
          }));
      // print('FINALIZADO: ${_itemsOrderTags.toString()}');
      _isUpdating = false;
      _contadorItems = 0;
      notifyListeners();
    } catch (error) {
      _isUpdating = false;
      _contadorItems = 0;
      notifyListeners();
      throw error;
    }
  }

  Future<void> loadMenu(String name) async {
    // print('GETMENU  EXECUTED');
    isLoading = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final extractedMenu = json.decode(prefs.getString('menus'))['menus'];
      _menus = extractedMenu;

      notifyListeners();
    } catch (error) {
      // print(error);
      notifyListeners();
      throw error;
    }
  }

  Future<void> getMenu() async {
    // print('GETMENU  EXECUTED');
    isLoading = true;
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().menu(selectedMenu),
        uri,
        token,
      );
      // print(response);
      List<dynamic> menuCategories = response['data']['getMenu']['categories'];

      _menus[selectedMenu] = menuCategories;
      final prefs = await SharedPreferences.getInstance();
      final menusData = json.encode({
        'menus': _menus,
      });
      // print('luego');
      prefs.setString('menus', menusData);
      // print(_menus);
      isLoading = false;
      notifyListeners();
      // print('SE PUDOOOOO');
    } catch (error) {
      final prefs = await SharedPreferences.getInstance();
      final extractedMenu = json.decode(prefs.getString('menus'))['menus'];
      _menus = extractedMenu;
      isLoading = false;
      notifyListeners();
      throw error;
    }
  }

  List getCategories() {
    if (_menus[selectedMenu] != null) {
      return _menus[selectedMenu].map((e) => e['name']).toList();
    } else {
      return [];
    }
  }

  List getProductsId(String category) {
    if (_menus[selectedMenu] != null) {
      // print('se actuzaliza: ${(_menus[menuName]
      //     .where((element) => element['name'] == '$category')
      //     .toList() as List)}');
      return (_menus[selectedMenu]
              .where((element) => element['name'] == '$category')
              .toList()[0]['menuItems'] as List)
          .map((e) => e['product'] != null ? e['product']['id'] : 0)
          .toList();
    } else {
      return [];
    }
  }

  List getAllProducts() {
    if (_menus[selectedMenu] != null) {
      var completeList = (_menus[selectedMenu] as List)
          .expand((element) => element['menuItems'].toList())
          .toList();

      return completeList;
    } else {
      print('HOLAAAAAAAAAAAAA');
      print(_menus[selectedMenu]);

      return [];
    }
  }

  List getProducts(String category) {
    if (_menus[selectedMenu] != null) {
      return (_menus[selectedMenu]
          .where((element) => element['name'] == '$category')
          .toList()[0]['menuItems'] as List);
    } else {
      return [];
    }
  }

  List getCategoriesProducts(String category) {
    if (_menus[selectedMenu] != null) {
      return (_menus[selectedMenu]
              .where((element) => element['name'] == '$category')
              .toList()[0]['menuItems'] as List)
          .map((e) => e['name'])
          .toList();
    } else {
      return [];
    }
  }

  List returnNestedOrderTags(
    String orderTag,
    String productId,
    String portion,
  ) {
    // print((_itemsOrderTags)
    //     .firstWhere((element) => element['productId'] == int.parse(productId))[
    //         'portions']
    //     .firstWhere((element) => element['name'] == portion)['tags'].firstWhere((element)=> element['name'] == orderTag)['tags']);
    final nestedTags = (_itemsOrderTags)
        .firstWhere((element) =>
            (element['productId'] == int.parse(productId)) &&
            element['portions'] != null)['portions']
        .firstWhere((element) => element['name'] == portion)['tags']
        .firstWhere((element) => element['name'] == orderTag)['tags'];
    return nestedTags;
  }

  List returnOrderTagsLabels(
    String productId,
    String portion,
  ) {
    // print(productId);
    // print(portion);
    _itemsOrderTags.removeWhere((element) => element == null);
    // debugPrint( _itemsOrderTags.where((element) => element['productId'] == int.parse(productId) ).toString(), wrapWidth: 1024);
    // print(_itemsOrderTags[_itemsOrderTags.length - 1]);
    // print('returnOrderTagsLabels ${(_itemsOrderTags)
    //     .firstWhere((element) => element['productId'] == int.parse(productId))}');

    // print('comparison ${}');

    return _itemsOrderTags
        .firstWhere((element) => element['productId'] == int.parse(productId))[
            'portions']
        .firstWhere((element) => element['name'] == portion)['tags'];
  }

  List tagMaxQuantity(
    String productId,
    String portion,
    String orderTag,
  ) {
    List maxQuantity = (_itemsOrderTags)
        .firstWhere((element) => element['productId'] == int.parse(productId))[
            'portions']
        .firstWhere((element) => element['name'] == portion)['tags']
        .firstWhere((element) => element['name'] == orderTag)['tags']
        .map((e) => e['maxQuantity'])
        .toList();

    // print('comparison: $maxQuantity');
    // print('MAX QUANTITY: ${((_orderTags[productId][portion] as List)
    //         .firstWhere((element) => element['name'] == orderTag)['tags']
    //     as List)
    // .map((e) => e['maxQuantity'])
    // .toList()}');
    return maxQuantity;
  }

  List orderTagsMax(
    String productId,
    String portion,
  ) {
    final ordTagsMax = (_itemsOrderTags)
        .firstWhere((element) => element['productId'] == int.parse(productId))[
            'portions']
        .firstWhere((element) => element['name'] == portion)['tags']
        .map((e) => e['max'])
        .toList();
    return ordTagsMax;
  }

  List orderTagsMin(
    String productId,
    String portion,
  ) {
    final ordTagsMin = (_itemsOrderTags)
        .firstWhere((element) => element['productId'] == int.parse(productId))[
            'portions']
        .firstWhere((element) => element['name'] == portion)['tags']
        .map((e) => e['min'])
        .toList();
    return ordTagsMin;
  }

  // List returnOrderTags(
  //   String productId,
  //   String portion,
  // ) {
  //   return _orderTags[productId][portion];
  // }

  //GET ORDER TAGS

  DateTime get lastTagsUpdate {
    return _lastTagsUpdate;
  }

  Future<void> getOrderTags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final extractedTagsData = json.decode(prefs.getString('itemsOrderTags'));
      // print(extractedTagsData);
      _itemsOrderTags = extractedTagsData['orderTags'];

      _lastTagsUpdate = DateTime.parse(extractedTagsData['lastUpdate']);
      // print(_itemsOrderTags);
      notifyListeners();
      // dynamic response = await DataGQL().cQuery(
      //   SambaQuery().orderTagsGroups(
      //     productId: productId,
      //     portion: portion,
      //   ),
      //   uri,
      //   token,
      // );

      // List<dynamic> orderTagsList = response['data']['product'];

      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString(
      //     '${productId}_$portion',
      //     json.encode({
      //       'orderTags': orderTagsList,
      //     }));
      // _orderTags.update(productId, (value) => {portion: orderTagsList},
      //     ifAbsent: () => {portion: orderTagsList});
      // // _orderTags[productId][portion] = orderTagsList;

    } catch (error) {
      print(error);
      throw error;
    }
  }
}
