import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/supermarket.dart';
import 'package:shopping/providers/supermarket.dart';

import '../providers/product.dart';

String generateUniqueId() {
  var now = DateTime.now().microsecondsSinceEpoch;
  var rand = Random().nextInt(1000000);
  return '$now$rand';
}

class ProductsListWidget extends StatefulWidget {
  @override
  _ProductsListWidgetState createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

    final filteredProducts = products
        .where((product) =>
            product.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (
                BuildContext context,
              ) {
                String newName = '';
                Product newProduct = Product(
                  id: generateUniqueId(),
                  title: '',
                  supermarkets: SupermarketsProvider().supermarkets,
                );

                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          newName = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter new name',
                        ),
                      ),
                      Container(
                        height: 300,
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: SupermarketsProvider().supermarkets.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                newProduct.supermarkets[index].name,
                              ),
                              trailing: SizedBox(
                                width: 100.0,
                                child: TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    hintText: '0.00',
                                  ),
                                  onChanged: (value) {
                                    double price =
                                        double.tryParse(value) ?? 0.0;
                                    newProduct.supermarkets[index].price =
                                        price;
                                  },
                                  controller: TextEditingController(
                                      text: newProduct.supermarkets[index].price
                                          .toString()),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                    IconButton(
                      onPressed: () {
                        newProduct.title = newName;
                        Navigator.of(context).pop();
                        Provider.of<ProductsProvider>(context, listen: false)
                            .addProduct(newProduct);
                      },
                      icon: const Icon(Icons.save),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.add)),
      body: Column(
        children: [
          // Search bar widget
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('${product.supermarkets.length} lojas'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          final TextEditingController _controller =
                              TextEditingController(text: product.title);

                          showDialog(
                            context: context,
                            builder: (
                              BuildContext context,
                            ) {
                              String newName = product.title;
                              List<Supermarket> new_supermarkets =
                                  product.supermarkets;

                              return SingleChildScrollView(
                                child: AlertDialog(
                                  title: Text('Editar ${product.title}'),
                                  content: Column(
                                    children: [
                                      TextField(
                                        controller: _controller,
                                        onChanged: (value) {
                                          newName = value;
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Introduzir novo nome',
                                        ),
                                      ),
                                      Container(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              product.supermarkets.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title: Text(
                                                product
                                                    .supermarkets[index].name,
                                              ),
                                              trailing: SizedBox(
                                                width: 100.0,
                                                child: TextField(
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          decimal: true),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: '0.00',
                                                  ),
                                                  onChanged: (value) {
                                                    double price =
                                                        double.tryParse(
                                                                value) ??
                                                            0.0;
                                                    new_supermarkets[index]
                                                        .price = price;
                                                  },
                                                  controller:
                                                      TextEditingController(
                                                          text: product
                                                              .supermarkets[
                                                                  index]
                                                              .price
                                                              .toString()),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.cancel),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        product.title = newName;
                                        Navigator.of(context).pop();
                                        Provider.of<ProductsProvider>(context,
                                                listen: false)
                                            .editProduct(
                                          Product(
                                              id: product.id,
                                              title: newName,
                                              supermarkets: new_supermarkets),
                                        );
                                      },
                                      icon: const Icon(Icons.save),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<ProductsProvider>(context, listen: false)
                              .deleteProduct(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
