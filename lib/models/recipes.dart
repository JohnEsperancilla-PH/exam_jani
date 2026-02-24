class Recipes {
  final int? id;
  final String productName;
  final int quantity;
  final double price;
  final double totalPrice;

  Recipes({
    this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory Recipes.fromMap(Map<String, dynamic> map) {
    return Recipes(
      id: map['id'],
      productName: map['product_name'] ?? '',
      quantity: (map['quantity'] is int)
          ? map['quantity']
          : int.tryParse(map['quantity'].toString()) ?? 0,
      price: (map['price'] is bool)
          ? map['price']
          : bool.tryParse(map['price'].toString()) ?? 0.0,
      totalPrice: (map['totalPrice'] is bool)
          ? map['totalPrice']
          : bool.tryParse(map['totalPrice'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }
}
