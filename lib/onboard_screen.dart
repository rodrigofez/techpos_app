import 'package:NodePos/providers/auth.dart';
import 'package:NodePos/providers/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatelessWidget {
  static const routeName = '/onboard_Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardPages(),
    );
  }
}

class OnboardPages extends StatefulWidget {
  @override
  _OnboardPagesState createState() => _OnboardPagesState();
}

class _OnboardPagesState extends State<OnboardPages> {
  final onBoardController = PageController();
  final _formKey = GlobalKey<FormState>();
  String addressValue = '';
  String portValue = '';
  String secretKeyValue = '';
  bool isLoading = false;
  final addressField = TextEditingController();
  final portField = TextEditingController();
  final secretKeyField = TextEditingController();
  String token = '';
  String uri = '';

  String selectedMenu = '';
  List selectedEntities = [];
  String selectedClientEntity = '';
  String selectedDepartment = '';
  String selectedTicketType = '';
  String secondPageStateString;

  Future<void> downloadMenu() async {
    if (selectedMenu == '' ||
        selectedEntities == [] ||
        selectedClientEntity == '' ||
        selectedDepartment == '' ||
        selectedTicketType == '') {
      setState(() {
        secondPageStateString = 'Selecciona todas las opciones';
      });
    } else if (!Provider.of<Menus>(context, listen: false).isUpdating) {
      setState(() {
        // isLoading = true;
        secondPageStateString = '';
      });

      try {
        Future.delayed(Duration(milliseconds: 300)).then((_) async {
          Provider.of<Menus>(context, listen: false)
              .downloadMenu(
                tempMenu: selectedMenu,
                tempToken: token,
                tempUri: uri,
              )
              .then((value) => onBoardController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  ));
          ;
        });
      } catch (error) {
        throw error;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    ;

    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: deviceHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading && onBoardController.page == 0
                  ? LinearProgressIndicator()
                  : Container(),
              Flexible(
                fit: FlexFit.tight,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: onBoardController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Bienvenido a techPOS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  // color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Para poder comenzar a utilizar la app tienes que ingresar los siguientes datos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  // fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),

                          // SizedBox(
                          //   height: 200,
                          //   width: 200,
                          //   child: SvgPicture.asset(
                          //     'assets/images/Onboarding_1.svg',
                          //   ),
                          // ),

                          ServerSetupForm(
                            formKey: _formKey,
                            addressController: addressField,
                            portController: portField,
                            secretKeyController: secretKeyField,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'CONFIGURACIÓN GENERAL',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Provider.of<Menus>(context).isUpdating &&
                                onBoardController.page == 1
                            ? LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent),
                                value:
                                    Provider.of<Menus>(context).contadorItems !=
                                            0
                                        ? (Provider.of<Menus>(context)
                                                .contadorItems /
                                            Provider.of<Menus>(context).nItems)
                                        : 0,
                              )
                            : Container(),
                        secondPageStateString != null
                            ? Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  secondPageStateString,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                        Spacer(),
                        ListTile(
                          subtitle: Text(selectedMenu),
                          trailing: Icon(Icons.arrow_drop_down),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
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
                                  height: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.4,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        color:
                                            Colors.blueAccent.withOpacity(0.05),
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
                                                physics:
                                                    BouncingScrollPhysics(),
                                                primary: true,
                                                // shrinkWrap: true,
                                                itemBuilder: (ctx, index) {
                                                  return RadioListTile(
                                                    groupValue: selectedMenu,
                                                    value: Provider.of<Config>(
                                                                context)
                                                            .screenMenu[index]
                                                        ['Name'],
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
                                                itemCount:
                                                    Provider.of<Config>(context)
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
                          height: 1,
                        ),
                        ListTile(
                          subtitle: Text(selectedTicketType),
                          trailing: Icon(Icons.arrow_drop_down),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          title: Text(
                            'Seleccionar tipo de Ticket',
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return Container(
                                  height: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.4,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        color:
                                            Colors.blueAccent.withOpacity(0.05),
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          'SELECCIONAR TIPO DE TICKET',
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
                                                physics:
                                                    BouncingScrollPhysics(),
                                                primary: true,
                                                // shrinkWrap: true,
                                                itemBuilder: (ctx, index) {
                                                  return RadioListTile(
                                                    groupValue:
                                                        selectedTicketType,
                                                    value: Provider.of<Config>(
                                                                context)
                                                            .ticketType[index]
                                                        ['Name'],
                                                    onChanged: (e) {
                                                      setState(() {
                                                        setStateRadio(() {
                                                          selectedTicketType =
                                                              e;
                                                        });
                                                      });
                                                    },
                                                    title: Text(
                                                        '${Provider.of<Config>(context).ticketType[index]['Name']}'),
                                                  );
                                                },
                                                itemCount:
                                                    Provider.of<Config>(context)
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
                        Divider(),
                        ListTile(
                          subtitle: Text(selectedEntities.toString().substring(
                              1, selectedEntities.toString().length - 1)),
                          trailing: Icon(Icons.arrow_drop_down),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
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
                                  height: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.4,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        color:
                                            Colors.blueAccent.withOpacity(0.05),
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
                                            child: StatefulBuilder(builder:
                                                (ctx, setStateCheckbox) {
                                          return ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            primary: true,
                                            // shrinkWrap: true,
                                            itemBuilder: (ctx, index) {
                                              return CheckboxListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                ),
                                                value: selectedEntities
                                                    .contains(Provider.of<
                                                                Config>(context)
                                                            .entityType[index]
                                                        ['Name']),
                                                onChanged: (e) {
                                                  if (!e) {
                                                    if (selectedEntities
                                                            .length !=
                                                        1) {
                                                      setState(() {
                                                        setStateCheckbox(() {
                                                          selectedEntities.removeWhere((element) =>
                                                              element ==
                                                              Provider.of<Config>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .entityType[
                                                                  index]['Name']);
                                                        });
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      setStateCheckbox(() {
                                                        selectedEntities.add(
                                                            Provider.of<Config>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .entityType[
                                                                index]['Name']);
                                                      });
                                                    });
                                                  }
                                                },
                                                title: Text(
                                                    '${Provider.of<Config>(context).entityType[index]['Name']}'),
                                              );
                                            },
                                            itemCount:
                                                Provider.of<Config>(context)
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
                          height: 1,
                        ),
                        ListTile(
                          subtitle: Text(selectedClientEntity),
                          trailing: Icon(Icons.arrow_drop_down),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
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
                                  height: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.4,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        color:
                                            Colors.blueAccent.withOpacity(0.05),
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
                                                groupValue:
                                                    selectedClientEntity,
                                                value:
                                                    Provider.of<Config>(context)
                                                            .entityType[index]
                                                        ['Name'],
                                                onChanged: (e) {
                                                  setState(() {
                                                    setStateRadio(() {
                                                      selectedClientEntity = e;
                                                    });
                                                  });
                                                },
                                                title: Text(
                                                    '${Provider.of<Config>(context).entityType[index]['Name']}'),
                                              );
                                            },
                                            itemCount:
                                                Provider.of<Config>(context)
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
                          height: 1,
                        ),
                        ListTile(
                          subtitle: Text(selectedDepartment),
                          trailing: Icon(Icons.arrow_drop_down),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
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
                                  height: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height *
                                      0.4,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        color:
                                            Colors.blueAccent.withOpacity(0.05),
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
                                                value:
                                                    Provider.of<Config>(context)
                                                            .department[index]
                                                        ['Name'],
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
                                            itemCount:
                                                Provider.of<Config>(context)
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
                          height: 1,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Listo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            )),
                        Text('Ya puedes empezar a utilizar la app',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: SvgPicture.asset(
                            'assets/images/done.svg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SmoothPageIndicator(
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blueAccent,
                ),
                controller: onBoardController,
                count: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (onBoardController.page == 0) {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        Provider.of<Config>(
                          context,
                          listen: false,
                        )
                            .signIn(
                          addressField.value.text.trim(),
                          portField.value.text.trim(),
                          secretKeyField.value.text,
                        )
                            .then((value) {
                          setState(() {
                            token = value['token'];
                            uri = value['uri'];
                            isLoading = false;
                          });
                          onBoardController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        }).catchError((error) {
                          setState(() {
                            isLoading = false;
                          });
                          print(error);
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())));
                        });
                      }
                    } else if (onBoardController.page == 1) {
                      downloadMenu();
                    } else if (onBoardController.page == 2) {
                      Provider.of<Config>(context, listen: false)
                          .saveServerPreferences(
                            newSelectedClientEntity: selectedClientEntity,
                            newSelectedDepartment: selectedDepartment,
                            newSelectedEntities: selectedEntities,
                            newSelectedMenu: selectedMenu,
                            newSelectedTicket: selectedTicketType,
                          )
                          .then((value) =>
                              Provider.of<Config>(context, listen: false)
                                  .setConfigured());
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'SIGUIENTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServerSetupForm extends StatelessWidget {
  final formKey;
  final addressController;
  final portController;
  final secretKeyController;

  const ServerSetupForm({
    this.formKey,
    this.addressController,
    this.portController,
    this.secretKeyController,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: addressController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingresa la dirección';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Dirección',
              prefixIcon: Icon(Icons.wifi),
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
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextFormField(
                  controller: portController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingresa el puerto';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Puerto',
                    prefixIcon: Icon(Icons.confirmation_num),
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
                    // focusedBorder: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // errorBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                flex: 3,
                child: TextFormField(
                  controller: secretKeyController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingresa la secret key';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Secret Key',
                    prefixIcon: Icon(Icons.lock_outline),
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

                    // focusedBorder: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // errorBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
