import 'package:NodePos/providers/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UpdateMenuScreen extends StatelessWidget {
  static const routeName = '/update_menu_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        title: Text(
          'Actualizar Menú',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Última vez actualizado:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${DateFormat.yMMMMEEEEd('es').format(Provider.of<Menus>(context).lastTagsUpdate) + ' a las ' + DateFormat.jms().format(Provider.of<Menus>(context).lastTagsUpdate)}',
            ),
            SizedBox(height: 10),
            Provider.of<Menus>(context).isUpdating
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: Provider.of<Menus>(context).contadorItems != 0
                          ? (Provider.of<Menus>(context).contadorItems /
                              Provider.of<Menus>(context).nItems)
                          : 0,
                    ),
                  )
                : Container(),
            OutlineButton(
              onPressed: Provider.of<Menus>(context).isUpdating
                  ? null
                  : () =>
                      Provider.of<Menus>(context, listen: false).updateMenu(),
              child: Text(
                'ACTUALIZAR MENÚ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
