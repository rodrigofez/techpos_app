import 'package:NodePos/pos_screen.dart';
import 'package:NodePos/providers/auth.dart';
import 'package:NodePos/providers/tables.dart';
import 'package:NodePos/providers/tickets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketScreen extends StatelessWidget {
  static const routeName = '/ticket_screen';

  @override
  Widget build(BuildContext context) {
    final entityName =
        (ModalRoute.of(context).settings.arguments as Map)['entityName'];
    final entityType =
        (ModalRoute.of(context).settings.arguments as Map)['entityType'];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          entityName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: TicketScreenBody(
        entityName: entityName,
        entityType: entityType,
      ),
    );
  }
}

class TicketScreenBody extends StatelessWidget {
  final entityType;
  final entityName;
  TicketScreenBody({
    this.entityType,
    this.entityName,
  });

  @override
  Widget build(BuildContext context) {
    // final dataTickets = Provider.of<Tickets>(context).tempTickets;
    // final tickets = List.generate(
    //     dataTickets.length,
    //     (index) => {
    //           'isExpanded': false,
    //           'data': dataTickets[index],
    //         });
    //         print('see if rebuilds 2');
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OptionsLeftPanel(
                entityName: entityName,
                entityType: entityType,
              ),
              TicketsRightPanel(
                entityName: entityName,
                entityType: entityType,
                // tickets: tickets,
              ),
            ],
          ),
        ),
        BottomButtonsBar(
          entityName: entityName,
          entityType: entityType,
        ),
      ],
    );
  }
}

class TicketsRightPanel extends StatefulWidget {
  final entityType;
  final entityName;
  TicketsRightPanel({
    this.entityType,
    this.entityName,
  });

  @override
  _TicketsRightPanelState createState() => _TicketsRightPanelState();
}

class _TicketsRightPanelState extends State<TicketsRightPanel> {
  bool isExpanded = true;
  var selectedTicketNumber;

  var tickets = [];
  var newTickets = [];
  // final

  @override
  void didChangeDependencies() {
    tickets = [
      {
        'isExpanded': true,
        'data': Provider.of<Tickets>(context).selectedTicketToModify,
      }
    ];
    final newTicketsData = Provider.of<Tickets>(context).ticketsToAdd;
    newTickets = List.generate(newTicketsData.length, (index) {
      return {
        'isExpanded': false,
        'data': newTicketsData[index],
      };
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        // padding: EdgeInsets.all(8),
        // color: Colors.blue.withOpacity(0.05),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            ExpansionPanelList(
              elevation: 1,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  newTickets[index].update('isExpanded', (value) => !value);
                });
              },
              children: [
                //TICKETS POR AÑADIR
                ...newTickets.map<ExpansionPanel>((ticketData) {
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          onLongPress: () {
                            setState(() {
                              //TODO: seleccionar ticket a modificar

                              // if (selectedTicketNumber !=
                              //     Provider.of<Tickets>(context).selectedTicketToModify.id.toString()) {
                              //   selectedTicketNumber =
                              //       Provider.of<Tickets>(context).selectedTicketToModify.id.toString();
                              //   Provider.of<Tickets>(context, listen: false)
                              //           .selectedTicketToModify =
                              //       Provider.of<Tickets>(context).selectedTicketToModify.id.toString();
                              // } else {
                              //   selectedTicketNumber = null;
                              //   Provider.of<Tickets>(context, listen: false)
                              //       .selectedTicketToModify = null;
                              // }
                            });
                          },
                          title: Text('#${ticketData['data']['id']}'),
                          subtitle: Text('Ticket nuevo'),
                          leading: null //TODO: CHECK SI ESTÁ POR MODIFICAR,
                          );
                    },
                    body: Column(
                      children: [
                        //temporders
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: ticketData['data']['orders'] != null
                              ? ticketData['data']['orders'].length
                              : 0,
                          itemBuilder: (ctx, orderIndex) {
                            final orderTotalAmount = (ticketData['data']
                                ['orders'][orderIndex]['total']);

                            // Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].tags[iterTags]['quantity']
                            return Column(
                              key: Key(ticketData['data']['orders'][orderIndex]
                                  ['date']),
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'Nueva orden',
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    //TODO: REMOVER TEMP ORDER DE TEMP TICKET
                                    // setState(() {
                                    //   (
                                    // });
                                    setState(() {
                                      if ((Provider.of<Tickets>(context,
                                                          listen: false)
                                                      .ticketsToAdd
                                                      .firstWhere((ticket) =>
                                                          ticket['id'] ==
                                                          ticketData['data']
                                                              ['id'])['orders']
                                                  as List)
                                              .length ==
                                          1) {
                                        Provider.of<Tickets>(context,
                                                listen: false)
                                            .ticketsToAdd
                                            .removeWhere((ticket) =>
                                                ticket['id'] ==
                                                ticketData['data']['id']);
                                        Provider.of<Tickets>(context,
                                                listen: false)
                                            .notifyListeners();
                                      } else {
                                        (Provider.of<Tickets>(context,
                                                        listen: false)
                                                    .ticketsToAdd
                                                    .firstWhere((ticket) =>
                                                        ticket['id'] ==
                                                        ticketData['data']
                                                            ['id'])['orders']
                                                as List)
                                            .removeAt(orderIndex);
                                      }
                                    });
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Eliminar',
                                      child: Text('Eliminar'),
                                    ),
                                  ],
                                  child: ListTile(
                                    tileColor: Colors.black.withOpacity(0.03),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    title: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Text(
                                                ticketData['data']['orders']
                                                        [orderIndex]['order']
                                                    .quantity
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    ticketData['data']['orders']
                                                                [orderIndex]
                                                            ['order']
                                                        .name,
                                                    maxFontSize: 14,
                                                    // maxLines:
                                                    //     2,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      AutoSizeText(
                                                        ticketData['data'][
                                                                        'orders']
                                                                    [orderIndex]
                                                                ['order']
                                                            .portion['name'],
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxFontSize: 12,
                                                        minFontSize: 8,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      AutoSizeText(
                                                        "\$${(ticketData['data']['orders'][orderIndex]['order'].portion['price'] as double).toStringAsFixed(2)}",
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxFontSize: 12,
                                                        minFontSize: 8,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ListView.builder(
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (ctx, iterTags) {
                                                      return Row(
                                                        children: [
                                                          AutoSizeText(
                                                            '${(ticketData['data']['orders'][orderIndex]['order'].tags[iterTags]['quantity']).toInt()} x ${ticketData['data']['orders'][orderIndex]['order'].tags[iterTags]['tag']}',
                                                            maxFontSize: 12,
                                                            minFontSize: 8,
                                                          ),
                                                          Spacer(),
                                                          AutoSizeText(
                                                            '\$${(ticketData['data']['orders'][orderIndex]['order'].tags[iterTags]['price'] as double).toStringAsFixed(2)}',
                                                            maxFontSize: 12,
                                                            minFontSize: 8,
                                                          )
                                                        ],
                                                      );
                                                    },
                                                    itemCount: ticketData[
                                                                        'data']
                                                                    ['orders']
                                                                [orderIndex]
                                                            ['order']
                                                        .tags
                                                        .length,
                                                  ),
                                                  Divider(),
                                                  Row(children: [
                                                    AutoSizeText(
                                                      "Total",
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.right,
                                                      maxFontSize: 12,
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    AutoSizeText(
                                                      '\$${(orderTotalAmount as double).toStringAsFixed(2)}',
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.right,
                                                      maxFontSize: 12,
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                ),
                              ],
                            );
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      '\$${(ticketData['data']['orders'] as List).fold(0, (previousTotal, order) => previousTotal + order['total']).toStringAsFixed(2)}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    isExpanded: ticketData['isExpanded'],
                  );
                }).toList(),

                //TICKETS YA AÑADIDOS
              ],
            ),

            newTickets.isNotEmpty
                ? SizedBox(
                    height: 10,
                  )
                : Container(),
            //TODO: HASTA ACA
            ExpansionPanelList(
              elevation: 1,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              children: [
                //TICKETS POR AÑADIR

                //TICKETS YA AÑADIDOS
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      // tileColor: selectedTicketNumber == Provider.of<Tickets>(context).selectedTicketToModify.number
                      //     ? Colors.blueAccent.withOpacity(0.1)
                      //     : null,

                      onLongPress: () {},
                      title: Text(
                          '#${Provider.of<Tickets>(context).selectedTicketToModify.number}'),
                      subtitle: Text((Provider.of<Tickets>(context)
                              .selectedTicketToModify
                              .states)
                          .firstWhere((element) =>
                              element['stateName'] == 'Status')['state']),
                      leading: selectedTicketNumber ==
                              Provider.of<Tickets>(context)
                                  .selectedTicketToModify
                                  .id
                                  .toString()
                          ? Icon(Icons.check_circle, color: Colors.blueAccent)
                          : null,
                    );
                  },
                  body: Column(
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              'Selección de cliente',
                            ),
                            subtitle: Text(
                                '${Provider.of<Tickets>(context).selectedClientsToAdd.where((element) => element['ticketId'] == Provider.of<Tickets>(context).selectedTicketToModify.id).toList()[index]['clientName'].toString()}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Provider.of<Tickets>(context, listen: false)
                                    .selectedClientsToAdd
                                    .removeWhere((element) =>
                                        element['ticketId'] ==
                                        Provider.of<Tickets>(context,
                                                listen: false)
                                            .selectedClientsToAdd
                                            .where((element) =>
                                                element['ticketId'] ==
                                                Provider.of<Tickets>(context)
                                                    .selectedTicketToModify
                                                    .id)
                                            .toList()[index]['ticketId']);
                                Provider.of<Tickets>(context, listen: false)
                                    .notifyListeners();
                              },
                            ),
                          );
                        },
                        itemCount: Provider.of<Tickets>(context)
                            .selectedClientsToAdd
                            .where((element) =>
                                element['ticketId'] ==
                                Provider.of<Tickets>(context)
                                    .selectedTicketToModify
                                    .id)
                            .length,
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              'Cambio de mesa',
                            ),
                            subtitle: Text(
                                '${Provider.of<Tickets>(context).selectedEntityToChange.where((element) => element['ticketId'] == Provider.of<Tickets>(context).selectedTicketToModify.id).toList()[index]['entityName'].toString()}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Provider.of<Tickets>(context, listen: false)
                                    .selectedEntityToChange
                                    .removeWhere((element) =>
                                        element['ticketId'] ==
                                        Provider.of<Tickets>(context,
                                                listen: false)
                                            .selectedEntityToChange
                                            .where((element) =>
                                                element['ticketId'] ==
                                                Provider.of<Tickets>(context)
                                                    .selectedTicketToModify
                                                    .id)
                                            .toList()[index]['ticketId']);
                                Provider.of<Tickets>(context, listen: false)
                                    .notifyListeners();
                              },
                            ),
                          );
                        },
                        itemCount: Provider.of<Tickets>(context)
                            .selectedEntityToChange
                            .where((element) =>
                                element['ticketId'] ==
                                Provider.of<Tickets>(context)
                                    .selectedTicketToModify
                                    .id)
                            .length,
                      ),
                      //temporders
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: Provider.of<Tickets>(context)
                                    .selectedTicketToModify
                                    .tempOrders !=
                                null
                            ? Provider.of<Tickets>(context)
                                .selectedTicketToModify
                                .tempOrders
                                .length
                            : 0,
                        itemBuilder: (ctx, orderIndex) {
                          final orderTotalAmount = Provider.of<Tickets>(context)
                              .selectedTicketToModify
                              .tempOrders[orderIndex]['total'];

                          // Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].tags[iterTags]['quantity']
                          return Column(
                            key: Key(Provider.of<Tickets>(context)
                                .selectedTicketToModify
                                .tempOrders[orderIndex]['date']),
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  'Nueva orden',
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  //TODO: REMOVER TEMP ORDER DE TEMP TICKET
                                  // setState(() {
                                  //   (
                                  // });
                                  setState(() {
                                    Provider.of<Tickets>(context, listen: false)
                                        .tempTickets
                                        .firstWhere((tempTicket) =>
                                            tempTicket.id.toString() ==
                                            Provider.of<Tickets>(context)
                                                .selectedTicketToModify
                                                .id
                                                .toString())
                                        .tempOrders
                                        .removeAt(orderIndex);
                                  });
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Eliminar',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                                child: ListTile(
                                  tileColor: Colors.black.withOpacity(0.03),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  title: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text(
                                              Provider.of<Tickets>(context)
                                                  .selectedTicketToModify
                                                  .tempOrders[orderIndex]
                                                      ['order']
                                                  .quantity
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  Provider.of<Tickets>(context)
                                                      .selectedTicketToModify
                                                      .tempOrders[orderIndex]
                                                          ['order']
                                                      .name,
                                                  maxFontSize: 14,
                                                  // maxLines:
                                                  //     2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    AutoSizeText(
                                                      Provider.of<Tickets>(
                                                              context)
                                                          .selectedTicketToModify
                                                          .tempOrders[
                                                              orderIndex]
                                                              ['order']
                                                          .portion['name'],
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      maxFontSize: 12,
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    AutoSizeText(
                                                      "\$${(Provider.of<Tickets>(context).selectedTicketToModify.tempOrders[orderIndex]['order'].portion['price'] as double).toStringAsFixed(2)}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      maxFontSize: 12,
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ListView.builder(
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemBuilder: (ctx, iterTags) {
                                                    return Row(
                                                      children: [
                                                        AutoSizeText(
                                                          '${(Provider.of<Tickets>(context).selectedTicketToModify.tempOrders[orderIndex]['order'].tags[iterTags]['quantity']).toInt()} x ${Provider.of<Tickets>(context).selectedTicketToModify.tempOrders[orderIndex]['order'].tags[iterTags]['tag']}',
                                                          maxFontSize: 12,
                                                          minFontSize: 8,
                                                        ),
                                                        Spacer(),
                                                        AutoSizeText(
                                                          '\$${(Provider.of<Tickets>(context).selectedTicketToModify.tempOrders[orderIndex]['order'].tags[iterTags]['price'] as double).toStringAsFixed(2)}',
                                                          maxFontSize: 12,
                                                          minFontSize: 8,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  itemCount: Provider.of<
                                                          Tickets>(context)
                                                      .selectedTicketToModify
                                                      .tempOrders[orderIndex]
                                                          ['order']
                                                      .tags
                                                      .length,
                                                ),
                                                Divider(),
                                                Row(children: [
                                                  AutoSizeText(
                                                    "Total",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.right,
                                                    maxFontSize: 12,
                                                    minFontSize: 8,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  AutoSizeText(
                                                    '\$${(orderTotalAmount as double).toStringAsFixed(2)}',
                                                    maxLines: 1,
                                                    textAlign: TextAlign.right,
                                                    maxFontSize: 12,
                                                    minFontSize: 8,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 0,
                              ),
                            ],
                          );
                        },
                      ),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: Provider.of<Tickets>(context)
                            .selectedTicketToModify
                            .orders
                            .length,
                        itemBuilder: (ctx, orderIndex) {
                          final orderTotalAmount =
                              (Provider.of<Tickets>(context)
                                          .selectedTicketToModify
                                          .orders[orderIndex]
                                          .tags as List)
                                      .fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element['price'] *
                                                  element['quantity'])) +
                                  (Provider.of<Tickets>(context)
                                          .selectedTicketToModify
                                          .orders[orderIndex]
                                          .price *
                                      Provider.of<Tickets>(context)
                                          .selectedTicketToModify
                                          .orders[orderIndex]
                                          .quantity);

                          //Setting states string
                          String orderStates = '';
                          List currentOrderStates = [];
                          if (Provider.of<Tickets>(context)
                              .currentOrdersStates
                              .any((element) => element.toString().contains(
                                  Provider.of<Tickets>(context)
                                      .selectedTicketToModify
                                      .orders[orderIndex]
                                      .uid))) {
                            currentOrderStates = Provider.of<Tickets>(context)
                                .currentOrdersStates
                                .firstWhere((element) => element
                                    .toString()
                                    .contains(Provider.of<Tickets>(context)
                                        .selectedTicketToModify
                                        .orders[orderIndex]
                                        .uid))['currentState'];
                            orderStates =
                                '${currentOrderStates.firstWhere((state) => state["stateName"] == "Status")["state"]}' +
                                    '${(currentOrderStates as List).firstWhere((element) => element['stateName'] == 'GStatus', orElse: () => null) != null ? ', ' + (currentOrderStates as List).firstWhere((element) => element['stateName'] == 'GStatus')['state'] : ''}';
                            // orderStates = '';
                          } else {
                            currentOrderStates = Provider.of<Tickets>(context)
                                .selectedTicketToModify
                                .orders[orderIndex]
                                .states;
                            orderStates =
                                '${Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].states.firstWhere((state) => state["stateName"] == "Status")["state"]}' +
                                    '${(Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].states as List).firstWhere((element) => element['stateName'] == 'GStatus', orElse: () => null) != null ? ', ' + (Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].states as List).firstWhere((element) => element['stateName'] == 'GStatus')['state'] : ''}';
                          }

                          //SETTING COLOR FOR VOID TICKET

                          final normalTextStateColor =
                              orderStates.contains('Void')
                                  ? Colors.grey
                                  : Colors.black;
                          final totalTextStateColor =
                              orderStates.contains('Void')
                                  ? Colors.grey
                                  : Colors.blue;
                          final secondaryTextStateColor =
                              orderStates.contains('Void')
                                  ? Colors.grey
                                  : Colors.black54;

                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(orderStates
                                    // ', ${Provider.of<Tickets>(context).commandsToExecute.where((element) => element.toString().contains(ticket["data"].orders[orderIndex].uid)).map((e) => e['commandName']).toList().join(', ')}',
                                    ),
                              ),
                              PopupMenuButton<Map>(
                                onSelected: (Map value) {
                                  Provider.of<Tickets>(context, listen: false)
                                      .executeAutomationCommandForOrder(
                                    orderUid: value['orderUid'],
                                    ticketId: Provider.of<Tickets>(context,
                                            listen: false)
                                        .selectedTicketToModify
                                        .id,
                                    automationName: value['commandName'],
                                  );
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<Map>>[
                                  ...Provider.of<Config>(context, listen: false)
                                      .selectedOrderAutomation
                                      .where((automation) {
                                        final statesLength =
                                            currentOrderStates.toList().length;
                                        for (int index = 0;
                                            index < statesLength;
                                            index++) {
                                          if (automation['EnablesStates']
                                              .toString()
                                              .contains(
                                                  currentOrderStates[index]
                                                      ['state'])) {
                                            return true;
                                          } else {
                                            if (automation['EnablesStates'] ==
                                                    '*' ||
                                                automation['EnablesStates'] ==
                                                    null ||
                                                automation['EnablesStates'] ==
                                                    '' ||
                                                automation['EnablesStates'] ==
                                                    'GStatus=') {
                                              return true;
                                            }
                                          }
                                        }
                                        return false;
                                      })
                                      .toList()
                                      .map((command) => PopupMenuItem<Map>(
                                            enabled: (currentOrderStates).any(
                                                    (element) => command[
                                                            'VisibleStates']
                                                        .toString()
                                                        .contains(
                                                            element['state']))
                                                ? true
                                                : (command['VisibleStates'] ==
                                                            '*' ||
                                                        command['VisibleStates'] ==
                                                            null ||
                                                        command['VisibleStates'] ==
                                                            '' ||
                                                        command['VisibleStates'] ==
                                                            'GStatus=')
                                                    ? true
                                                    : false,
                                            value: {
                                              'commandName':
                                                  command['Name'].toString(),
                                              'orderUid': Provider.of<Tickets>(
                                                      context,
                                                      listen: false)
                                                  .selectedTicketToModify
                                                  .orders[orderIndex]
                                                  .uid,
                                            },
                                            child: Text(
                                              command['ButtonHeader']
                                                  .toString(),
                                            ),
                                          ))
                                ],
                                child: ListTile(
                                  tileColor: Colors.black.withOpacity(0.03),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  title: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Text(
                                              Provider.of<Tickets>(context)
                                                  .selectedTicketToModify
                                                  .orders[orderIndex]
                                                  .quantity
                                                  .toString(),
                                              style: TextStyle(
                                                color: normalTextStateColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  Provider.of<Tickets>(context)
                                                      .selectedTicketToModify
                                                      .orders[orderIndex]
                                                      .name,
                                                  maxFontSize: 14,

                                                  // maxLines:
                                                  //     2,
                                                  style: TextStyle(
                                                    color: normalTextStateColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    AutoSizeText(
                                                      Provider.of<Tickets>(
                                                              context)
                                                          .selectedTicketToModify
                                                          .orders[orderIndex]
                                                          .portionName,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      maxFontSize: 12,
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            secondaryTextStateColor,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    AutoSizeText(
                                                      "\$${(Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].price as double).toStringAsFixed(2)}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      maxFontSize: 12,
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            secondaryTextStateColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ListView.builder(
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemBuilder: (ctx, iterTags) {
                                                    return Row(
                                                      children: [
                                                        AutoSizeText(
                                                          '${(Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].tags[iterTags]['quantity'] as double).toInt()} x ${Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].tags[iterTags]['tag']}',
                                                          maxFontSize: 12,
                                                          minFontSize: 8,
                                                          style: TextStyle(
                                                            color:
                                                                normalTextStateColor,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        AutoSizeText(
                                                          '\$${(Provider.of<Tickets>(context).selectedTicketToModify.orders[orderIndex].tags[iterTags]['price'] as double).toStringAsFixed(2)}',
                                                          maxFontSize: 12,
                                                          minFontSize: 8,
                                                          style: TextStyle(
                                                            color:
                                                                normalTextStateColor,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  itemCount: Provider.of<
                                                          Tickets>(context)
                                                      .selectedTicketToModify
                                                      .orders[orderIndex]
                                                      .tags
                                                      .length,
                                                ),
                                                Divider(),
                                                Row(children: [
                                                  AutoSizeText(
                                                    "Total",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.right,
                                                    maxFontSize: 12,
                                                    minFontSize: 8,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          totalTextStateColor,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  AutoSizeText(
                                                    '\$${(orderTotalAmount as double).toStringAsFixed(2)}',
                                                    maxLines: 1,
                                                    textAlign: TextAlign.right,
                                                    maxFontSize: 12,
                                                    minFontSize: 8,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          totalTextStateColor,
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 0,
                              ),
                            ],
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    '\$${(Provider.of<Tickets>(context).selectedTicketToModify.totalAmount + ((Provider.of<Tickets>(context).selectedTicketToModify.tempOrders != null && Provider.of<Tickets>(context).selectedTicketToModify.tempOrders != []) ? (Provider.of<Tickets>(context).selectedTicketToModify.tempOrders as List).fold(0, (previousValue, element) => previousValue + element['total']) : 0)).toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isExpanded: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OptionsLeftPanel extends StatelessWidget {
  final entityType;
  final entityName;
  const OptionsLeftPanel({
    this.entityType,
    this.entityName,
  });
  // const OptionsLeftPanel({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List commandsAvailableForTicket = [];
    if (Provider.of<Tickets>(context).selectedTicketToModify != null) {
      if (Provider.of<Config>(context, listen: false)
                  .selectedTicketAutomation !=
              null ||
          Provider.of<Config>(context, listen: false)
              .selectedTicketAutomation
              .isNotEmpty) {
        commandsAvailableForTicket = Provider.of<Config>(context, listen: false)
            .selectedTicketAutomation
            .where((element) => element.toString().contains(
                (Provider.of<Tickets>(context).selectedTicketToModify.states)
                    .firstWhere((element) =>
                        element['stateName'] == 'Status')['state']))
            .toList();
      } else {
        commandsAvailableForTicket = [];
      }
    }
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              bottom: 10.0,
              top: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Provider.of<Tickets>(context).selectedTicketToModify != null
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                height: 60,
                                width: double.infinity,
                                child: FlatButton(
                                  color: Colors.white,
                                  textColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                        color: Colors.black.withOpacity(0.1),
                                        width: 1.0),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return WillPopScope(
                                          onWillPop: () {},
                                          child: AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: Text(
                                              "Ejecutando\n${commandsAvailableForTicket[index]['ButtonHeader']}",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: FittedBox(
                                                    child:
                                                        const CircularProgressIndicator())),
                                          ),
                                        );
                                      },
                                    );

                                    Provider.of<Tickets>(context, listen: false)
                                        .executeAutomationCommandForTicket(
                                            automationName:
                                                commandsAvailableForTicket[
                                                    index]['Name'])
                                        .then((value) {
                                      Provider.of<Tickets>(context,
                                              listen: false)
                                          .getLastTicketsOfEntity(
                                        entityName,
                                        entityType,
                                      )
                                          .then((value) {
                                        if (Provider.of<Tickets>(context,
                                                        listen: false)
                                                    .tempTickets !=
                                                null &&
                                            Provider.of<Tickets>(context,
                                                    listen: false)
                                                .tempTickets
                                                .isNotEmpty) {
                                          bool
                                              tempTicketsContainsLastSelectedTicked =
                                              Provider.of<Tickets>(context,
                                                      listen: false)
                                                  .tempTickets
                                                  .any((element) =>
                                                      element.id ==
                                                      Provider.of<Tickets>(
                                                              context,
                                                              listen: false)
                                                          .selectedTicketToModify
                                                          .id);
                                          if (tempTicketsContainsLastSelectedTicked) {
                                            Provider.of<Tickets>(context,
                                                    listen: false)
                                                .selectedTicketToModify = Provider
                                                    .of<Tickets>(context,
                                                        listen: false)
                                                .tempTickets
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    Provider.of<Tickets>(
                                                            context,
                                                            listen: false)
                                                        .selectedTicketToModify
                                                        .id);
                                          }
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      });

                                      Navigator.of(context).pop();
                                    }).catchError((error) {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(error.toString())));
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: AutoSizeText(
                                    commandsAvailableForTicket[index]
                                            ['ButtonHeader']
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          );
                        },
                        itemCount: commandsAvailableForTicket.length,
                      )
                    : Container(),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                          color: Colors.black.withOpacity(0.1), width: 1.0),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () {
                      Provider.of<Tickets>(context, listen: false)
                          .resetTempOrders();
                      Navigator.of(context).pushNamed(
                        PosScreen.routeName,
                        arguments: {
                          'entityIsEmpty': false,
                          'isNewTicket': true,
                          'tableName': entityName,
                          'entityType': entityType,
                        },
                      );
                    },
                    child: AutoSizeText(
                      'Nuevo\nTicket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                          color: Colors.black.withOpacity(0.1), width: 1.0),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () {
                      if (Provider.of<Tickets>(context, listen: false)
                              .selectedTicketToModify !=
                          null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SelectClientDialog();
                            });
                      } else {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Manten presionado un ticket para seleccionarlo')));
                      }
                    },
                    child: AutoSizeText(
                      'Seleccionar\nCliente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                          color: Colors.black.withOpacity(0.1), width: 1.0),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () {
                      if (Provider.of<Tickets>(context, listen: false)
                              .selectedTicketToModify !=
                          null) {
                        Provider.of<Tickets>(context, listen: false)
                            .resetTempOrders();

                        Navigator.of(context).pushNamed(
                          PosScreen.routeName,
                          arguments: {
                            'entityIsEmpty': false,
                            'isNewTicket': false,
                            'tableName': entityName,
                            'entityType': entityType,
                          },
                        );
                      } else {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Manten presionado un ticket para seleccionarlo')));
                      }
                    },
                    child: AutoSizeText(
                      'Agregar\nProducto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                          color: Colors.black.withOpacity(0.1), width: 1.0),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () {
                      if (Provider.of<Tickets>(context, listen: false)
                              .selectedTicketToModify !=
                          null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChangeTableDialog(
                                entityType: entityType,
                              );
                            });
                      } else {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Manten presionado un ticket para seleccionarlo')));
                      }
                    },
                    child: AutoSizeText(
                      'Cambiar\nMesa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                          color: Colors.black.withOpacity(0.1), width: 1.0),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () => 1 + 1,
                    child: AutoSizeText(
                      'Seleccionar\nMesero',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectClientDialog extends StatefulWidget {
  @override
  _SelectClientDialogState createState() => _SelectClientDialogState();
}

class _SelectClientDialogState extends State<SelectClientDialog> {
  int selectedIndex = 0;
  void selectIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AutoSizeText(
                  'Selecciona Cliente',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 24,
                  minFontSize: 18,
                ),
                selectedIndex != 0
                    ? Row(
                        children: [
                          IconButton(
                            splashRadius: 18,
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => selectIndex(0),
                          ),
                          Spacer(),
                        ],
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: selectedIndex == 0
                  ? SearchClientOptionsScreen(
                      selectIndex: selectIndex,
                    )
                  : SearchClientScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchClientOptionsScreen extends StatelessWidget {
  final Function selectIndex;

  SearchClientOptionsScreen({this.selectIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(
          //         'Ticket #${Provider.of<Tickets>(context).selectedClientsToAdd[index]['ticketId'].toString()}',
          //       ),
          //       subtitle: Text(
          //           'Cambiar a ${Provider.of<Tickets>(context).selectedClientsToAdd[index]['entityName'].toString()}'),
          //       trailing: IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () {
          //           Provider.of<Tickets>(context, listen: false)
          //               .selectedClientsToAdd
          //               .removeWhere((element) =>
          //                   element['ticketId'] ==
          //                   Provider.of<Tickets>(context, listen: false)
          //                       .selectedClientsToAdd[index]['ticketId']);
          //         },
          //       ),
          //     );
          //   },
          //   itemCount:
          //       Provider.of<Tickets>(context).selectedClientsToAdd.length,
          // ),
          Flexible(
            fit: FlexFit.loose,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.blueAccent,
              minWidth: double.infinity,
              onPressed: () => selectIndex(1),
              child: Text(
                'BUSCAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.blueAccent,
              minWidth: double.infinity,
              onPressed: () {},
              child: Text(
                'CREAR NUEVO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchClientScreen extends StatefulWidget {
  const SearchClientScreen({
    Key key,
  }) : super(key: key);

  @override
  _SearchClientScreenState createState() => _SearchClientScreenState();
}

class _SearchClientScreenState extends State<SearchClientScreen> {
  final searchController = TextEditingController();
  List clientList = [];
  List filteredClientList = [];

  @override
  void initState() {
    searchController..addListener(showSearch);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    clientList = Provider.of<Config>(context).clientsList;
    super.didChangeDependencies();
  }

  void showSearch() {
    setState(() {
      filteredClientList = clientList.where((client) {
        return (client['name'] as String)
                .contains(searchController.text.trim()) ||
            (client['customData'][0]['value'].toString().toLowerCase()
                    as String)
                .contains(searchController.text.toLowerCase().trim());
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.5,
      // padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar',
              prefixIcon: Icon(Icons.search),
              filled: false,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Expanded(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredClientList.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    onTap: () {
                      if (Provider.of<Tickets>(context, listen: false)
                          .selectedClientsToAdd
                          .any((element) =>
                              element['ticketId'] ==
                              Provider.of<Tickets>(context, listen: false)
                                  .selectedTicketToModify
                                  .id)) {
                        final clientIndex =
                            Provider.of<Tickets>(context, listen: false)
                                .selectedClientsToAdd
                                .indexWhere((element) =>
                                    element['ticketId'] ==
                                    Provider.of<Tickets>(context, listen: false)
                                        .selectedTicketToModify
                                        .id);
                        Provider.of<Tickets>(context, listen: false)
                            .selectedClientsToAdd[clientIndex] = {
                          'ticketId':
                              Provider.of<Tickets>(context, listen: false)
                                  .selectedTicketToModify
                                  .id,
                          'clientName': filteredClientList[index]['name'],
                        };
                      } else {
                        Provider.of<Tickets>(context, listen: false)
                            .selectedClientsToAdd
                            .add({
                          'ticketId':
                              Provider.of<Tickets>(context, listen: false)
                                  .selectedTicketToModify
                                  .id,
                          'clientName': filteredClientList[index]['name'],
                        });
                      }
                      Provider.of<Tickets>(context, listen: false)
                          .notifyListeners();
                      Navigator.of(context).pop();
                    },
                    title: Text(filteredClientList[index]['name']),
                    subtitle: Text((filteredClientList[index]['customData']
                            as List)
                        .firstWhere(
                            (element) => element['name'] == "Nombre")['value']
                        .toString()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeTableDialog extends StatefulWidget {
  final entityName;
  final entityType;
  const ChangeTableDialog({
    this.entityName,
    this.entityType,
    Key key,
  }) : super(key: key);

  @override
  _ChangeTableDialogState createState() => _ChangeTableDialogState();
}

class _ChangeTableDialogState extends State<ChangeTableDialog> {
  final tableController = TextEditingController();
  List tableList = [];
  List filteredTableList = [];

  @override
  void initState() {
    tableController..addListener(showSearch);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    tableList = Provider.of<Entities>(context).storedEntities(
      entityType: widget.entityType,
    );
    super.didChangeDependencies();
  }

  void showSearch() {
    setState(() {
      filteredTableList = tableList.where((entity) {
        return (entity['name'].toString().toLowerCase())
            .contains(tableController.text.toLowerCase().trim());
      }).toList();
    });
  }

  @override
  void dispose() {
    tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AutoSizeText(
              'Cambiar Mesa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 24,
              minFontSize: 18,
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(
            //         'Ticket #${Provider.of<Tickets>(context).selectedEntityToChange[index]['ticketId'].toString()}',
            //       ),
            //       subtitle: Text(
            //           'Cambiar a ${Provider.of<Tickets>(context).selectedEntityToChange[index]['entityName'].toString()}'),
            //       trailing: IconButton(
            //         icon: Icon(Icons.delete),
            //         onPressed: () {
            //           setState(() {
            //             Provider.of<Tickets>(context, listen: false)
            //                 .selectedEntityToChange
            //                 .removeWhere((element) =>
            //                     element['ticketId'] ==
            //                     Provider.of<Tickets>(context, listen: false)
            //                         .selectedEntityToChange[index]['ticketId']);
            //           });
            //         },
            //       ),
            //     );
            //   },
            //   itemCount:
            //       Provider.of<Tickets>(context).selectedEntityToChange.length,
            // ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: tableController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                  ),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredTableList.length,
                  itemBuilder: (ctx, index) {
                    print('CONTANDO HASTA ERROR ${filteredTableList[index]}');
                    return ListTile(
                      title: Text(filteredTableList[index]['name']),
                      subtitle: Text(
                          (filteredTableList[index] as Map)['states'] != null
                              ? (filteredTableList[index]['states'] as List)
                                  .firstWhere((element) =>
                                      element.containsKey('stateName')
                                          ? (element['stateName'] == "Status")
                                          : false)['state']
                                  .toString()
                              : "Sin estado"),
                      onTap: () {
                        if (Provider.of<Tickets>(context, listen: false)
                            .selectedEntityToChange
                            .any((element) =>
                                element['ticketId'] ==
                                Provider.of<Tickets>(context, listen: false)
                                    .selectedTicketToModify
                                    .id)) {
                          final entityIndex = Provider.of<Tickets>(context,
                                  listen: false)
                              .selectedEntityToChange
                              .indexWhere((element) =>
                                  element['ticketId'] ==
                                  Provider.of<Tickets>(context, listen: false)
                                      .selectedTicketToModify
                                      .id);
                          Provider.of<Tickets>(context, listen: false)
                              .selectedEntityToChange[entityIndex] = {
                            'ticketId':
                                Provider.of<Tickets>(context, listen: false)
                                    .selectedTicketToModify
                                    .id,
                            'entityName': filteredTableList[index]['name'],
                          };
                        } else {
                          Provider.of<Tickets>(context, listen: false)
                              .selectedEntityToChange
                              .add({
                            'ticketId':
                                Provider.of<Tickets>(context, listen: false)
                                    .selectedTicketToModify
                                    .id,
                            'entityName': filteredTableList[index]['name'],
                          });
                        }
                        Provider.of<Tickets>(context, listen: false)
                            .notifyListeners();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtonsBar extends StatelessWidget {
  final entityName;
  final entityType;
  const BottomButtonsBar({
    this.entityName,
    this.entityType,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      height: 56,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Hero(
              tag: 'closeButton',
              child: OutlineButton(
                hoverColor: Colors.red,
                focusColor: Colors.red,
                highlightedBorderColor: Colors.red,
                highlightColor: Colors.red.withOpacity(0.1),
                splashColor: Colors.red.withOpacity(0.2),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext ctx) {
                      return WillPopScope(
                        onWillPop: () {},
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text(
                            "Cerrando Ticket",
                            textAlign: TextAlign.center,
                          ),
                          content: SizedBox(
                              height: 40,
                              width: 40,
                              child: FittedBox(
                                  child: const CircularProgressIndicator())),
                        ),
                      );
                    },
                  );

                  Provider.of<Tickets>(context, listen: false)
                      .closeTicket(
                    selectedClientEntity:
                        Provider.of<Config>(context, listen: false)
                            .selectedClientEntity,
                    entityName: entityName,
                    entityType: entityType,
                  )
                      .then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    Navigator.of(context).pop();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  });
                },
                child: Text(
                  'CERRAR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Hero(
              tag: 'secondButton',
              child: OutlineButton(
                // hoverColor: Colors.red,
                // focusColor: Colors.red,
                // highlightedBorderColor: Colors.red,
                // highlightColor: Colors.red.withOpacity(0.1),
                // splashColor: Colors.red.withOpacity(0.2),
                // color: Colors.red,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'ATRÁS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
