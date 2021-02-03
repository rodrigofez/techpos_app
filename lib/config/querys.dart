class SambaQuery {
  static const String refreshNotification =
      '''mutation{postTicketRefreshMessage(id:0){id}}''';

  String userLogIn(pin) {
    final String query =
        ''' {name:getUser(pin:"$pin"){name,userRole{name, isAdmin},}} ''';
    return query;
  }

  String entity(entityName) {
    final String mesasQuery = '''{getEntities(type:"$entityName"){
           name,
           customData {
      name
      value
    }
           id,
           type,
           states{
            stateName 
            state
            }
           }
          }''';
    return mesasQuery;
  }

  String menu(menuName) {
    final String menuQuery = '''  {getMenu(name: "$menuName") {
    categories {
      name
      menuItems {
        name
        id
        product {
          id
          portions {
            name
            price
          }
        }
      }
    }
  }
}
  ''';
    return menuQuery;
  }

  String checkEntityState(entityType, entityName) {
    final query = '''{getEntity(type:"$entityType", name:"$entityName") {
  id
  states {
    stateName
    state
  }
}}''';
    return query;
  }

  String registerTerminal({department, user, ticketType}) {
    final query = '''mutation{
  terminalId: registerTerminal(terminal: "Server", department: "$department", user: "$user", ticketType: "$ticketType")
}''';
    return query;
  }

  String createTerminalTicket(
    terminalId,
  ) {
    final String createTerminalTick = '''mutation{
  createTerminalTicket(terminalId: "$terminalId") {
    id
  }
}''';
    return createTerminalTick;
  }

  String loadTerminalTicket({terminalId, ticketId}) {
    final String loadTerminalTick =
        '''mutation{ticket:loadTerminalTicket(terminalId:"$terminalId" ,ticketId:"$ticketId"){id}}''';
    return loadTerminalTick;
  }

  String addOrderToTerminalTicket({
    terminalId,
    productName,
    portionName,
    orderTags,
    orderQuantity,
  }) {
    final String addOrderToTerminalTicket = '''mutation{
  ticket: addOrderToTerminalTicket(terminalId: "$terminalId", productName: "$productName", portion: "portionName", orderTags: "", quantity: $orderQuantity, enforceQuantity: true) {
    orders {
      uid
    }
  }
}''';
    return addOrderToTerminalTicket;
  }

  String setEntityOfTerminalTicket({
    type,
    name,
    terminalId,
  }) {
    final String addOrderToTerminalTicket = '''mutation{
  ticket: changeEntityOfTerminalTicket(terminalId: "$terminalId", type: "$type", name: "$name") {
    id
  }
}''';
    return addOrderToTerminalTicket;
  }

  String closeTermianlTicket(terminalId) {
    final String closeTerminalId = '''mutation{
  ticket: closeTerminalTicket(terminalId: "$terminalId") {
    id
  }
}''';
    return closeTerminalId;
  }

  String unregisterTerminal(terminalId) {
    final String closeTerminalId =
        '''mutation{unregisterTerminal(terminalId:"$terminalId")}''';
    return closeTerminalId;
  }

  String updateOrderTagsOfTerminalTicket({terminalId, orderUid, orderTags}) {
    final String updateOrderTags = '''mutation {
  ticket: updateOrderOfTerminalTicket(terminalId: "$terminalId", orderUid: "$orderUid", orderTags: [${orderTags.toString()}]) {
    uid
  }
}
''';
    return updateOrderTags;
  }

  String orderTagsGroups({String productId, String portion}) {
    final String orderTagQuery = '''{
  product: getOrderTagGroups(productId: ${int.parse(productId)}, portion: "$portion", terminal: "Server") {
    id
    name
    color
    max
    min
    hidden
    tags {
      id
      name
      color
      description
      price
      maxQuantity
      rate
    }
  }
}''';

    return orderTagQuery;
  }

  String getLastTickets({entityType, entityName}) {
    final query =
        '''{getTickets(entities:{entityType:"$entityType", name:"$entityName"} isClosed: false) {
    id
  uid
  type
  number
  note
  date
  entities {
    id
    name
    type
    typeId
  }
  orders {
    id
    uid
    name
    productId
    quantity
    portion
    price
    priceTag
    date
    lastUpdateDate
    number
    user
    tags {
      tagName
      tag
      price
      quantity
      rate
      userId
    }
    calculatePrice
    states {
      stateName
      state
      stateValue
    }
  }
  tags {
    tagName
    tag
  }
  
  states {
    stateName
    state
  }
  totalAmount
  remainingAmount
  calculations {
    name
    calculationAmount
  }
}}''';
    return query;
  }

  String updateOrderStatus() {
    final query = ''' ''';
  }

  String getTicketInfo({ticketId}) {
    final query = ''' {getTicket(id:$ticketId){
  
  id
  uid
  type
  number
  note
  date
  entities {
    id
  }
  orders {
    id
    uid
    name
    productId
    quantity
    portion
    price
    priceTag
    date
    lastUpdateDate
    number
    user
    calculatePrice
    locked
    disablePortionSelection
    tags {
      tagName
      tag
      price
      quantity
      rate
      userId
    }
    states {
      stateName
      state
      stateValue
    }
  }
  tags {
    tagName
    tag
  }
  states {
    stateName
    state
  }
  totalAmount
  remainingAmount
  calculations {
    name
    calculationAmount
  }
}}''';
    return query;
  }

  String executeAutomationCommandForOrder({
    terminalId,
    orderUid,
    automationName,
    automationValue,
  }) {
    final query = ''' mutation{
  executeAutomationCommandForTerminalTicket(terminalId: "$terminalId", orderUid: "$orderUid", name: "$automationName", value: "$automationValue") {
    id
    uid
    orders {
      id
      uid
      name
      states {
        stateName
        state
        stateValue
      }
    }

  }
}
''';
    return query;
  }

  String executeAutomationCommandForTicket({
    terminalId,
    automationName,
    automationValue,
  }) {
    final query = ''' mutation{
  executeAutomationCommandForTerminalTicket(terminalId: "$terminalId", name: "$automationName", value: "$automationValue") {
    id
  }
}
''';
    return query;
  }
}
