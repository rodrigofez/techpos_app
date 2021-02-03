import 'package:NodePos/providers/menu.dart';
import 'package:NodePos/providers/tickets.dart';
import 'package:NodePos/widgets/order_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ItemButton extends StatefulWidget {
  final String buttonLabel;
  final portions;
  final productId;
  ItemButton({
    @required this.productId,
    @required this.buttonLabel,
    this.portions,
  });

  @override
  _ItemButtonState createState() => _ItemButtonState();
}

class _ItemButtonState extends State<ItemButton> {


  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;

    return FlatButton(
      onPressed: () {
        if (widget.portions != null) {
          OrderDialog().itemDialog(
            context,
            widget.buttonLabel,
            _deviceHeight,
            widget.portions,
            widget.productId,
            _formKey,
          );
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.blueAccent,
      padding: EdgeInsets.all(10),
      child: Center(
        child: AutoSizeText(
          widget.buttonLabel,
          textAlign: TextAlign.center,
          minFontSize: 10,
          maxFontSize: 50,

          wrapWords: true,
          // overflow: TextOverflow.fade,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(4),
      //   color: Color.fromRGBO(0, 128, 0, 1),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       spreadRadius: 0,
      //       blurRadius: 2,
      //       offset: Offset(0, 3), // changes position of shadow
      //     ),
      //   ],
      // ),
    );
  }
}
