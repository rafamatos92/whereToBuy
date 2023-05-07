import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/providers/supermarket.dart';

import 'dart:convert';

import '../models/product.dart';
import '../models/supermarket.dart';

class ProductsProvider with ChangeNotifier {
  ProductsProvider() {
    loadShoppingList();
  }

  List<Product> _products = [];
  List<Product> _shopping_list = [];
  List<Product> _cheapestProducts = [];
  Map<String, List<Product>> _cheapestProductsBySupermarket =
      <String, List<Product>>{};

  List<Product> get products => _products;
  List<Product> get shopping_list => _shopping_list;
  List<Product> get cheapestProducts => _cheapestProducts;
  Map<String, List<Product>> get cheapestProductsBySupermarket =>
      _cheapestProductsBySupermarket;

  static const _keyShoppingList = 'shopping_list';
  static const _keyProductsList = 'products_list';

  Future<void> loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingListJson = prefs.getString(_keyShoppingList);
    final productsListJson = prefs.getString(_keyProductsList);

    if (shoppingListJson != null) {
      final List<dynamic> shoppingListData = json.decode(shoppingListJson);
      final List<Product> shoppingList = List.castFrom<dynamic, Product>(
          shoppingListData.map((item) => Product.fromJson(item)).toList());
      _shopping_list = shoppingList;
    }
    if (productsListJson != null) {
      final List<dynamic> productsListData = json.decode(productsListJson);
      final List<Product> productsList = List.castFrom<dynamic, Product>(
          productsListData.map((item) => Product.fromJson(item)).toList());
      _products = productsList;
    }

    notifyListeners();
  }

  Future<void> saveShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingListJson = json.encode(_shopping_list);
    await prefs.setString(_keyShoppingList, shoppingListJson);
    final productsListJson = json.encode(_products);
    await prefs.setString(_keyProductsList, productsListJson);
  }

  void updateProductSupermarkets(List<Supermarket> newSuper) {
    final supermarketsProvider = SupermarketsProvider();
    for (var i = 0; i < _products.length; i++) {
      List<Supermarket> newList = _products[i].supermarkets;
      editProduct(
          i,
          Product(
              title: _products[i].title,
              supermarkets: supermarketsProvider.getSupermarkets()));
    }
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void editProduct(int index, Product product) {
    final novo = [..._products];
    novo[index] = product;
    _products = novo;
    print(_products[index].toString());
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void addToShoppingList(int index) {
    _shopping_list.add(_products[index]);
    saveShoppingList();
    notifyListeners();
  }

  void delFromShoppingList(String title) {
    print(_shopping_list.toString());
    _shopping_list.removeAt(
      _shopping_list.indexWhere((element) => element.title == title),
    );
    _products[_products.indexWhere((element) => element.title == title)]
        .isSelected = false;
    print(_shopping_list
        .indexWhere((element) => element.title == title)
        .toString());
    saveShoppingList();
    notifyListeners();
  }

  void addSupermarket(Supermarket supermarket) async {
    _products.forEach((prod) {
      prod.supermarkets.add(supermarket);
    });

    saveShoppingList();
    notifyListeners();
  }

  void removeProduct(Product product) {
    _shopping_list.remove(product);
    notifyListeners();
  }
}
