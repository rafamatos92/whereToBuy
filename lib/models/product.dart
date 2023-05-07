import 'package:shopping/models/supermarket.dart';

class Product {
  String title;
  List<Supermarket> supermarkets;
  bool isSelected = false;

  Product(
      {required this.title,
      required this.supermarkets,
      this.isSelected = false});

  Product copyWith(
      {String? title, List<Supermarket>? supermarkets, bool? isSelected}) {
    return Product(
        title: title ?? this.title,
        supermarkets: supermarkets ?? this.supermarkets,
        isSelected: isSelected ?? this.isSelected);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      supermarkets: List<Supermarket>.from(
          json['supermarkets'].map((x) => Supermarket.fromJson(x))),
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
