class Cart {
  final int id;
  final String image;
  final String name;
  final String color;
  final double price;
  int quantity;

  Cart({
    required this.id,
    required this.image,
    required this.name,
    required this.color,
    required this.price,
    required this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      color: json['color'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
