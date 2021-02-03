import 'dart:ffi';

import 'package:NodePos/config/querys.dart';
import 'package:NodePos/providers/data.dart';
import 'package:flutter/cupertino.dart';

class Order {
  String id;
  String uid;
  String name;
  String productId;
  int quantity;
  String portionName;
  Map portion;
  double price;
  String priceTag;
  DateTime date;
  DateTime lastUpdateDate;
  int number;
  String user;
  List tags;
  bool calculatePrice;
  List states;
  bool isVoid;
  bool asGift;

  Order({
    this.id,
    this.uid,
    this.name,
    this.productId,
    this.quantity,
    this.portion,
    this.portionName,
    this.price,
    this.priceTag,
    this.date,
    this.lastUpdateDate,
    this.number,
    this.user,
    this.tags,
    this.calculatePrice,
    this.states,
    this.isVoid,
    this.asGift,
  });
}

class Ticket {
  int id;
  String uid;
  String type;
  String number;
  DateTime date;
  List calculations;
  List entities;
  double totalAmount;
  double remainingAmount;
  List states;
  List<Order> orders;
  List tempOrders;
  List ordersToVoid;
  dynamic newClientEntity;
  dynamic newEntity;

  Ticket({
    this.id,
    this.uid,
    this.type,
    this.number,
    this.date,
    this.calculations,
    this.entities,
    this.totalAmount,
    this.remainingAmount,
    this.orders,
    this.states,
    this.tempOrders,
    this.newClientEntity,
    this.ordersToVoid,
    this.newEntity,
  });
}

class Tickets with ChangeNotifier {
  String department;
  String userName;
  String ticketType;
  int _orderCounter = 1;
  String _terminalId;
  String uri;
  String token;
  Tickets({
    this.uri,
    this.token,
    this.department,
    this.userName,
    this.ticketType,
  });

  List _tempTickets = [];
  List _tempOrders = [];
  int _tempOrdersCount = 0;
  double _ticketTotalBeforCalculation = 0.00;
  Ticket _selectedTicketToModify;
  List ticketsToAdd = [];
  List<Map> selectedClientsToAdd = [];
  List<Map> selectedEntityToChange = [];
  List<Map> commandsToExecute = [];
  List<Map> currentOrdersStates = [];

  set selectedTicketToModify(ticket) => _selectedTicketToModify = ticket;
  Ticket get selectedTicketToModify {
    if (_selectedTicketToModify != null) {
      return _selectedTicketToModify;
    }
    return null;
  }

  List get tempTickets {
    if (_tempTickets == null) {
      return [];
    }
    return _tempTickets;
  }

  int get tempOrdersCount {
    return _tempOrdersCount;
  }

  void openNewTempOrder() {
    _tempOrdersCount++;
  }

  int get orderCounter {
    return _orderCounter;
  }

  double get ticketTotalBeforeCalculation {
    if (_ticketTotalBeforCalculation == null) {
      return 0.00;
    }
    return _ticketTotalBeforCalculation;
  }

  void setOrderCounter(int newCount) {
    _orderCounter = newCount;
  }

  void resetOrderCounter() {
    _orderCounter = 1;
  }

  void resetTempOrders() {
    _tempOrders = [];
    _tempOrdersCount = 0;
    _ticketTotalBeforCalculation = 0.00;
  }

  void resetTempTicketsData() {
    selectedClientsToAdd = [];
    selectedEntityToChange = [];
    ticketsToAdd = [];
    commandsToExecute = [];
    currentOrdersStates = [];
  }

  Future<void> executeAutomationCommandForOrder({
    ticketId,
    orderUid,
    automationName,
  }) async {
    try {
      await loadCurrentTerminalTicket(ticketId);
      try {
        dynamic response = await DataGQL().cQuery(
          SambaQuery().executeAutomationCommandForOrder(
            automationName: automationName,
            terminalId: _terminalId,
            orderUid: orderUid,
          ),
          uri,
          token,
        );
        print('THIS IS THE CURRENT STATE OF THE TICKET : $response');
        final newOrderState = (response['data']
                    ['executeAutomationCommandForTerminalTicket']['orders']
                .toList() as List)
            .firstWhere((order) => order['uid'] == orderUid)['states']
            .toList();
        // print(newOrderState);
        //check if order already has an automation command executed
        if (currentOrdersStates
            .any((element) => element.toString().contains(orderUid))) {
          currentOrdersStates
              .removeWhere((element) => element.toString().contains(orderUid));
          currentOrdersStates.add({
            'orderUid': orderUid,
            'currentState': newOrderState,
            'ticketId': ticketId,
          });
        } else {
          currentOrdersStates.add({
            'orderUid': orderUid,
            'currentState': newOrderState,
            'ticketId': ticketId,
          });
        }
        notifyListeners();
      } catch (error) {}
    } catch (error) {}
  }

  Future<void> refreshNotification() async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery.refreshNotification,
        uri,
        token,
      );
      // print(response);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> registerTerminal() async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().registerTerminal(
            department: department, ticketType: ticketType, user: userName),
        uri,
        token,
      );
      // print(response);
      _terminalId = response['data']['terminalId'];
      print('THIS IS THE LAST TERMINALID: $_terminalId');
      // print(_terminalId);
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> loadTerminalTicket() async {
  //   try {
  //     dynamic response = await DataGQL().cQuery(
  //       SambaQuery().loadTerminalTicket(
  //         terminalId: _terminalId,
  //         ticketId: _selectedTicketToModify,
  //       ),
  //       uri,
  //       token,
  //     );
  //     print(response);
  //   } catch (error) {}
  // }

  Future<void> loadCurrentTerminalTicket(ticketId) async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().loadTerminalTicket(
          terminalId: _terminalId,
          ticketId: ticketId,
        ),
        uri,
        token,
      );
      print(response);
    } catch (error) {}
  }

  Future<void> createTerminalTicket({entityName, entityType}) async {
    try {
      print('EJECUTADO');
      print(_terminalId);
      dynamic response = await DataGQL().cQuery(
        SambaQuery().createTerminalTicket(_terminalId),
        uri,
        token,
      );
      print('HAY RESPUSTA');
      print(response);
      await addOrdersToTerminalTicket(0);
      print('ORDERS SUCCESFUL');
      await setEntityToTerminalTicket(
        entityName: entityName,
        entityType: entityType,
      );
      await closeTerminalTicket();
      await unregisterTerminal();
      await refreshNotification();
      _terminalId = null;

      print('HECHOOOO');
    } catch (error) {
      print('erroraso');
      throw (error);
    }
  }

  Future<void> closeTerminalTicket() async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().closeTermianlTicket(_terminalId),
        uri,
        token,
      );
      print(response);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> unregisterTerminal() async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().unregisterTerminal(_terminalId),
        uri,
        token,
      );
      print(response);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> setEntityToTerminalTicket({entityName, entityType}) async {
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().setEntityOfTerminalTicket(
          terminalId: _terminalId,
          type: "$entityType",
          name: entityName,
        ),
        uri,
        token,
      );
      print(response);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrdersToTerminalTicket(initialOrder) async {
    int jump = initialOrder;
    if (_tempOrders.isNotEmpty) {
      for (int i = jump; i < (_tempOrders.length + jump); i++) {
        try {
          dynamic response = await DataGQL().cQuery(
            SambaQuery().addOrderToTerminalTicket(
              productName: _tempOrders[i - jump]['order'].name,
              orderQuantity: _tempOrders[i - jump]['order'].quantity,
              portionName: _tempOrders[i - jump]['order'].portion['name'],
              orderTags: _tempOrders[i - jump]['order'].tags,
              terminalId: _terminalId,
            ),
            uri,
            token,
          );
          print(response);
          var uid = response['data']['ticket']['orders'][i]['uid'];
          await updateOrderTagsOfTerminalTicket(
              uid, _tempOrders[i - jump]['order'].tags);
        } catch (error) {
          throw (error);
        }
      }
    }
  }

  Future<void> updateOrderTagsOfTerminalTicket(uid, tags) async {
    print('UID: $uid');
    print('TAGS: $tags');
    if (tags.isNotEmpty) {
      String tagString = '';
      tagString = (tags as List).fold(
          '',
          (previousValue, element) =>
              previousValue +
              (previousValue != '' ? ',' : '') +
              '{tagName:"${element['tagName']}", tag:"${element['tag']}", price:${element['price']}, quantity:${element['quantity']}, note:"" }');
      print(tagString);

      try {
        dynamic response = await DataGQL().cQuery(
          SambaQuery().updateOrderTagsOfTerminalTicket(
            orderUid: uid,
            orderTags: tagString,
            terminalId: _terminalId,
          ),
          uri,
          token,
        );
        print('response of upfate ordertags: $response');
      } catch (error) {
        throw (error);
      }
    }
  }

  List get tempOrders {
    if (_tempOrders != null) {
      return _tempOrders;
    } else {
      return [];
    }
  }

  void removeTempOrder(int orderId) {
    _ticketTotalBeforCalculation -=
        _tempOrders.firstWhere((element) => element['id'] == orderId)['total'];
    _tempOrders.removeWhere((element) => element['id'] == orderId);
    _tempOrdersCount--;

    print('REMOVED: $_tempOrders');
    notifyListeners();
  }

  void addTempOrder(int productId, String productName, int quantity,
      Map portion, List tags, int orderId) {
    double tagsTotal = 0;
    tags.fold(
        0,
        (previousValue, element) =>
            tagsTotal += (element['quantity'] * element['price']));
    double total = quantity * (portion['price'] + tagsTotal);
    print(tags);
    print(productId);
    print(productName);
    print(portion);

    _tempOrders.add({
      'date': DateTime.now().toIso8601String(),
      'id': orderId,
      'order': Order(
        name: productName,
        quantity: quantity,
        portion: portion,
        tags: tags,
      ),
      'total': total,
    });

    _ticketTotalBeforCalculation += total;

    notifyListeners();
  }

  void addTempOrdersToTicket() {
    final index = _tempTickets.indexWhere((element) =>
        element.id.toString() == selectedTicketToModify.id.toString());
    print(index);
    if (_tempTickets[index].tempOrders != null &&
        _tempTickets[index].tempOrders != []) {
      (_tempTickets[index].tempOrders as List).addAll(_tempOrders);
    } else {
      _tempTickets[index].tempOrders = _tempOrders;
    }
    notifyListeners();
  }

  void createTicketToAdd() {
    ticketsToAdd.add({
      'id': DateTime.now().toIso8601String(),
      'orders': _tempOrders,
    });
    _tempOrders = [];
    _tempOrdersCount = 0;
    notifyListeners();
  }

  Future<void> getLastTicketsOfEntity(entityName, entityType) async {
    _tempTickets = [];
    try {
      dynamic response = await DataGQL().cQuery(
        SambaQuery().getLastTickets(
          entityName: entityName,
          entityType: entityType,
        ),
        uri,
        token,
      );
      List openTickets = (response['data']['getTickets'] as List).toList();
      // debugPrint(openTickets.toString(), wrapWidth: 1024);

      //Iterando todos los tickets disponibles para guardar tickets temporales
      for (int i = 0; i < openTickets.length; i++) {
        var currentTicket = openTickets[i];
        _tempTickets.add(Ticket(
          id: currentTicket['id'],
          uid: currentTicket['uid'],
          type: currentTicket['type'],
          number: currentTicket['number'],
          date: DateTime.parse(currentTicket['date']),
          entities: currentTicket['entities'].toList(),
          orders: (currentTicket['orders'] as List).map((currentOrder) {
            return Order(
              id: currentOrder['id'].toString(),
              uid: currentOrder['uid'],
              name: currentOrder['name'],
              productId: currentOrder['productId'],
              quantity: (currentOrder['quantity'] as double).toInt(),
              portionName: currentOrder['portion'],
              price: currentOrder['price'],
              priceTag: currentOrder['priceTag'],
              date: DateTime.parse(
                currentOrder['date'],
              ),
              lastUpdateDate: DateTime.parse(
                currentOrder['lastUpdateDate'],
              ),
              number: currentOrder['number'],
              user: currentOrder['user'],
              tags: currentOrder['tags'].toList(),
              calculatePrice: currentOrder['calculatePrice'],
              states: currentOrder['states'].toList(),
              asGift: false,
              isVoid: false,
            );
          }).toList(),
          totalAmount: currentTicket['totalAmount'],
          remainingAmount: currentTicket['remainingAmount'],
          calculations: [],
          states: currentTicket['states'].toList(),
        ));
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //CLOSE OPEN ENTITY AND MAKE CHANGES
  Future<void> closeTicket({
    entityType,
    entityName,
    @required selectedClientEntity,
  }) async {
    try {
      //ADD NEW ORDERS TO EXISTENT TICKETS

      await Future.forEach(_tempTickets, (ticket) async {
        final thereAreClientToSet = selectedClientsToAdd.any((element) =>
            element['ticketId'].toString() == ticket.id.toString());
        final thereAreEntityToChange = selectedEntityToChange.any((element) =>
            element['ticketId'].toString() == ticket.id.toString());

        //TODO TRABAJANDO EN NULLEAR ORDEN
        if (thereAreClientToSet) {
          final clientName = selectedClientsToAdd.firstWhere((element) =>
              element['ticketId'].toString() ==
              ticket.id.toString())['clientName'];
          await setEntityToTerminalTicket(
            entityName: clientName,
            entityType: selectedClientEntity,
          );
        }
        if (thereAreEntityToChange) {
          print('se ejecutó entity change');
          final entityName = selectedEntityToChange.firstWhere((element) =>
              element['ticketId'].toString() ==
              ticket.id.toString())['entityName'];
          await setEntityToTerminalTicket(
            entityName: entityName,
            entityType: entityType,
          );
        }
        if (ticket.tempOrders != null && ticket.tempOrders != []) {
          try {
            var ordersLength = ticket.orders.length;
            await addOrdersToCurrentOpenTicket(
              initialOrder: ordersLength,
              ticket: ticket,
            );
          } catch (error) {
            throw (error);
          }
        }
        await closeTerminalTicket();
        refreshNotification();
      });

      //ADD NEW TICKETS
      await Future.forEach(ticketsToAdd, (ticket) async {
        try {
          await addTicketToOpenEntity(
            entityName: entityName,
            entityType: entityType,
            ticket: ticket,
          );
        } catch (error) {
          throw error;
        }
      });
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTicketToOpenEntity({entityName, entityType, ticket}) async {
    try {
      print('EJECUTADO');
      print(_terminalId);
      dynamic response = await DataGQL().cQuery(
        SambaQuery().createTerminalTicket(_terminalId),
        uri,
        token,
      );
      print('HAY RESPUSTA');
      print(response);
      await addOrdersToTerminalTicketOpenEntity(
        initialOrder: 0,
        ticket: ticket,
      );
      print('ORDERS SUCCESFUL');
      await setEntityToTerminalTicket(
        entityName: entityName,
        entityType: entityType,
      );
      await closeTerminalTicket();

      print('HECHOOOO');
    } catch (error) {
      print('erroraso');
      throw (error);
    }
  }

  Future<void> addOrdersToTerminalTicketOpenEntity(
      {initialOrder, ticket}) async {
    int jump = initialOrder;
    if (ticket['orders'].isNotEmpty) {
      for (int i = jump; i < (ticket['orders'].length + jump); i++) {
        try {
          print("ESTA ES LA TERMINALID: $_terminalId");
          dynamic response = await DataGQL().cQuery(
            SambaQuery().addOrderToTerminalTicket(
              productName: ticket['orders'][i - jump]['order'].name,
              orderQuantity: ticket['orders'][i - jump]['order'].quantity,
              portionName: ticket['orders'][i - jump]['order'].portion['name'],
              orderTags: ticket['orders'][i - jump]['order'].tags,
              terminalId: _terminalId,
            ),
            uri,
            token,
          );
          print(response);
          var uid = response['data']['ticket']['orders'][i]['uid'];
          await updateOrderTagsOfTerminalTicket(
              uid, ticket['orders'][i - jump]['order'].tags);
        } catch (error) {
          throw (error);
        }
      }
    }
  }

  Future<void> addOrdersToCurrentOpenTicket({initialOrder, ticket}) async {
    int jump = initialOrder;
    if (ticket.tempOrders.isNotEmpty) {
      for (int i = jump; i < (ticket.tempOrders.length + jump); i++) {
        try {
          dynamic response = await DataGQL().cQuery(
            SambaQuery().addOrderToTerminalTicket(
              productName: ticket.tempOrders[i - jump]['order'].name,
              orderQuantity: ticket.tempOrders[i - jump]['order'].quantity,
              portionName: ticket.tempOrders[i - jump]['order'].portion['name'],
              orderTags: ticket.tempOrders[i - jump]['order'].tags,
              terminalId: _terminalId,
            ),
            uri,
            token,
          );
          print(response);
          var uid = response['data']['ticket']['orders'][i]['uid'];
          await updateOrderTagsOfTerminalTicket(
              uid, ticket.tempOrders[i - jump]['order'].tags);
        } catch (error) {
          throw (error);
        }
      }
    }
  }

  Future<void> executeAutomationCommandForTicket({
    automationName,
    automationValue,
  }) async {
    try {
      await loadCurrentTerminalTicket(_selectedTicketToModify.id);
      await DataGQL().cQuery(
        SambaQuery().executeAutomationCommandForTicket(
          terminalId: _terminalId,
          automationName: automationName,
          automationValue: automationValue,
        ),
        uri,
        token,
      );

      await closeTerminalTicket();
      await refreshNotification();
      // notifyListeners();
      // await refreshNotification();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> addOrdersToTerminalTicket(initialOrder) async {

  // }
}

//   Future<void> addOrdersToOpenTicket({entityName, entityType}) async {
//     // print(_selectedTicketToModify);
//     // print(_tempTickets[0].id);
//     var ordersLength = _tempTickets
//         .firstWhere(
//             (element) => element.id.toString() == _selectedTicketToModify)
//         .orders
//         .length;
//     print(ordersLength);
//     try {
//       await addOrdersToTerminalTicket(ordersLength);
//       print('ORDERS SUCCESFUL');
//       await closeTerminalTicket();
//       await refreshNotification();
//       _tempOrders = [];
//       _tempOrdersCount = 0;
//       print('HECHOOOO');
//       notifyListeners();
//     } catch (error) {
//       print('erroraso');
//       throw (error);
//     }
//   }
// }
