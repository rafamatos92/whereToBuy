import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/edit_shopping_list.dart';

import '../models/product.dart';
import '../models/supermarket.dart';
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
    final shopingListCopy = Provider.of<ProductsProvider>(context)
        .shopping_list
        .map((p) => p.copyWith())
        .toList();
    final products = Provider.of<ProductsProvider>(context).shopping_list;
    final supermarkets =
        Provider.of<SupermarketsProvider>(context).supermarkets;
    final cheapestProductsBySupermarket =
        Provider.of<ProductsProvider>(context).cheapestProductsBySupermarket;

    List<String> categories = [
      "",
      "Frutas e vegetais",
      "Carnes",
      "Peixes",
      "Laticínios e ovos",
      "Padaria",
      "Produtos enlatados",
      "Bebidas",
      "Limpeza",
      "Higiene pessoal",
      "Doces/Snacks",
      "Outros",
      "Animais"
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditShoppingList()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: cheapestProductsBySupermarket.isEmpty
          ? const Center(
              child: Text(
                'Adiciona artigos à tua lista!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: cheapestProductsBySupermarket.length,
              itemBuilder: (context, index) {
                final supermarketName =
                    cheapestProductsBySupermarket.keys.elementAt(index);
                final products =
                    cheapestProductsBySupermarket[supermarketName]!;
                var total = 0.0;
                for (final product in shopingListCopy) {
                  final price = product.supermarkets
                      .where((element) => element.name == supermarketName)
                      .first
                      .price;
                  total += price;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.blue[300], // background color
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '$supermarketName',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '$total€',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Column(
                          children: [
                            Dismissible(
                              key: Key(product.id),
                              direction: DismissDirection.horizontal,
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.blue,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child:
                                    const Icon(Icons.edit, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  Provider.of<ProductsProvider>(context,
                                          listen: false)
                                      .deleteFromShoppingList(product.title);
                                }
                              },
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  return true;
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  final TextEditingController _controller =
                                      TextEditingController(
                                          text: product.title);
                                  final TextEditingController
                                      _barcode_controller =
                                      TextEditingController(
                                          text: product.barcode);

                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (
                                      BuildContext context,
                                    ) {
                                      int newProdIndex =
                                          Provider.of<ProductsProvider>(context)
                                              .products
                                              .indexWhere((element) =>
                                                  element.id == product.id);
                                      Product newProduct =
                                          Provider.of<ProductsProvider>(context)
                                              .products[newProdIndex];
                                      String newName = product.title;
                                      String newBarCode = product.barcode;
                                      String selectedUnit = newProduct.units;
                                      String selectedCategory =
                                          newProduct.category;
                                      List<Supermarket> new_supermarkets =
                                          newProduct.supermarkets;

                                      return SingleChildScrollView(
                                        child: AlertDialog(
                                          title:
                                              Text('Editar ${product.title}'),
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: _controller,
                                                onChanged: (value) {
                                                  newName = value;
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'Introduzir novo nome',
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 250,
                                                    child: TextField(
                                                      controller:
                                                          _barcode_controller,
                                                      onChanged: (value) {
                                                        newBarCode = value;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Introduzir Código de barras',
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      final String barcode =
                                                          await FlutterBarcodeScanner
                                                              .scanBarcode(
                                                                  '#FF0000',
                                                                  'Cancel',
                                                                  true,
                                                                  ScanMode
                                                                      .BARCODE);
                                                      setState(() {
                                                        product.barcode =
                                                            barcode;
                                                        newBarCode = barcode;
                                                        _barcode_controller
                                                            .text = barcode;
                                                      });
                                                    },
                                                    icon: Icon(Icons.camera),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: selectedUnit,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedUnit = value!;
                                                        });
                                                      },
                                                      items: <String>[
                                                        '',
                                                        'Kg',
                                                        'Un'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: selectedCategory,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedCategory =
                                                              value!;
                                                        });
                                                      },
                                                      items: categories.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 300,
                                                width: double.maxFinite,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: newProduct
                                                      .supermarkets.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ListTile(
                                                      title: Text(
                                                        newProduct
                                                            .supermarkets[index]
                                                            .name,
                                                      ),
                                                      trailing: SizedBox(
                                                        width: 100.0,
                                                        child: TextField(
                                                          keyboardType:
                                                              const TextInputType
                                                                      .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText: '0.00',
                                                          ),
                                                          onChanged: (value) {
                                                            double price =
                                                                double.tryParse(
                                                                        value) ??
                                                                    0.0;
                                                            new_supermarkets[
                                                                    index]
                                                                .price = price;
                                                          },
                                                          controller: TextEditingController(
                                                              text: newProduct
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
                                                product.units = selectedUnit;
                                                product.category =
                                                    selectedCategory;
                                                Navigator.of(context).pop();
                                                Provider.of<ProductsProvider>(
                                                        context,
                                                        listen: false)
                                                    .editProduct(
                                                  Product(
                                                      id: newProduct.id,
                                                      title: newName,
                                                      barcode: newBarCode,
                                                      units: selectedUnit,
                                                      category:
                                                          selectedCategory,
                                                      supermarkets:
                                                          new_supermarkets,
                                                      isSelected: true),
                                                );
                                                Provider.of<ProductsProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteFromShoppingList(
                                                        newName);
                                              },
                                              icon: const Icon(Icons.save),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  return confirm ?? false;
                                }
                                return false;
                              },
                              child: ListTile(
                                title: Text(product.title),
                                subtitle: Row(
                                  children: [
                                    Text(product.barcode != ''
                                        ? '${product.barcode} - '
                                        : ''),
                                    Text(
                                        '${product.supermarkets[0].price}€ / ${product.units}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .deleteFromShoppingList(product.title);
                                  },
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
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
