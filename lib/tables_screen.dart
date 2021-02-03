import 'dart:async';

import 'package:NodePos/config_screen.dart';
import 'package:NodePos/expired_token_screen.dart';
import 'package:NodePos/pos_screen.dart';
import 'package:NodePos/providers/auth.dart';
import 'package:NodePos/providers/connection_state.dart';
import 'package:NodePos/providers/local_user.dart';
import 'package:NodePos/providers/menu.dart';
import 'package:NodePos/providers/tables.dart';
import 'package:NodePos/providers/tickets.dart';
import 'package:NodePos/ticket_screen.dart';
import 'package:NodePos/select_ticket_screen.dart';

import 'package:NodePos/update_menu_screen..dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

AppBar appbar(BuildContext context, List tabsEntities) {
  return AppBar(
    iconTheme: new IconThemeData(
      color: Colors.black,
    ),
    bottom: TabBar(
      isScrollable: true,
      labelColor: Colors.black,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      tabs: [
        ...tabsEntities.map((entity) => Tab(
              text: entity,
            )),
      ],
    ),
    title: Row(
      children: [
        Text(
          'techPOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
    elevation: 1,
    backgroundColor: Colors.white,
  );
}

class TablesScreen extends StatelessWidget {
  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("No se ha podido actualizar el menú"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static const routeName = '/tables_screen';
  @override
  Widget build(BuildContext context) {
    // Provider.of<Entities>(context,listen:false).launchWebView();
    return DefaultTabController(
      length: Provider.of<Config>(context).selectedEntities.length,
      child: Scaffold(
        drawer: Drawer(
          elevation: 5,
          child: ListView(
            children: [
              Container(
                color: Colors.blueAccent.withOpacity(0.05),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Provider.of<User>(context).userName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      Provider.of<User>(context).userRole.toString(),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                trailing: Icon(Icons.refresh),
                onTap: () {
                  Navigator.of(context).pushNamed(UpdateMenuScreen.routeName);
                },
                title: Text(
                  'Actualizar menú',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                trailing: Icon(Icons.settings),
                onTap: () {
                  Navigator.pushNamed(context, ConfigScreen.routeName);
                },
                title: Text(
                  'Ajustes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                trailing: Icon(Icons.pause_circle_outline),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<User>(context, listen: false).logOut();
                },
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(237, 242, 247, 1),
        appBar: appbar(
          context,
          Provider.of<Config>(context, listen: false).selectedEntities,
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  ...Provider.of<Config>(context, listen: false)
                      .selectedEntities
                      .map((e) => Column(
                            children: [
                              Expanded(
                                child: TablesGrid(
                                  entityType: e,
                                ),
                              ),
                            ],
                          )),
                ],
              ),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Consumer<CheckConnectionState>(
                builder: (context, connecState, _) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Provider.of<CheckConnectionState>(context)
                                  .internetOn
                              ? Colors.green
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        margin: EdgeInsets.only(
                          left: 30,
                          right: 5,
                        ),
                        width: 10,
                        height: 10,
                      ),
                      Text(
                        ' INTERNET',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Provider.of<CheckConnectionState>(context)
                                  .serverOn
                              ? Colors.green
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        margin: EdgeInsets.only(
                          left: 30,
                          right: 5,
                        ),
                        width: 10,
                        height: 10,
                      ),
                      Text(
                        ' SERVIDOR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TablesGrid extends StatefulWidget {
  final String entityType;
  TablesGrid({this.entityType});

  @override
  _TablesGridState createState() => _TablesGridState();
}

class _TablesGridState extends State<TablesGrid> {
  // final flutterWebViewPlugin = FlutterWebviewPlugin();

  // StreamSubscription<WebViewStateChanged> _onStateChanged;
  // StreamSubscription<WebViewHttpError> _onHttpError;

  // @override
  // void didChangeDependencies() {
  //   final Set<JavascriptChannel> jsChannels = [
  //     JavascriptChannel(
  //         name: 'Print',
  //         onMessageReceived: (JavascriptMessage message) {
  //           refreshEntities(context);
  //         }),
  //   ].toSet();

  //   // flutterWebViewPlugin.close();

  //   _onStateChanged =
  //       flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
  //     if (state.type == WebViewState.startLoad) {
  //       // print(state.type);
  //     }
  //   });

  //   // if(flutterWebViewPlugin.)

  //   flutterWebViewPlugin.launch(
  //     'http://${Provider.of<Config>(context).address}:${Provider.of<Config>(context).port}/flutter-signalr.html',
  //     hidden: true,
  //     javascriptChannels: jsChannels,
  //     clearCache: true,
  //   );

  //   super.didChangeDependencies();
  // }

  Future<void> refreshEntities(ctx) async {
    print('se refresca');
    try {
      Provider.of<Entities>(context, listen: false).notifyListeners();
      setState(() {});
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Actualizado'),
        duration: Duration(seconds: 1),
      ));
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('No se ha podido actualizar'),
        duration: Duration(seconds: 1),
      ));
    }
  }

  bool isTablesInitialized = false;

  @override
  Widget build(BuildContext context) {
    Provider.of<Menus>(context, listen: false).getOrderTags();
    Provider.of<Menus>(context, listen: false).loadMenu('Menu').then(
        (value) => Provider.of<Menus>(context, listen: false).getAllProducts());

    return RefreshIndicator(
      displacement: 16,
      onRefresh: () => refreshEntities(context),
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !isTablesInitialized) {
            isTablesInitialized = true;
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 60),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, i) {
                  return FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () {},
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: const Text(
                                "Cargando",
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
                          .registerTerminal()
                          .catchError((error) {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text('No hay conexión, vuelve a intentarlo')));
                        Navigator.of(context).pop();
                      });
                      //reset data
                      Provider.of<Tickets>(context, listen: false)
                          .resetTempOrders();
                      //open new ticket or available ticket
                      Provider.of<Entities>(context, listen: false)
                          .checkEntityState(
                              entityType: widget.entityType,
                              entityName: snapshot.data[i]['name'])
                          .then((value) {
                        if (value) {
                          Navigator.of(context).popAndPushNamed(
                            PosScreen.routeName,
                            arguments: {
                              'entityIsEmpty': true,
                              'isNewTicket': true,
                              'tableName': snapshot.data[i]['name'] != null
                                  ? '${snapshot.data[i]['name']}'
                                  : 'Null',
                              'entityType': widget.entityType,
                            },
                          );
                        } else {
                          Provider.of<Tickets>(context, listen: false)
                              .resetTempTicketsData();
                          Provider.of<Tickets>(context, listen: false)
                              .getLastTicketsOfEntity(
                            snapshot.data[i]['name'],
                            widget.entityType,
                          )
                              .then((value) {
                            if (Provider.of<Tickets>(context, listen: false)
                                    .tempTickets
                                    .length ==
                                1) {
                              Provider.of<Tickets>(context, listen: false)
                                      .selectedTicketToModify =
                                  Provider.of<Tickets>(context, listen: false)
                                      .tempTickets[0];
                                      print('HOLASAAA');
                                      print(Provider.of<Tickets>(context, listen: false)
                                      .selectedTicketToModify);
                              Navigator.of(context).popAndPushNamed(
                                  TicketScreen.routeName,
                                  arguments: {
                                    'entityIsEmpty': true,
                                    'isNewTicket': true,
                                    'entityName':
                                        snapshot.data[i]['name'] != null
                                            ? '${snapshot.data[i]['name']}'
                                            : 'Null',
                                    'entityType': widget.entityType,
                                  });
                            } else {
                              Navigator.of(context).popAndPushNamed(
                                  SelectTicketScreen.routeName,
                                  arguments: {
                                    'entityIsEmpty': true,
                                    'isNewTicket': true,
                                    'entityName':
                                        snapshot.data[i]['name'] != null
                                            ? '${snapshot.data[i]['name']}'
                                            : 'Null',
                                    'entityType': widget.entityType,
                                  });
                            }
                          });
                        }
                      });
                    },
                    child: Center(
                        child: Text(
                      snapshot.data[i]['name'] != null
                          ? '${snapshot.data[i]['name']}'
                          : 'Null',
                      style: TextStyle(
                        color: snapshot.data[i]['states'] == null
                            ? Colors.black
                            : snapshot.data[i]['states'][0]['state'] ==
                                    'Bill Requested'
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    color: snapshot.data[i]['states'] == null
                        ? Colors.white
                        : snapshot.data[i]['states'][0]['state'] == 'Available'
                            ? Colors.white
                            : snapshot.data[i]['states'][0]['state'] ==
                                    'New Orders'
                                ? Colors.amber
                                : Colors.redAccent,
                    // decoration: BoxDecoration(

                    //   borderRadius: BorderRadius.circular(4),
                    // ),
                  );
                },
                itemCount: snapshot.data.length,
              ),
            );
          }
          if (snapshot.hasError) {
            // Scaffold.of(context).showSnackBar(SnackBar(content: Text('No hay conexión')));
            print(snapshot.error.toString());
            List<dynamic> storedTables =
                Provider.of<Entities>(context, listen: false)
                    .storedEntities(entityType: widget.entityType);
            // print('BUSCANDO EL ERROR: $storedTables');
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 60),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, i) {
                  // print(storedTables[i]['states'].toString());
                  return FlatButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () {},
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: const Text(
                                "Cargando",
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
                          .registerTerminal()
                          .then((value) {
                        Provider.of<Entities>(context, listen: false)
                            .checkEntityState(
                                entityType: widget.entityType,
                                entityName: snapshot.data[i]['name'])
                            .then((value) {
                          if (value) {
                            Navigator.of(context).popAndPushNamed(
                              PosScreen.routeName,
                              arguments: {
                                'entityIsEmpty': true,
                                'isNewTicket': true,
                                'tableName': snapshot.data[i]['name'] != null
                                    ? '${snapshot.data[i]['name']}'
                                    : 'Null',
                                'entityType': widget.entityType,
                              },
                            );
                          } else {
                            Provider.of<Tickets>(context, listen: false)
                                .resetTempTicketsData();

                            Provider.of<Tickets>(context, listen: false)
                                .getLastTicketsOfEntity(
                                  snapshot.data[i]['name'],
                                  widget.entityType,
                                )
                                .then((value) { 
                                  
                            if (Provider.of<Tickets>(context, listen: false)
                                    .tempTickets
                                    .length ==
                                1) {
                              Provider.of<Tickets>(context, listen: false)
                                      .selectedTicketToModify =
                                  Provider.of<Tickets>(context, listen: false)
                                      .tempTickets[0];
                                      print('HOLASAAA');
                                      print(Provider.of<Tickets>(context, listen: false)
                                      .selectedTicketToModify);
                              Navigator.of(context).popAndPushNamed(
                                  TicketScreen.routeName,
                                  arguments: {
                                    'entityIsEmpty': true,
                                    'isNewTicket': true,
                                    'entityName':
                                        snapshot.data[i]['name'] != null
                                            ? '${snapshot.data[i]['name']}'
                                            : 'Null',
                                    'entityType': widget.entityType,
                                  });
                            } else {
                              Navigator.of(context).popAndPushNamed(
                                  SelectTicketScreen.routeName,
                                  arguments: {
                                    'entityIsEmpty': true,
                                    'isNewTicket': true,
                                    'entityName':
                                        snapshot.data[i]['name'] != null
                                            ? '${snapshot.data[i]['name']}'
                                            : 'Null',
                                    'entityType': widget.entityType,
                                  });
                            }
                                });
                          }
                        });
                      }).catchError((error) {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text('No hay conección, vuelve a intentarlo')));
                        Navigator.of(context).pop();
                      });
                      //reset data
                      //open new ticket or available ticket
                    },
                    child: Center(
                        child: Text(
                      storedTables[i]['name'] != null
                          ? '${storedTables[i]['name']}'
                          : 'Null',
                      style: TextStyle(
                        color: storedTables[i]['states'] == null
                            ? Colors.black
                            : storedTables[i]['states'][0]['state'] ==
                                    'Bill Requested'
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    color: storedTables[i]['states'] == null
                        ? Colors.white
                        : storedTables[i]['states'][0]['state'] == 'Available'
                            ? Colors.white
                            : storedTables[i]['states'][0]['state'] ==
                                    'New Orders'
                                ? Colors.amber
                                : Colors.redAccent,
                    // decoration: BoxDecoration(

                    //   borderRadius: BorderRadius.circular(4),
                    // ),
                  );
                },
                itemCount: storedTables.length,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        future: Provider.of<Entities>(context).getEntities(
          entityName: widget.entityType,
        ),
      ),
    );
  }
}
