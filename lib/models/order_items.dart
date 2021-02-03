class Client{
  String id;
  String name;
  List<int> numbers;
  List<String> address;
  int whatsapp;
  String email;
}

class Table{
  String id;
}

class Product{
  String productName;
  double productPrice;
  String productCategory;
  int barcode;
  List<String> portions;
}

class OrderItem {
  String itemName;
  double itemPrice;
  int quantity;
  String portion;
}

class Order{
  String clientName;
  String clientNumber;
  String tableNumber;
  List<OrderItem> items; 
} 