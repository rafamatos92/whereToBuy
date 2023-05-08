import 'package:shopping/models/supermarket.dart';

class Product {
  String id;
  String title;
  List<Supermarket> supermarkets;
  bool isSelected = false;

  Product(
      {required this.id,
      required this.title,
      required this.supermarkets,
      this.isSelected = false});

  Product copyWith(
      {String? id,
      String? title,
      List<Supermarket>? supermarkets,
      bool? isSelected}) {
    return Product(
        id: id ?? this.id,
        title: title ?? this.title,
        supermarkets: supermarkets ?? this.supermarkets,
        isSelected: isSelected ?? this.isSelected);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      supermarkets: List<Supermarket>.from(
          json['supermarkets'].map((x) => Supermarket.fromJson(x))),
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'supermarkets': supermarkets.map((x) => x.toJson()).toList(),
      'isSelected': isSelected,
    };
  }

  @override
  String toString() {
    return 'Product{name: $title, supermarkets: $supermarkets, isSelected: $isSelected}';
  }
}
