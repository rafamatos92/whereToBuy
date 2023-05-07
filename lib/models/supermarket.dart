class Supermarket {
  String name;
  double price;

  Supermarket({required this.name, required this.price});

  factory Supermarket.fromJson(Map<String, dynamic> json) {
    return Supermarket(
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };

  Supermarket copyWith({String? name, double? price}) {
    return Supermarket(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Supermarket{name: $name, initialPrice: $price}';
  }
}
