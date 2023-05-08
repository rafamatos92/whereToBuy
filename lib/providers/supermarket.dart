import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/supermarket.dart';

class SupermarketsProvider extends ChangeNotifier {
  static const _keySupermarkets = 'supermarkets';

  List<Supermarket> _supermarkets = [
    Supermarket(name: 'Continente', price: 0.0),
    Supermarket(name: 'Sol Mar', price: 0.0)
  ];

  List<Supermarket> get supermarkets => _supermarkets;

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

    saveStatus();
    notifyListeners();
  }

  void editSupermarket(int index, Supermarket updatedSupermarket) async {
    _supermarkets[index] = updatedSupermarket;

    saveStatus();
    notifyListeners();
  }

  void deleteSupermarket(int index) async {
    _supermarkets.removeAt(index);

    saveStatus();
    notifyListeners();
  }

  void saveStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final supermarketsJson =
        json.encode(_supermarkets.map((s) => s.toJson()).toList());
    prefs.setString(_keySupermarkets, supermarketsJson);
  }
}
