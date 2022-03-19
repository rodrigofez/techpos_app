import 'dart:async';

import 'package:NodePos/providers/menu.dart';
import 'package:NodePos/providers/tickets.dart';
import 'package:NodePos/select_ticket_screen.dart';
import 'package:NodePos/ticket_screen.dart';
import 'package:NodePos/widgets/category_button.dart';
import 'package:NodePos/widgets/item_button.dart';
import 'package:NodePos/widgets/item_counter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:NodePos/widgets/order_dialog.dart';

class PosScreen extends StatelessWidget {
  static const routeName = '/pos_screen';

  @override
  Widget build(BuildContext context) {
    String tableName =
        (ModalRoute.of(context).settings.arguments as Map)['tableName'];
    String entityType =
        (ModalRoute.of(context).settings.arguments as Map)['entityType'];
    final bool isNewTicket =
        (ModalRoute.of(context).settings.arguments as Map)['isNewTicket'];
    final bool entityIsEmpty =
        (ModalRoute.of(context).settings.arguments as Map)['entityIsEmpty'];

    print("ENTITYTYPE OF POS : $entityType");
    AppBar appbar = AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: Row(children: [
        Text(
          'techPOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        Text(
          tableName,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ]),
      elevation: 1,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () => showSearch(
            context: context,
            delegate: Search(),
          ),
        )
      ],
    );

    final deviceHeight =
        MediaQuery.of(context).size.height - appbar.preferredSize.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 242, 247, 1),
      appBar: appbar,
      body: Container(
        child: PosContent(
          deviceHeight,
          deviceWidth,
          tableName,
          entityType,
          isNewTicket,
          entityIsEmpty,
        ),
      ),
    );
  }
}

class PosContent extends StatefulWidget {
  final deviceHeight;
  final deviceWidth;
  final tableName;
  final entityType;
  final bool isNewTicket;
  final bool entityIsEmpty;
  PosContent(this.deviceHeight, this.deviceWidth, this.tableName,
      this.entityType, this.isNewTicket, this.entityIsEmpty);

  @override
  _PosContentState createState() => _PosContentState();
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => Navigator.pop(context),
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget buildResults(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      child: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(result[index]['name']),
            onTap: () {
              return OrderDialog().itemDialog(
                context,
                result[index]['name'],
                _deviceHeight,
                (result[index]['product'] != null
                    ? result[index]['product']['portions']
                    : null),
                result[index]['product']['id'].toString(),
                _formKey,
              );
            },
          );
        },
      ),
    );
  }

  List<dynamic> result = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    List products = Provider.of<Menus>(context).getAllProducts();
    print(products);
    List<dynamic> suggestionList = [];

    query.isEmpty
        ? suggestionList = []
        : suggestionList.addAll(products.where((element) =>
            (element['name'] as String).toLowerCase().contains(query)));
    result = suggestionList;
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(suggestionList[index]['name']),
            onTap: () {
              FocusScope.of(context).unfocus();
              // Navigator.pop(context);
              return OrderDialog().itemDialog(
                context,
                suggestionList[index]['name'],
                _deviceHeight,
                (suggestionList[index]['product'] != null
                    ? suggestionList[index]['product']['portions']
                    : null),
                suggestionList[index]['product']['id'].toString(),
                _formKey,
              );
            });
      },
    );
  }
}

class _PosContentState extends State<PosContent> {
  bool isCollap = false;
  bool isLoading = false;
  String selectedCategory;
  int _itemCount = 1;

  int itemCount() {
    return _itemCount;
  }

  Future<void> submitTicket() async {
    try {
      if (widget.entityIsEmpty) {
        await Provider.of<Tickets>(context, listen: false).createTerminalTicket(
          entityName: widget.tableName,
          entityType: widget.entityType,
        );
      } else {
        if (widget.isNewTicket) {
          Provider.of<Tickets>(context, listen: false).createTicketToAdd();
          // await Provider.of<Tickets>(context, listen: false)
          //     .createTerminalTicket(
          //       entityName: widget.tableName,
          //       entityType: widget.entityType,
          //     )
          //     .then((value) => Provider.of<Tickets>(context, listen: false)
          //             .getLastTicketsOfEntity(
          //           widget.tableName,
          //           widget.entityType,
          //         ));
        } else {
          Provider.of<Tickets>(context, listen: false).addTempOrdersToTicket();
          print(
              'TEMPORDERS TICKET: ${Provider.of<Tickets>(context, listen: false).tempTickets.firstWhere((element) => element.id.toString() == Provider.of<Tickets>(context, listen: false).selectedTicketToModify.id.toString()).tempOrders}');
          // await Provider.of<Tickets>(context, listen: false)
          //     .addOrdersToOpenTicket(
          //       entityName: widget.tableName,
          //       entityType: widget.entityType,
          //     )
          //     .then((value) => Provider.of<Tickets>(context, listen: false)
          //             .getLastTicketsOfEntity(
          //           widget.tableName,
          //           widget.entityType,
          //         ));
        }
      }
    } catch (error) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Error'),
      // ));
      throw error;
    }
  }

  void changeContainer(String categoryLab) {
    setState(() {
      if (categoryLab == selectedCategory) {
        isCollap = !isCollap;
      }
      selectedCategory = categoryLab;
    });
  }

  void modifyCount(int newItemCount) {
    _itemCount = newItemCount;
  }

  @override
  void initState() {
    selectedCategory =
        Provider.of<Menus>(context, listen: false).getCategories()[0];
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   selectedCategory =
  //       Provider.of<Menus>(context, listen: false).getCategories('menu')[0];
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // isLoading = Provider.of<Menus>(context).isLoading;

    final List categories =
        Provider.of<Menus>(context, listen: false).getCategories();

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      width: isCollap
                          ? widget.deviceWidth * 0.22
                          : widget.deviceWidth * 0.36,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 10),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, n) {
                          return CategoryButton(
                            selectedCate: selectedCategory,
                            selectCategory: changeContainer,
                            isCollap: isCollap,
                            buttonLabel: categories[n],
                            catIndex: n,
                            buttonIcon: Icon(Icons.more_horiz),
                          );
                        },
                        itemCount: categories.length,
                      ),
                    ),
                    AnimatedContainer(
                      padding: EdgeInsets.only(right: 14, left: 6),
                      duration: Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      // color: Colors.black26,

                      width: isCollap
                          ? widget.deviceWidth * 0.78
                          : widget.deviceWidth * 0.64,
                      child: selectedCategory != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: (widget.deviceHeight * 0.87) * 0.08,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: ItemCounter(
                                        deviceHeight: widget.deviceHeight,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 6,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          child: GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: Provider.of<Menus>(
                                                    context,
                                                    listen: false)
                                                .getCategoriesProducts(
                                                    selectedCategory)
                                                .length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                            ),
                                            itemBuilder: (ctx, n) {
                                              // print(Provider.of<Menus>(context)
                                              //     .getProductsId(
                                              //         selectedCategory,
                                              //         'Menu')[n]);

                                              return ItemButton(
                                                productId: Provider.of<Menus>(
                                                        context,
                                                        listen: false)
                                                    .getProductsId(
                                                      selectedCategory,
                                                    )[n]
                                                    .toString(),
                                                portions: Provider.of<Menus>(
                                                                    context,
                                                                    listen: false)
                                                                .getProducts(
                                                                    selectedCategory)[
                                                            n]['product'] !=
                                                        null
                                                    ? Provider.of<Menus>(
                                                                context,
                                                                listen: false)
                                                            .getProducts(
                                                                selectedCategory)[n]
                                                        ['product']['portions']
                                                    : null,
                                                buttonLabel: Provider.of<Menus>(
                                                        context,
                                                        listen: false)
                                                    .getCategoriesProducts(
                                                        selectedCategory)[n],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 6,
                                        top: 12,
                                        bottom: 10,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, iter) {
                                              return Column(
                                                children: [
                                                  Dismissible(
                                                    background: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      color: Colors.red,
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      child: Icon(
                                                          Icons.delete_forever),
                                                    ),
                                                    direction: DismissDirection
                                                        .startToEnd,
                                                    onDismissed: (direction) {
                                                      Provider.of<
                                                                  Tickets>(
                                                              context,
                                                              listen: false)
                                                          .removeTempOrder(Provider
                                                                  .of<Tickets>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .tempOrders[iter]['id']);
                                                    },
                                                    key: Key(Provider.of<
                                                            Tickets>(context)
                                                        .tempOrders[iter]['date']
                                                        .toString()),
                                                    child: ListTile(
                                                      onTap: () {
                                                        //TODO: OPEN ORDER DIALOG OF TEMP ORDER
                                                        // OrderDialog()
                                                        //     .itemDialog(
                                                        //   context,
                                                        //   widget.buttonLabel,
                                                        //   _deviceHeight,
                                                        //   widget.portions,
                                                        //   widget.productId,
                                                        //   _formKey,
                                                        // );
                                                        print(Provider.of<
                                                                    Tickets>(
                                                                context,
                                                                listen: false)
                                                            .tempOrders[iter]);
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 6,
                                                      ),
                                                      title: Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                                child: Text(
                                                                  Provider.of<Tickets>(
                                                                          context)
                                                                      .tempOrders[
                                                                          iter][
                                                                          'order']
                                                                      .quantity
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      AutoSizeText(
                                                                        Provider.of<Tickets>(context)
                                                                            .tempOrders[iter]['order']
                                                                            .name,
                                                                        maxFontSize:
                                                                            14,
                                                                        // maxLines:
                                                                        //     2,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          AutoSizeText(
                                                                            Provider.of<Tickets>(context).tempOrders[iter]['order'].portion['name'],
                                                                            maxLines:
                                                                                1,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxFontSize:
                                                                                12,
                                                                            minFontSize:
                                                                                8,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          AutoSizeText(
                                                                            "\$${(Provider.of<Tickets>(context).tempOrders[iter]['order'].portion['price'] as double).toStringAsFixed(2)}",
                                                                            maxLines:
                                                                                1,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxFontSize:
                                                                                12,
                                                                            minFontSize:
                                                                                8,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      ListView
                                                                          .builder(
                                                                        primary:
                                                                            false,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemBuilder:
                                                                            (ctx,
                                                                                iterTags) {
                                                                          return AutoSizeText(
                                                                            '${Provider.of<Tickets>(context).tempOrders[iter]['order'].tags[iterTags]['quantity']} x ${Provider.of<Tickets>(context).tempOrders[iter]['order'].tags[iterTags]['tag']}',
                                                                            maxFontSize:
                                                                                12,
                                                                            minFontSize:
                                                                                8,
                                                                            softWrap:
                                                                                true,
                                                                          );
                                                                          // return Row(
                                                                          //   children: [
                                                                          // // AutoSizeText(
                                                                          // //   '${Provider.of<Tickets>(context).tempOrders[iter]['order'].tags[iterTags]['quantity']}x${Provider.of<Tickets>(context).tempOrders[iter]['order'].tags[iterTags]['tag']}',
                                                                          // //   maxFontSize: 12,
                                                                          // //   minFontSize: 8,
                                                                          // //   softWrap: true,
                                                                          // // ),
                                                                          //     // Spacer(),
                                                                          //     // AutoSizeText(
                                                                          //     //   '${Provider.of<Tickets>(context).tempOrders[iter]['order'].tags[iterTags]['quantity']}x\$${(Provider.of<Tickets>(context).tempOrders[iter]['order'].tags[iterTags]['price'] as double).toStringAsFixed(2)}',
                                                                          //     //   maxFontSize: 12,
                                                                          //     //   softWrap: true,
                                                                          //     //   minFontSize: 8,
                                                                          //     // )
                                                                          //   ],
                                                                          // );
                                                                        },
                                                                        itemCount: Provider.of<Tickets>(context)
                                                                            .tempOrders[iter]['order']
                                                                            .tags
                                                                            .length,
                                                                      ),
                                                                      Divider(),
                                                                      Row(
                                                                          children: [
                                                                            AutoSizeText(
                                                                              "Total",
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.right,
                                                                              maxFontSize: 12,
                                                                              minFontSize: 8,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            AutoSizeText(
                                                                              "\$${Provider.of<Tickets>(context).tempOrders[iter]['total'].toStringAsFixed(2)}",
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.right,
                                                                              maxFontSize: 12,
                                                                              minFontSize: 8,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ],
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 0,
                                                  ),
                                                ],
                                              );
                                            },
                                            itemCount:
                                                Provider.of<Tickets>(context)
                                                    .tempOrders
                                                    .length,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, -1), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                height: 56,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Hero(
                        tag: 'closeButton',
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hoverColor: Colors.red,
                          focusColor: Colors.red,
                          // highlightedBorderColor: Colors.red,
                          highlightColor: Colors.white.withOpacity(0.1),
                          splashColor: Colors.white.withOpacity(0.2),
                          color: Colors.red,
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext ctx) {
                                return WillPopScope(
                                  onWillPop: () {},
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: const Text(
                                      "Creando Ticket",
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

                            if (Provider.of<Tickets>(context, listen: false)
                                    .tempOrdersCount !=
                                0) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext ctx) {
                                  return WillPopScope(
                                    onWillPop: () {},
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title: const Text(
                                        "Creando ticket",
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
                              submitTicket().then((value) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }).catchError((onError) {
                                Navigator.of(context).pop();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Ha ocurrido un error ${onError.toString()}'),
                                ));
                              });
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'CERRAR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Hero(
                        tag: 'secondButton',
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          // hoverColor: Colors.red,
                          // focusColor: Colors.red,
                          // highlightedBorderColor: Colors.red,
                          // highlightColor: Colors.red.withOpacity(0.1),
                          // splashColor: Colors.red.withOpacity(0.2),
                          // color: Colors.red,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(TicketScreen.routeName),
                          child: Text(
                            'Total:  \$${Provider.of<Tickets>(context).ticketTotalBeforeCalculation.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
