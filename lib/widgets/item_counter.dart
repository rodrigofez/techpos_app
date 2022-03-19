import 'dart:ui';

import 'package:NodePos/providers/tickets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({
    Key key,
    @required this.deviceHeight,
  }) : super(key: key);

  final double deviceHeight;

  @override
  _ItemCounterState createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  final counterController = TextEditingController();
  int counter = 1;

  saveCounter() {
    if (counterController.value.text == '') {
      counter = 1;
      Provider.of<Tickets>(context, listen: false).setOrderCounter(counter);
    } else {
      counter = int.parse(counterController.value.text);
      Provider.of<Tickets>(context, listen: false).setOrderCounter(counter);
    }

    // print('holaaa $counter');
  }

  @override
  void initState() {
    counterController.text = '1';
    counterController.addListener(saveCounter);
    // counterController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    counterController.dispose();
    super.dispose();
  }

  void addItem() {
    setState(() {
      counter++;
      Provider.of<Tickets>(context, listen: false).setOrderCounter(counter);
      counterController.text = counter.toString();
    });
  }

  void removeItem() {
    if (counter > 1) {
      setState(() {
        counter--;
        Provider.of<Tickets>(context, listen: false).setOrderCounter(counter);
        counterController.text = counter.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // counterController.text =
    //     Provider.of<Tickets>(context, listen: false).orderCounter.toString();
    return Row(
      children: [
        Container(
          height: (widget.deviceHeight * 0.5) * 0.14,
          width: (widget.deviceHeight * 0.5) * 0.14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: FlatButton(
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: removeItem,
            child: Center(
              child: Icon(
                Icons.remove_circle_rounded,
              ),
            ),
          ),
        ),
        // TextField(),
        Expanded(
          child: Container(
            // padding: EdgeInsets.only(top:3),
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextField(
              onSubmitted: (txt) {
                if (txt.length == 0 || txt == '0') {
                  counterController.text = '1';
                }
              },
              onChanged: (quantity) {
                print(quantity);
              },
              controller: counterController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              // maxLength: 3,
              maxLines: 1,
              
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            height: (widget.deviceHeight * 0.5) * 0.14,
            width: (widget.deviceHeight * 0.5) * 0.14,
          ),
        ),
        Container(
          height: (widget.deviceHeight * 0.5) * 0.14,
          width: (widget.deviceHeight * 0.5) * 0.14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: FlatButton(
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: addItem,
            child: Center(
              child: Icon(
                Icons.add_circle_rounded,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
