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

  loadShoppingList() async {
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

    updateCheapestProductSupermaket();

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
      editProduct(Product(
          id: _products[i].id,
          title: _products[i].title,
          barcode: _products[i].barcode,
          supermarkets: supermarketsProvider.supermarkets));
    }
    notifyListeners();
  }

  void addProduct(Product product) {
    _products.add(product);
    updateCheapestProductSupermaket();
    saveShoppingList();
    notifyListeners();
  }

  void editProduct(Product product) {
    final novo = [..._products];
    int index = novo.indexWhere((element) => element.id == product.id);
    novo[index] = product;
    _products = novo;
    updateCheapestProductSupermaket();
    saveShoppingList();
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    updateCheapestProductSupermaket();
    saveShoppingList();
    notifyListeners();
  }

  void addToShoppingList(int index) {
    _shopping_list.add(_products[index]);
    updateCheapestProductSupermaket();
    saveShoppingList();
    notifyListeners();
  }

  void deleteFromShoppingList(String title) {
    _shopping_list.removeAt(
        _shopping_list.indexWhere((element) => element.title == title));
    _products[_products.indexWhere((element) => element.title == title)]
        .isSelected = false;
    updateCheapestProductSupermaket();
    saveShoppingList();
    notifyListeners();
  }

  void addSupermarket(Supermarket supermarket) async {
    _products.forEach((prod) {
      prod.supermarkets.add(supermarket.copyWith());
    });

    saveShoppingList();
    notifyListeners();
  }

  void deleteSupermarket(Supermarket supermarket) async {
    _products.forEach((prod) {
      prod.supermarkets = prod.supermarkets
          .where((element) => element.name != supermarket.name)
          .toList();
    });

    saveShoppingList();
    notifyListeners();
  }

  void updateCheapestProductSupermaket() {
    _cheapestProductsBySupermarket = {};
    if (_products.where((e) => e.isSelected).isNotEmpty) {
      final cheapestProducts = _shopping_list.map((product) {
        dynamic cheapestSupermarket;
        final supermarketList =
            product.supermarkets.where((element) => element.price > 0);
        if (supermarketList.isEmpty) {
          cheapestSupermarket = product.supermarkets.first;
        } else {
          cheapestSupermarket =
              supermarketList.reduce((a, b) => a.price < b.price ? a : b);
        }

        return Product(
          id: product.id,
          title: product.title,
          barcode: product.barcode,
          supermarkets: [cheapestSupermarket],
        );
      }).toList();

      for (final product in cheapestProducts) {
        final supermarketName = product.supermarkets[0].name;
        _cheapestProductsBySupermarket.putIfAbsent(supermarketName, () => []);
        _cheapestProductsBySupermarket[supermarketName]!.add(product);
      }
    } else {
      _shopping_list = [];
      _cheapestProductsBySupermarket = {};
    }
  }
}
