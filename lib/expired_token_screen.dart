import 'package:NodePos/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ExpiredTokenScreen extends StatelessWidget {
  static const routeName = '/expired_token_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpiredTokenContent(),
    );
  }
}

class ExpiredTokenContent extends StatefulWidget {
  @override
  _ExpiredTokenContentState createState() => _ExpiredTokenContentState();
}

class _ExpiredTokenContentState extends State<ExpiredTokenContent> {
      bool isRefreshingToken = false;


  @override
  Widget build(BuildContext context) {
    print(isRefreshingToken);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
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
          Center(
            child: Text(
              'NO SE HA PODIDO AUTENTIFICAR',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              'VERIFICA EL ESTADO DE LA CONEXIÓN',
              style: TextStyle(
                color: Colors.grey,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          (!isRefreshingToken
              ? FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blueAccent,
                  onPressed: () {
                    setState(() {
                      isRefreshingToken = true;
                    });
                    Provider.of<Config>(context, listen: false)
                        .refreshToken()
                        .then((value) => setState(() {
                              isRefreshingToken = false;
                            }))
                        .catchError((onError) {
                      setState(() {
                        isRefreshingToken = false;
                      });
                      Scaffold.of(context).removeCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(onError.toString())));
                    });
                  },
                  child: Text(
                    'REINTENTAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : CircularProgressIndicator()),
          Spacer(),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  right: 20,
                ),
                child: OutlineButton(
                  highlightElevation: 0,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return Container(
                            height: 100,
                            child: ListView(
                              children: [
                                Dismissible(
                                  background: Container(color: Colors.red),
                                  key: Key(Provider.of<Config>(context).uri),
                                  direction: DismissDirection.startToEnd,
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          title: const Text("Confirmación"),
                                          content: const Text(
                                              "¿Quieres eliminar todos los datos?"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text("ELIMINAR")),
                                            FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("CANCELAR"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDismissed: (direction) {
                                    Navigator.pop(context);
                                    Future.delayed(Duration(milliseconds: 300))
                                        .then((value) => Provider.of<Config>(
                                                context,
                                                listen: false)
                                            .clearLocalData());
                                  },
                                  child: ListTile(
                                    leading: Icon(Icons.wifi_tethering),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    title: Text(
                                        Provider.of<Config>(context).address,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Text(
                    'AJUSTES',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
