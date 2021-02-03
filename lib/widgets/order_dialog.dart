import 'package:NodePos/providers/menu.dart';
import 'package:NodePos/providers/tickets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDialog {
  Future<dynamic> itemDialog(
    BuildContext ctx,
    String productName,
    double deviceHeight,
    List portions,
    String productId,
    GlobalKey<FormState> formKey,
  ) {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.6),
        context: ctx,
        builder: (BuildContext context) {
          var selectedRadio = portions[0]['name'];
          var selectedRadioPrice = portions[0]['price'];

          return Dialog(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)), //this right here
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                List addedTags = [];
                return Container(
                  // height: deviceHeight * 0.7,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              productName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Divider(),
                                  Text(
                                    'Porciones',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ...portions.map((e) {
                                    return Row(
                                      children: [
                                        Radio(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: e['name'],
                                          groupValue: selectedRadio,
                                          onChanged: (el) {
                                            setState(() {
                                              selectedRadio = el;
                                              selectedRadioPrice = e['price'];
                                            });
                                          },
                                        ),
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedRadio = e['name'];
                                                selectedRadioPrice = e['price'];
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  e['name'],
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                ),
                                                Spacer(),
                                                Text(
                                                  '\$${(e['price'] as double).toStringAsFixed(2)}',
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                  SizedBox(height: 10),

                                  //Muestra opciones con respecto a porción seleccionada
                                  FutureBuilder(
                                    builder: (ctx, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> selectedOrderTags =
                                            {};
                                        List tagsCounter = [];
                                        List orderTagsCounter = [];

                                        List<bool> collapsedOrderTagsState = [];

                                        return StatefulBuilder(builder:
                                            (context,
                                                StateSetter setTagsState) {
                                          return ListView.builder(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, iter) {
                                              final noteController =
                                                  TextEditingController();
                                              final priceController =
                                                  TextEditingController();
                                              collapsedOrderTagsState
                                                  .add(false);

                                              int orderTagsMax = Provider
                                                                  .of<Menus>(
                                                                      context)
                                                              .orderTagsMax(
                                                                  productId
                                                                      .toString(),
                                                                  selectedRadio)[
                                                          iter] ==
                                                      0
                                                  ? 9999
                                                  : Provider.of<Menus>(context)
                                                      .orderTagsMax(
                                                          productId.toString(),
                                                          selectedRadio)[iter];
                                              orderTagsCounter.add(0);
                                              tagsCounter.add([]);
                                              addedTags.add([]);
                                              selectedOrderTags.update(
                                                  Provider.of<Menus>(context)
                                                      .returnOrderTagsLabels(
                                                          productId.toString(),
                                                          selectedRadio)[iter]['name']
                                                      .toString(),
                                                  (value) => [],
                                                  ifAbsent: () => []);

                                              return Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      bottom: 6,
                                                    ),
                                                    child: FlatButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      onPressed: () {
                                                        setTagsState(() {
                                                          collapsedOrderTagsState[
                                                                  iter] =
                                                              !collapsedOrderTagsState[
                                                                  iter];
                                                        });
                                                      },
                                                      color: Colors.blueAccent,
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            !collapsedOrderTagsState[
                                                                    iter]
                                                                ? Icons
                                                                    .arrow_drop_down
                                                                : Icons
                                                                    .arrow_drop_up,
                                                            color: Colors.white,
                                                          ),
                                                          AutoSizeText(
                                                            Provider.of<Menus>(
                                                                    context)
                                                                .returnOrderTagsLabels(
                                                                    productId
                                                                        .toString(),
                                                                    selectedRadio)[iter]['name']
                                                                .toString(),
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          AutoSizeText(
                                                            '${orderTagsCounter[iter]}/${Provider.of<Menus>(context).orderTagsMax(productId.toString(), selectedRadio)[iter].toString()}',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  !collapsedOrderTagsState[iter]
                                                      ? Container()
                                                      : Provider.of<Menus>(
                                                                  context)
                                                              .returnNestedOrderTags(
                                                                  Provider.of<Menus>(
                                                                          context)
                                                                      .returnOrderTagsLabels(
                                                                          productId
                                                                              .toString(),
                                                                          selectedRadio)[iter]['name'],
                                                                  productId,
                                                                  selectedRadio)
                                                              .isNotEmpty
                                                          ? GridView.builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                bottom: 8,
                                                                left: 2,
                                                                right: 2,
                                                                top: 2,
                                                              ),
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisSpacing:
                                                                      6,
                                                                  mainAxisSpacing:
                                                                      6,
                                                                  crossAxisCount:
                                                                      3,
                                                                  childAspectRatio:
                                                                      3 / 2),
                                                              itemBuilder:
                                                                  (ctx, iter2) {
                                                                tagsCounter[
                                                                        iter]
                                                                    .add(0);
                                                                addedTags[iter]
                                                                    .add([]);
                                                                return FlatButton(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8)),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  onPressed:
                                                                      () {
                                                                    if (tagsCounter[iter][iter2] <
                                                                            int.parse(Provider.of<Menus>(context, listen: false).tagMaxQuantity(productId, selectedRadio, Provider.of<Menus>(context, listen: false).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]['name'])[
                                                                                iter2]) &&
                                                                        orderTagsCounter[iter] <
                                                                            orderTagsMax) {
                                                                      print(
                                                                          'Se puede añadir');
                                                                      addedTags[
                                                                              iter]
                                                                          [
                                                                          iter2] = {
                                                                        'tagName':
                                                                            Provider.of<Menus>(
                                                                          context,
                                                                          listen:
                                                                              false,
                                                                        ).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]['name'].toString(),
                                                                        'tag': Provider.of<
                                                                            Menus>(
                                                                          context,
                                                                          listen:
                                                                              false,
                                                                        ).returnNestedOrderTags(
                                                                            Provider.of<Menus>(
                                                                              context,
                                                                              listen: false,
                                                                            ).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]['name'],
                                                                            productId,
                                                                            selectedRadio)[iter2]['name'],
                                                                        'price': Provider.of<
                                                                            Menus>(
                                                                          context,
                                                                          listen:
                                                                              false,
                                                                        ).returnNestedOrderTags(
                                                                            Provider.of<Menus>(
                                                                              context,
                                                                              listen: false,
                                                                            ).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]['name'],
                                                                            productId,
                                                                            selectedRadio)[iter2]['price'],
                                                                        'quantity':
                                                                            tagsCounter[iter][iter2] +
                                                                                1,
                                                                      };
                                                                      print(
                                                                          addedTags);
                                                                      setTagsState(
                                                                          () {
                                                                        orderTagsCounter[
                                                                            iter] += 1;
                                                                        tagsCounter[iter]
                                                                            [
                                                                            iter2] += 1;
                                                                      });
                                                                    } else {
                                                                      addedTags[
                                                                              iter]
                                                                          [
                                                                          iter2] = [];
                                                                      setTagsState(
                                                                          () {
                                                                        orderTagsCounter[
                                                                            iter] -= tagsCounter[
                                                                                iter]
                                                                            [
                                                                            iter2];
                                                                        tagsCounter[iter]
                                                                            [
                                                                            iter2] = 0;
                                                                      });
                                                                    }
                                                                  },
                                                                  color: tagsCounter[iter]
                                                                              [
                                                                              iter2] ==
                                                                          0
                                                                      ? Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.05)
                                                                      : Colors
                                                                          .blueAccent
                                                                          .withOpacity(
                                                                              0.8),
                                                                  child: Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            right:
                                                                                2,
                                                                          ),
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child:
                                                                              Text(
                                                                            '${tagsCounter[iter][iter2]}/${Provider.of<Menus>(context, listen: false).tagMaxQuantity(productId, selectedRadio, Provider.of<Menus>(context, listen: false).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]["name"])[iter2].toString()}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: tagsCounter[iter][iter2] == 0 ? Colors.black : Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        AutoSizeText(
                                                                          Provider.of<Menus>(context).returnNestedOrderTags(
                                                                              Provider.of<Menus>(context).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]['name'],
                                                                              productId,
                                                                              selectedRadio)[iter2]['name'],
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          minFontSize:
                                                                              6,
                                                                          maxFontSize:
                                                                              16,
                                                                          wrapWords:
                                                                              false,
                                                                          style:
                                                                              TextStyle(
                                                                            color: tagsCounter[iter][iter2] == 0
                                                                                ? Colors.black
                                                                                : Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        )
                                                                      ]),
                                                                );
                                                              },
                                                              itemCount: Provider
                                                                      .of<Menus>(
                                                                          context)
                                                                  .returnNestedOrderTags(
                                                                      Provider.of<Menus>(context).returnOrderTagsLabels(
                                                                          productId
                                                                              .toString(),
                                                                          selectedRadio)[iter]['name'],
                                                                      productId,
                                                                      selectedRadio)
                                                                  .length,
                                                            )
                                                          : Column(
                                                              children: [
                                                                Container(
                                                                  // height: 100,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8),
                                                                  child: Column(
                                                                    children: [
                                                                      TextField(
                                                                        decoration:
                                                                            InputDecoration(
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.black12,
                                                                            ),
                                                                            borderRadius:
                                                                                const BorderRadius.all(
                                                                              const Radius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.blueAccent,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                const BorderRadius.all(
                                                                              const Radius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          errorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.red,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                const BorderRadius.all(
                                                                              const Radius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Colors.red,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                const BorderRadius.all(
                                                                              const Radius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.symmetric(horizontal: 8),
                                                                          filled:
                                                                              false,

                                                                          hintText:
                                                                              'Escribe la nota',

                                                                          // labelText:
                                                                          //     'Nota',
                                                                          // contentPadding:
                                                                          //     EdgeInsets.symmetric(
                                                                          //   horizontal:
                                                                          //       16,
                                                                          //   vertical:
                                                                          //       10,
                                                                          // ),
                                                                        ),
                                                                        controller:
                                                                            noteController,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                TextField(
                                                                              keyboardType: TextInputType.number,
                                                                              decoration: InputDecoration(
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.black12,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    const Radius.circular(8.0),
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.blueAccent,
                                                                                    width: 2.0,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    const Radius.circular(8.0),
                                                                                  ),
                                                                                ),
                                                                                errorBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.red,
                                                                                    width: 2.0,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    const Radius.circular(8.0),
                                                                                  ),
                                                                                ),
                                                                                focusedErrorBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                    color: Colors.red,
                                                                                    width: 2.0,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    const Radius.circular(8.0),
                                                                                  ),
                                                                                ),
                                                                                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                                                                filled: false,

                                                                                hintText: '0.00',

                                                                                // labelText: 'Precio',
                                                                                // contentPadding:
                                                                                //     EdgeInsets.symmetric(
                                                                                //   horizontal:
                                                                                //       16,
                                                                                //   vertical:
                                                                                //       10,
                                                                                // ),
                                                                              ),
                                                                              controller: priceController,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Expanded(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                OutlineButton(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                              onPressed: () {
                                                                                if (noteController.value.toString().isEmpty) {
                                                                                  return null;
                                                                                } else {
                                                                                  setTagsState(() {
                                                                                    addedTags[iter].add({
                                                                                      'tagName': Provider.of<Menus>(
                                                                                        context,
                                                                                        listen: false,
                                                                                      ).returnOrderTagsLabels(productId.toString(), selectedRadio)[iter]['name'].toString(),
                                                                                      'tag': noteController.value.text,
                                                                                      'price': priceController.value.text.isNotEmpty ? double.parse(priceController.value.text) : 0.00,
                                                                                      'quantity': 1,
                                                                                    });
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Text('Añadir'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                ListView
                                                                    .builder(
                                                                  primary:
                                                                      false,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (ctx,
                                                                          index) {
                                                                    return ListTile(
                                                                      trailing:
                                                                          IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        onPressed:
                                                                            () =>
                                                                                setTagsState(() {
                                                                          (addedTags[iter] as List)
                                                                              .removeAt(index);
                                                                        }),
                                                                      ),
                                                                      key: Key(addedTags[iter][index]['price']
                                                                              .toString() +
                                                                          addedTags[iter][index]
                                                                              [
                                                                              'tag'] +
                                                                          index
                                                                              .toString()),
                                                                      subtitle:
                                                                          Text(
                                                                              '\$${(addedTags[iter][index]['price'] as double).toStringAsFixed(2)}'),
                                                                      title: Text(addedTags[iter][index]
                                                                              [
                                                                              'tag']
                                                                          .toString()),
                                                                    );
                                                                  },
                                                                  itemCount:
                                                                      addedTags[
                                                                              iter]
                                                                          .length,
                                                                )
                                                              ],
                                                            ),
                                                ],
                                              );
                                            },
                                            itemCount:
                                                Provider.of<Menus>(context)
                                                    .returnOrderTagsLabels(
                                                        productId.toString(),
                                                        selectedRadio)
                                                    .length,
                                          );
                                        });
                                      } else {
                                        return Container(
                                          child: Text('Hay un error'),
                                        );
                                      }
                                    },
                                    future: Provider.of<Menus>(context,
                                            listen: false)
                                        .getOrderTags(),
                                  ),
                                  selectedRadio == 'Porción 2'
                                      ? Text('Hola')
                                      : Container(),

                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          elevation: 0,
                          onPressed: () {
                            List productTags = addedTags
                                .expand((element) => element)
                                .toList()
                                .where((element) => element is Map)
                                .toList();
                            // print(productTags);
                            // print(Provider.of<Tickets>(context,
                            //         listen: false)
                            //     .orderCounter);
                            // print(productId);
                            Provider.of<Tickets>(context, listen: false)
                                .addTempOrder(
                              int.parse(productId),
                              productName,
                              Provider.of<Tickets>(context, listen: false)
                                  .orderCounter,
                              {
                                'name': selectedRadio,
                                'price': selectedRadioPrice,
                              },
                              productTags,
                              Provider.of<Tickets>(context, listen: false)
                                  .tempOrdersCount,
                            );
                            Provider.of<Tickets>(context, listen: false)
                                .openNewTempOrder();
                            Navigator.of(context).pop();
                            Provider.of<Tickets>(context, listen: false)
                                .setOrderCounter(1);
                            Provider.of<Tickets>(context, listen: false)
                                .notifyListeners();

                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                            }
                          },
                          child: Text(
                            "CONFIRMAR",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                );
              },
            ),
          );
        });
  }
}
