import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/supermarket.dart';
import 'package:shopping/providers/supermarket.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

    final filteredProducts = products
        .where((product) =>
            product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.barcode.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (
              BuildContext context,
            ) {
              String newName = '';
              String newBarcode = '';
              String? selectedUnit = 'Kg';
              String? selectedCategory = '';
              Product newProduct = Product(
                id: generateUniqueId(),
                title: '',
                barcode: '',
                supermarkets: SupermarketsProvider().supermarkets,
              );
              final TextEditingController _controller =
                  TextEditingController(text: newProduct.barcode);

              return AlertDialog(
                title: const Text('Adicionar Produto'),
                content: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        newName = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Introduzir novo nome',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 230,
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              newBarcode = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Introduzir Código de Barras',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final String barcode =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#FF0000',
                                    'Cancel',
                                    true,
                                    ScanMode.BARCODE);
                            setState(() {
                              newProduct.barcode = barcode;
                              newBarcode = barcode;
                              _controller.text = barcode;
                            });
                          },
                          icon: Icon(Icons.barcode_reader),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField<String>(
                            value: selectedUnit,
                            onChanged: (value) {
                              setState(() {
                                selectedUnit = value!;
                              });
                            },
                            items: <String>['Kg', 'Un']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
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
                                  double price = double.tryParse(value) ?? 0.0;
                                  newProduct.supermarkets[index].price = price;
                                },
                                controller: TextEditingController(
                                    text: newProduct.supermarkets[index].price
                                        .toString()),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
                      newProduct.category = selectedCategory ?? '';
                      newProduct.units = selectedUnit ?? '';
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return Column(
                  children: [
                    ListTile(
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
                              final TextEditingController _barcode_controller =
                                  TextEditingController(text: product.barcode);

                              showDialog(
                                context: context,
                                builder: (
                                  BuildContext context,
                                ) {
                                  String newName = product.title;
                                  String newBarCode = product.barcode;
                                  String selectedUnit = product.units;
                                  String selectedCategory = product.category;
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 220,
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
                                                              ScanMode.BARCODE);
                                                  setState(() {
                                                    product.barcode = barcode;
                                                    newBarCode = barcode;
                                                    _barcode_controller.text =
                                                        barcode;
                                                  });
                                                },
                                                icon:
                                                    Icon(Icons.barcode_reader),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: DropdownButtonFormField<
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
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: selectedCategory,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCategory = value!;
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
                                              itemCount:
                                                  product.supermarkets.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Text(
                                                    product.supermarkets[index]
                                                        .name,
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
                                            Provider.of<ProductsProvider>(
                                                    context,
                                                    listen: false)
                                                .editProduct(
                                              Product(
                                                  id: product.id,
                                                  title: newName,
                                                  barcode: newBarCode,
                                                  units: selectedUnit,
                                                  category: selectedCategory,
                                                  supermarkets:
                                                      new_supermarkets),
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
                            onPressed: () {
                              Provider.of<ProductsProvider>(context,
                                      listen: false)
                                  .deleteProduct(index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    )
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar',
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
