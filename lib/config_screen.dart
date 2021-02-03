import 'package:NodePos/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatelessWidget {
  static const routeName = '/config-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
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
                        "Actualizando datos",
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
              Provider.of<Config>(context, listen: false)
                  .getServerSettings(false)
                  .then((value) => Navigator.pop(context))
                  .catchError(
                      (onError) => Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("No se ha podido actualizar"),
                          )));
            },
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Configuración',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ConfigScreenWidget(),
    );
  }
}

class ConfigScreenWidget extends StatefulWidget {
  @override
  _ConfigScreenWidgetState createState() => _ConfigScreenWidgetState();
}

class _ConfigScreenWidgetState extends State<ConfigScreenWidget> {
  final addressField = TextEditingController();
  final portField = TextEditingController();
  final secretKeyField = TextEditingController();
  final modifierPercentageController = TextEditingController();

  String selectedMenu = '';
  List selectedEntities = [];
  List selectedTicketAutomation = [];
  List selectedOrderAutomation = [];
  String selectedClientEntity = '';
  String selectedDepartment = '';
  String selectedTicket = '';

  @override
  void initState() {
    if (Provider.of<Config>(context, listen: false).selectedTicketAutomation !=
        null) {
      selectedTicketAutomation =
          Provider.of<Config>(context, listen: false).selectedTicketAutomation;
    }
    if (Provider.of<Config>(context, listen: false).selectedOrderAutomation !=
        null) {
      selectedOrderAutomation =
          Provider.of<Config>(context, listen: false).selectedOrderAutomation;
    }

    selectedTicket = Provider.of<Config>(context, listen: false).selectedTicket;
    selectedMenu = Provider.of<Config>(context, listen: false).selectedMenu;
    selectedEntities =
        Provider.of<Config>(context, listen: false).selectedEntities;
    selectedClientEntity =
        Provider.of<Config>(context, listen: false).selectedClientEntity;
    selectedDepartment =
        Provider.of<Config>(context, listen: false).selectedDepartment;

    super.initState();
  }

  @override
  void dispose() {
    addressField.dispose();
    portField.dispose();
    secretKeyField.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Config>(context).isAuth) {
      addressField.text = Provider.of<Config>(context, listen: false).address;
      portField.text = Provider.of<Config>(context, listen: false).port;
      secretKeyField.text =
          Provider.of<Config>(context, listen: false).secretKey;
    }

    return SingleChildScrollView(
      child: Container(
        // padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Column(
            //     children: [
            //       TextField(
            //         controller: addressField,
            //         decoration: InputDecoration(
            //           filled: true,
            //           icon: Icon(Icons.wifi),
            //           hintText: '0.0.0.0',
            //           labelText: 'Dirección',
            //           contentPadding: EdgeInsets.symmetric(
            //             horizontal: 16,
            //             vertical: 10,
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 22,
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: TextField(
            //               controller: portField,
            //               decoration: InputDecoration(
            //                   filled: true,
            //                   icon: Icon(Icons.confirmation_number),
            //                   hintText: '0000',
            //                   labelText: 'Puerto',
            //                   contentPadding: EdgeInsets.symmetric(
            //                     horizontal: 16,
            //                     vertical: 10,
            //                   )),
            //             ),
            //           ),
            //           SizedBox(width: 18),
            //           Expanded(
            //             child: TextField(
            //               controller: secretKeyField,
            //               decoration: InputDecoration(
            //                   filled: true,
            //                   // icon: Icon(Icons.lock),
            //                   hintText: '••••',
            //                   labelText: 'Secret Key',
            //                   contentPadding: EdgeInsets.symmetric(
            //                     horizontal: 16,
            //                     vertical: 10,
            //                   )),
            //             ),
            //           ),
            //         ],
            //       ),
            //       ButtonBar(
            //         children: [
            //           RaisedButton(
            // onPressed: () {
            //   showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     builder: (BuildContext ctx) {
            //       return WillPopScope(
            //         onWillPop: () {},
            //         child: AlertDialog(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           title: const Text(
            //             "Actualizando datos",
            //             textAlign: TextAlign.center,
            //           ),
            //           content: SizedBox(
            //               height: 40,
            //               width: 40,
            //               child: FittedBox(
            //                   child:
            //                       const CircularProgressIndicator())),
            //         ),
            //       );
            //     },
            //   );
            //   Provider.of<Config>(context, listen: false)
            //       .getServerSettings(false)
            //       .then((value) => Navigator.pop(context))
            //       .catchError((onError) =>
            //           Scaffold.of(context).showSnackBar(SnackBar(
            //             content: Text("No se ha podido actualizar"),
            //           )));
            // },
            //             color: Colors.blueAccent,
            //             child: Text('ACTUALIZAR'),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedMenu),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Menú',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR MENÚ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              // color: Colors.black12,
                              child: StatefulBuilder(
                                builder: (ctx, setStateRadio) {
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    primary: true,
                                    // shrinkWrap: true,
                                    itemBuilder: (ctx, index) {
                                      return RadioListTile(
                                        groupValue: selectedMenu,
                                        value: Provider.of<Config>(context)
                                            .screenMenu[index]['Name'],
                                        onChanged: (e) {
                                          setState(() {
                                            setStateRadio(() {
                                              selectedMenu = e;
                                            });
                                          });
                                        },
                                        title: Text(
                                            '${Provider.of<Config>(context).screenMenu[index]['Name']}'),
                                      );
                                    },
                                    itemCount: Provider.of<Config>(context)
                                        .screenMenu
                                        .length,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedTicket),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Entidad Ticket',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR TICKET',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              // color: Colors.black12,
                              child: StatefulBuilder(
                                builder: (ctx, setStateRadio) {
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    primary: true,
                                    // shrinkWrap: true,
                                    itemBuilder: (ctx, index) {
                                      return RadioListTile(
                                        groupValue: selectedTicket,
                                        value: Provider.of<Config>(context)
                                            .ticketType[index]['Name'],
                                        onChanged: (e) {
                                          setState(() {
                                            setStateRadio(() {
                                              selectedTicket = e;
                                            });
                                          });
                                        },
                                        title: Text(
                                            '${Provider.of<Config>(context).ticketType[index]['Name']}'),
                                      );
                                    },
                                    itemCount: Provider.of<Config>(context)
                                        .screenMenu
                                        .length,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedEntities
                  .toString()
                  .substring(1, selectedEntities.toString().length - 1)),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Entidades',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR ENTIDADES',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                                // color: Colors.black12,
                                child: StatefulBuilder(
                                    builder: (ctx, setStateCheckbox) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: true,
                                // shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    value: selectedEntities.contains(
                                        Provider.of<Config>(context)
                                            .entityType[index]['Name']),
                                    onChanged: (e) {
                                      if (!e) {
                                        if (selectedEntities.length != 1) {
                                          setState(() {
                                            setStateCheckbox(() {
                                              selectedEntities.removeWhere(
                                                  (element) =>
                                                      element ==
                                                      Provider.of<Config>(
                                                                  context,
                                                                  listen: false)
                                                              .entityType[index]
                                                          ['Name']);
                                            });
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          setStateCheckbox(() {
                                            selectedEntities.add(
                                                Provider.of<Config>(context,
                                                        listen: false)
                                                    .entityType[index]['Name']);
                                          });
                                        });
                                      }
                                    },
                                    title: Text(
                                        '${Provider.of<Config>(context).entityType[index]['Name']}'),
                                  );
                                },
                                itemCount: Provider.of<Config>(context)
                                    .entityType
                                    .length,
                              );
                            })),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedClientEntity),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Entidad Cliente',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR ENTIDAD CLIENTE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                                // color: Colors.black12,
                                child: StatefulBuilder(
                                    builder: (ctx, setStateRadio) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: true,
                                // shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return RadioListTile(
                                    groupValue: selectedClientEntity,
                                    value: Provider.of<Config>(context)
                                        .entityType[index]['Name'],
                                    onChanged: (e) {
                                      setStateRadio(() {
                                        selectedClientEntity = e;
                                      });
                                    },
                                    title: Text(
                                        '${Provider.of<Config>(context).entityType[index]['Name']}'),
                                  );
                                },
                                itemCount: Provider.of<Config>(context)
                                    .entityType
                                    .length,
                              );
                            })),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedDepartment),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Departamento',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR DEPARTAMENTO',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                                // color: Colors.black12,
                                child: StatefulBuilder(
                                    builder: (ctx, setStateRadio) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: true,
                                // shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return RadioListTile(
                                    groupValue: selectedDepartment,
                                    value: Provider.of<Config>(context)
                                        .department[index]['Name'],
                                    onChanged: (e) {
                                      setState(() {
                                        setStateRadio(() {
                                          selectedDepartment = e;
                                        });
                                      });
                                    },
                                    title: Text(
                                        '${Provider.of<Config>(context).department[index]['Name']}'),
                                  );
                                },
                                itemCount: Provider.of<Config>(context)
                                    .department
                                    .length,
                              );
                            })),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedTicketAutomation
                  .map((e) => e['Name'])
                  .toList()
                  .toString()
                  .substring(
                      1,
                      selectedTicketAutomation
                              .map((e) => e['Name'])
                              .toList()
                              .toString()
                              .length -
                          1)),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Comandos Ticket',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR COMANDOS TICKET',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                                // color: Colors.black12,
                                child: StatefulBuilder(
                                    builder: (ctx, setStateCheckbox) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: true,
                                // shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    value: selectedTicketAutomation
                                        .map((e) => e['Name'].toString())
                                        .toList()
                                        .contains(Provider.of<Config>(context)
                                            .automationCommand[index]['Name']
                                            .toString()),
                                    onChanged: (e) {
                                      if (!e) {
                                        if (selectedTicketAutomation.length !=
                                            1) {
                                          setState(() {
                                            setStateCheckbox(() {
                                              selectedTicketAutomation
                                                  .removeWhere((element) =>
                                                      element['Name'] ==
                                                      Provider.of<Config>(
                                                                  context,
                                                                  listen: false)
                                                              .automationCommand[
                                                          index]['Name']);
                                            });
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          setStateCheckbox(() {
                                            selectedTicketAutomation.add(
                                                Provider.of<Config>(context,
                                                        listen: false)
                                                    .automationCommand[index]);
                                          });
                                        });
                                      }
                                    },
                                    title: Text(
                                        '${Provider.of<Config>(context).automationCommand[index]['Name']}'),
                                  );
                                },
                                itemCount: Provider.of<Config>(context)
                                    .automationCommand
                                    .length,
                              );
                            })),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              subtitle: Text(selectedOrderAutomation
                  .map((e) => e['ButtonHeader'])
                  .toList()
                  .toString()
                  .substring(
                      1,
                      selectedOrderAutomation
                              .map((e) => e['ButtonHeader'])
                              .toList()
                              .toString()
                              .length -
                          1)),
              trailing: Icon(Icons.arrow_drop_down),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(6)),
              title: Text(
                'Seleccionar Comandos Ordenes',
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.4,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            color: Colors.blueAccent.withOpacity(0.05),
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'SELECCIONAR COMANDOS ORDENES',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                                // color: Colors.black12,
                                child: StatefulBuilder(
                                    builder: (ctx, setStateCheckbox) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                primary: true,
                                // shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    value: selectedOrderAutomation
                                        .map((e) => e['Name'].toString())
                                        .toList()
                                        .contains(Provider.of<Config>(context)
                                            .automationCommand[index]['Name']),
                                    onChanged: (e) {
                                      if (!e) {
                                        if (selectedOrderAutomation.length !=
                                            1) {
                                          setState(() {
                                            setStateCheckbox(() {
                                              selectedOrderAutomation
                                                  .removeWhere((element) =>
                                                      element['Name'] ==
                                                      Provider.of<Config>(
                                                                  context,
                                                                  listen: false)
                                                              .automationCommand[
                                                          index]['Name']);
                                            });
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          setStateCheckbox(() {
                                            selectedOrderAutomation.add(
                                                Provider.of<Config>(context,
                                                        listen: false)
                                                    .automationCommand[index]);
                                          });
                                        });
                                      }
                                    },
                                    title: Text(
                                        '${Provider.of<Config>(context).automationCommand[index]['Name']}'),
                                  );
                                },
                                itemCount: Provider.of<Config>(context)
                                    .automationCommand
                                    .length,
                              );
                            })),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 0,
            ),

            // Text('Porcentaje modificador Ticket'),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: modifierPercentageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    filled: true,
                    suffix: Text('%'),
                    // prefix: Text('Modificador total ticket: '),
                    icon: Icon(Icons.attach_money),
                    hintText: '00.00',
                    labelText: 'Modificador Total Ticket',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    )),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ButtonBar(
                children: [
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text('GUARDAR CAMBIOS'),
                    onPressed: () {
                      Provider.of<Config>(context, listen: false)
                          .saveServerPreferences(
                              newSelectedMenu: selectedMenu,
                              newSelectedClientEntity: selectedClientEntity,
                              newSelectedDepartment: selectedDepartment,
                              newSelectedEntities: selectedEntities,
                              newSelectedTicket: selectedTicket,
                              newSelectedOrderAutomation:
                                  selectedOrderAutomation,
                              newSelectedTicketAutomation:
                                  selectedTicketAutomation)
                          .then((value) {
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Se han guardado los cambios'),
                          duration: Duration(
                            seconds: 1,
                          ),
                        ));
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
