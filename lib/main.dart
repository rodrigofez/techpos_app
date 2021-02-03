import 'package:NodePos/config_screen.dart';
import 'package:NodePos/expired_token_screen.dart';
import 'package:NodePos/login_screen.dart';
import 'package:NodePos/onboard_screen.dart';
import 'package:NodePos/pos_screen.dart';
import 'package:NodePos/providers/auth.dart';
import 'package:NodePos/providers/connection_state.dart';
import 'package:NodePos/providers/local_user.dart';
import 'package:NodePos/providers/menu.dart';
import 'package:NodePos/providers/tables.dart';
import 'package:NodePos/providers/tickets.dart';
import 'package:NodePos/splash_screen.dart';
import 'package:NodePos/tables_screen.dart';
import 'package:NodePos/ticket_screen.dart';
import 'package:NodePos/select_ticket_screen.dart';
import 'package:NodePos/update_menu_screen..dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('es');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Config(),
        ),
        ChangeNotifierProxyProvider<Config, User>(
          create: (ctx) => User(
            token: null,
            uri: null,
          ),
          update: (ctx, auth, previoTables) => User(
            token: auth.token,
            uri: auth.uri,
          ),
        ),
        ChangeNotifierProxyProvider<Config, CheckConnectionState>(
          create: (ctx) => CheckConnectionState(
            address: null,
            port: null,
          ),
          update: (ctx, auth, previoTables) => CheckConnectionState(
            address: auth.address,
            port: auth.port,
          ),
        ),
        ChangeNotifierProxyProvider<Config, Entities>(
          create: (ctx) => Entities(
            token: null,
            uri: null,
            entitiesName: null,
          ),
          update: (ctx, auth, previoTables) => Entities(
            token: auth.token,
            uri: auth.uri,
            entitiesName: auth.selectedEntities,
          ),
        ),
        ChangeNotifierProxyProvider<Config, Menus>(
          // create: (ctx, ){},
          create: (ctx) => Menus(token: null, uri: null, selectedMenu: null),
          update: (ctx, auth, previoMenus) => Menus(
            token: auth.token,
            uri: auth.uri,
            selectedMenu: auth.selectedMenu,
          ),
        ),
        ChangeNotifierProxyProvider2<Config, User, Tickets>(
          // create: (ctx, ){},
          create: (ctx) => Tickets(token: null, uri: null),
          update: (ctx, auth, userData, previoMenus) => Tickets(
            token: auth.token,
            uri: auth.uri,
            department: auth.selectedDepartment,
            ticketType: auth.selectedTicket,
            userName: userData.userName,
          ),
        ),
      ],
      child: Consumer2<Config, User>(
        builder: (ctx, auth, user, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Sens',
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: auth.isAuth? TablesScreen() : LoginScreen(),
          home: FutureBuilder(
            future: auth.checkConfigured(),
            builder: (ctx, result) {
              if (result.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              print('esta es la respuest: ${result.data}');
              if (result.data == true) {
                auth.loadServerPreferences();
                auth.loadServerSettings();

                return !auth.isAuth
                    ? FutureBuilder(
                        future: auth.checkAuth(),
                        builder: (ctx, authResult) {
                          if (result.connectionState ==
                              ConnectionState.waiting) {
                            return SplashScreen();
                          }
                          if (authResult.data == true) {
                            return LoginScreen();
                          }
                          if (authResult.hasError) {
                            //TODO
                            return ExpiredTokenScreen();
                          } else {
                            return SplashScreen();
                          }
                        },
                      )
                    : user.isLogged
                        ? TablesScreen()
                        : FutureBuilder(
                            future: user.tryAutoLogin(),
                            builder: (ctx, userData) {
                              if (result.connectionState ==
                                  ConnectionState.waiting) {
                                return SplashScreen();
                              } else {
                                print('ESTA ES LA RESPUESTA ${userData.data}');
                                if (userData.data == true) {
                                  return TablesScreen();
                                }
                                if (userData.data == false) {
                                  print('Llega a esta pantalla');

                                  return LoginScreen();
                                } else {
                                  print('Llega a esta pantallazo');

                                  return SplashScreen();
                                }
                              }
                            });
              } else {
                return OnboardScreen();
              }
            },
          ),

          routes: {
            OnboardScreen.routeName: (ctx) => OnboardScreen(),
            TablesScreen.routeName: (ctx) => TablesScreen(),
            PosScreen.routeName: (ctx) => PosScreen(),
            TicketScreen.routeName: (ctx) => TicketScreen(),
            SelectTicketScreen.routeName: (ctx) => SelectTicketScreen(),
            UpdateMenuScreen.routeName: (ctx) => UpdateMenuScreen(),
            ConfigScreen.routeName: (ctx) => ConfigScreen(),
            ExpiredTokenScreen.routeName: (ctx) => ExpiredTokenScreen(),
          },
        ),
      ),
    );
  }
}

// FutureBuilder(
//               future: auth.checkLogin(),
//               builder: (ctx, authResultSnapshot) {
//                 auth.loadServerSettings();
//                 auth.loadServerPreferences();

//                 return authResultSnapshot.connectionState ==
//                         ConnectionState.waiting
//                     ? SplashScreen()
//                     : user.isLogged
//                         ? TablesScreen()
//                         : FutureBuilder(
//                             future: user.tryAutoLogin(),
//                             builder: (ctx, authResultSnapshot) =>
//                                 authResultSnapshot.connectionState ==
//                                         ConnectionState.waiting
//                                     ? SplashScreen()
//                                     : LoginScreen(),
//                           );
//               }),
