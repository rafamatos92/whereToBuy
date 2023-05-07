import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/edit_shopping_list.dart';

import '../models/product.dart';
import '../providers/product.dart';
import '../providers/supermarket.dart';

class CheapestProductsListWidget extends StatefulWidget {
  @override
  _CheapestProductsListWidgetState createState() =>
      _CheapestProductsListWidgetState();
}

class _CheapestProductsListWidgetState
    extends State<CheapestProductsListWidget> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).shopping_list;
    final supermarkets =
        Provider.of<SupermarketsProvider>(context).supermarkets;

    final cheapestProductsBySupermarket = <String, List<Product>>{};

    void update() {
      print(products.toString());
      final cheapestProducts = products.map((product) {
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
          title: product.title,
          supermarkets: [cheapestSupermarket],
        );
      }).toList();

      for (final product in cheapestProducts) {
        final supermarketName = product.supermarkets[0].name;
        cheapestProductsBySupermarket.putIfAbsent(supermarketName, () => []);
        cheapestProductsBySupermarket[supermarketName]!.add(product);
      }
    }

    update();
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditShoppingList()),
          );
        },
        icon: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: cheapestProductsBySupermarket.length,
        itemBuilder: (context, index) {
          final supermarketName =
              cheapestProductsBySupermarket.keys.elementAt(index);
          final products = cheapestProductsBySupermarket[supermarketName]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '$supermarketName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('${product.supermarkets[0].price}€'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
