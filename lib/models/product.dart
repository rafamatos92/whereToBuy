import 'package:shopping/models/supermarket.dart';

class Product {
  String id;
  String title;
  List<Supermarket> supermarkets;
  bool isSelected = false;
  String barcode;

  Product(
      {required this.id,
      required this.title,
      required this.supermarkets,
      this.isSelected = false,
      this.barcode = ''});

  Product copyWith(
      {String? id,
      String? title,
      List<Supermarket>? supermarkets,
      bool? isSelected,
      String? barcode}) {
    return Product(
        id: id ?? this.id,
        title: title ?? this.title,
        supermarkets: supermarkets ?? this.supermarkets,
        isSelected: isSelected ?? this.isSelected,
        barcode: barcode ?? this.barcode);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'],
        supermarkets: List<Supermarket>.from(
            json['supermarkets'].map((x) => Supermarket.fromJson(x))),
        isSelected: json['isSelected'] ?? false,
        barcode: json['barcode'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'supermarkets': supermarkets.map((x) => x.toJson()).toList(),
      'isSelected': isSelected,
      'barcode': barcode
    };
  }

  @override
  String toString() {
    return 'Product{name: $title, supermarkets: $supermarkets, isSelected: $isSelected}';
  }
}
