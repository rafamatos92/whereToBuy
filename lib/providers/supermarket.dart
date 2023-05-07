import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/supermarket.dart';
import '../providers/product.dart';

class SupermarketsProvider extends ChangeNotifier {
  static const _keySupermarkets = 'supermarkets';

  List<Supermarket> _supermarkets = [
    Supermarket(name: 'Continente', price: 0.0),
    Supermarket(name: 'Sol Mar', price: 0.0),
    Supermarket(name: 'Recheio', price: 0.0),
    Supermarket(name: 'Casa Cheia', price: 0.0),
    Supermarket(name: 'Pingo Doce', price: 0.0),
    Supermarket(name: 'Poupadinha', price: 0.0),
  ];

  List<Supermarket> get supermarkets => _supermarkets;

  List<Supermarket> getSupermarkets() => _supermarkets;

  Future<void> loadSupermarkets() async {
    final prefs = await SharedPreferences.getInstance();
    final supermarketsJson = prefs.getString(_keySupermarkets);
    if (supermarketsJson != null) {
      final List<dynamic> supermarketsData = json.decode(supermarketsJson);
      final List<Supermarket> supermarkets =
          supermarketsData.map((item) => Supermarket.fromJson(item)).toList();
      _supermarkets = supermarkets;
      notifyListeners();
    }
  }

  void addSupermarket(Supermarket supermarket) async {
    _supermarkets.add(supermarket);
    ProductsProvider().updateProductSupermarkets(_supermarkets);

    final prefs = await SharedPreferences.getInstance();
    final supermarketsJson =
        json.encode(_supermarkets.map((s) => s.toJson()).toList());
    prefs.setString(_keySupermarkets, supermarketsJson);

    ProductsProvider().addSupermarket(supermarket);
    notifyListeners();
  }

  void editSupermarket(int index, Supermarket updatedSupermarket) async {
    _supermarkets[index] = updatedSupermarket;

    final prefs = await SharedPreferences.getInstance();
    final supermarketsJson =
        json.encode(_supermarkets.map((s) => s.toJson()).toList());
    prefs.setString(_keySupermarkets, supermarketsJson);

    notifyListeners();
  }

  void deleteSupermarket(int index) async {
    _supermarkets.removeAt(index);

    final prefs = await SharedPreferences.getInstance();
    final supermarketsJson =
        json.encode(_supermarkets.map((s) => s.toJson()).toList());
  }
}
