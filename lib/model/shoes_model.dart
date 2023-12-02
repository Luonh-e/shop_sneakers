class Shoe {
  final int id;
  final String image;
  final String name;
  final String description;
  final double price;
  final String color;

  Shoe({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.color,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      color: json['color'],
    );
  }
}
