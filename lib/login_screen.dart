import 'package:NodePos/providers/auth.dart';
import 'package:NodePos/providers/local_user.dart';
import 'package:NodePos/tables_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isLogin = false;

  void showConfigDialog(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return Container(
            height: 100,
            child: ListView(
              children: [
                Dismissible(
                  background: Container(color: Colors.red),
                  key: Key(Provider.of<Config>(context).uri),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: const Text("Confirmación"),
                          content:
                              const Text("¿Quieres eliminar todos los datos?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("ELIMINAR")),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCELAR"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    Navigator.pop(context);
                    Future.delayed(Duration(milliseconds: 300)).then((value) =>
                        Provider.of<Config>(context, listen: false)
                            .clearLocalData());
                  },
                  child: ListTile(
                    leading: Icon(Icons.wifi_tethering),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(Provider.of<Config>(context).address,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }

  // void showConfigDialog(BuildContext ctx) {
  //   showDialog(
  //       barrierColor: Colors.black.withOpacity(0.6),
  //       context: ctx,
  //       builder: (BuildContext context) {
  //         bool isLoad = false;
  //         bool thereIsError = false;
  //         String errorMessage;
  //         return Dialog(
  //           elevation: 2,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(6.0)), //this right here
  //           child: StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState2) {
  //               final addressField = TextEditingController();
  //               final portField = TextEditingController();
  //               final secretKeyField = TextEditingController();

  //               if (Provider.of<Config>(context).isAuth) {
  //                 addressField.text =
  //                     Provider.of<Config>(context, listen: false).address;
  //                 portField.text =
  //                     Provider.of<Config>(context, listen: false).port;
  //                 secretKeyField.text =
  //                     Provider.of<Config>(context, listen: false).secretKey;
  //               }

  //               Future<void> authenticate(
  //                 String address,
  //                 String port,
  //                 String secretKey,
  //               ) async {
  //                 setState2(() => isLoad = true);

  //                 try {
  //                   await Provider.of<Config>(context, listen: false)
  //                       .signIn(address, port, secretKey);
  //                   setState2(() => isLoad = false);
  //                   Navigator.of(context).pop();
  //                 } catch (error) {
  //                   setState2(() => isLoad = false);
  //                   thereIsError = true;
  //                   errorMessage = error.toString();

  //                   print('Hola:  ${error.toString()}');

  //                   throw error;
  //                 }
  //               }

  //               return Stack(
  //                 children: [
  //                   SingleChildScrollView(
  //                     child: Container(
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Container(
  //                             margin: EdgeInsets.symmetric(
  //                               horizontal: 20,
  //                               vertical: 20,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: Colors.black12.withOpacity(0.05),
  //                               borderRadius: BorderRadius.circular(6),
  //                             ),
  //                             child: TextField(
  //                               controller: addressField,
  //                               textAlign: TextAlign.center,
  //                               decoration: InputDecoration(
  //                                 hintText: 'Dirección',
  //                                 border: InputBorder.none,
  //                                 focusedBorder: InputBorder.none,
  //                                 enabledBorder: InputBorder.none,
  //                                 errorBorder: InputBorder.none,
  //                                 disabledBorder: InputBorder.none,
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             margin: EdgeInsets.only(
  //                               bottom: 20,
  //                               left: 20,
  //                               right: 20,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: Colors.black12.withOpacity(0.05),
  //                               borderRadius: BorderRadius.circular(6),
  //                             ),
  //                             child: TextField(
  //                               controller: portField,
  //                               keyboardType: TextInputType.number,
  //                               textAlign: TextAlign.center,
  //                               decoration: InputDecoration(
  //                                 hintText: 'Puerto',
  //                                 border: InputBorder.none,
  //                                 focusedBorder: InputBorder.none,
  //                                 enabledBorder: InputBorder.none,
  //                                 errorBorder: InputBorder.none,
  //                                 disabledBorder: InputBorder.none,
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             margin: EdgeInsets.only(
  //                               bottom: 20,
  //                               left: 20,
  //                               right: 20,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: Colors.black12.withOpacity(0.05),
  //                               borderRadius: BorderRadius.circular(6),
  //                             ),
  //                             child: TextField(
  //                               obscureText: true,
  //                               controller: secretKeyField,
  //                               textAlign: TextAlign.center,
  //                               decoration: InputDecoration(
  //                                 hintText: 'Secret Key',
  //                                 border: InputBorder.none,
  //                                 focusedBorder: InputBorder.none,
  //                                 enabledBorder: InputBorder.none,
  //                                 errorBorder: InputBorder.none,
  //                                 disabledBorder: InputBorder.none,
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                               bottom: 10,
  //                             ),
  //                             child: OutlineButton(
  //                               highlightElevation: 0,
  //                               color: Theme.of(context).primaryColor,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(6)),
  //                               ),
  //                               onPressed: () {
  //                                 authenticate(
  //                                   addressField.value.text,
  //                                   portField.value.text,
  //                                   secretKeyField.value.text,
  //                                 );
  //                               },
  //                               child: Text(
  //                                 'CONFIRMAR',
  //                                 style: TextStyle(
  //                                   color: Colors.blueAccent,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           if (isLoad)
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 20),
  //                               child: CircularProgressIndicator(),
  //                             ),
  //                           if (thereIsError)
  //                             Padding(
  //                               padding: const EdgeInsets.only(
  //                                   bottom: 20, left: 20, right: 20),
  //                               child: Text(
  //                                 errorMessage,
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                             )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         );
  //       }).then((value) => print(value));
  // }

  final passController = TextEditingController();

  void loginUp(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed(TablesScreen.routeName);
  }

  // Future<void> signIn(BuildContext ctx, Function errorAlert) async {
  //   await Provider.of<User>(context, listen: false)
  //       .signIn(passController.value.text);
  //   if (passController.value.text == '1234') {
  //     Navigator.of(ctx).popAndPushNamed(TablesScreen.routeName);
  //   } else {
  //     errorAlert();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('loginscreen');
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      height: 60,
                      // width: 60,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.03),
                      border: Border.all(width: 1, color: Colors.black12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      controller: passController,
                      obscureText: true,
                      // textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: (isLogin
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(),
                              )
                            : null),
                        // icon: Icon(Icons.lock_outline),
                        prefixIcon: Icon(Icons.lock_outline),

                        labelText: 'PIN',
                        hintText: 'Ingresa el PIN',
                        filled: true,

                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Container(
                      width: double.infinity,
                      child: OutlineButton(
                        // borderSide: BorderSide(color: Colors.blueAccent),
                        color: Theme.of(context).primaryColor,
                        highlightColor: Colors.blueAccent.withOpacity(0.2),
                        splashColor: Colors.blueAccent.withOpacity(0.8),

                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(6)),
                        // ),
                        onPressed: () {
                          print(passController.value.text.toString());
                          if (isLogin == false) {
                            print('Luego');

                            setState(() {
                              isLogin = true;
                            });
                            Provider.of<User>(context, listen: false)
                                .signInLocalUser(
                                    passController.value.text.toString())
                                .then((value) {
                              setState(() {
                                isLogin = false;
                              });
                              
                              Scaffold.of(context).removeCurrentSnackBar();
                              if (!value['isSuccessful']) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(value['error']),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ));
                              }
                              print('luego de provider');
                            });
                          }

                          // signIn(context, showErrorLogin);
                        },
                        child: Text(
                          'INGRESAR',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Provider.of<Config>(context).isAuth
                      //         ? Colors.green
                      //         : Colors.redAccent,
                      //     borderRadius: BorderRadius.circular(2),
                      //   ),
                      //   margin: EdgeInsets.only(
                      //     left: 30,
                      //     right: 5,
                      //   ),
                      //   width: 10,
                      //   height: 10,
                      // ),
                      // Provider.of<Config>(context).isAuth
                      //     ? Text(
                      //         'CONECTADO',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.green,
                      //         ),
                      //       )
                      //     : Text(
                      //         'DESCONECTADO',
                      //         style: TextStyle(
                      //           color: Colors.redAccent,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: OutlineButton(
                          highlightElevation: 0,
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          onPressed: () => showConfigDialog(context),
                          child: Text(
                            'AJUSTES',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
