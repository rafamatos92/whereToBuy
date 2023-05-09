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
    final products = Provider.of<ProductsProvider>(context).shopping_list;
    final supermarkets =
        Provider.of<SupermarketsProvider>(context).supermarkets;
    final cheapestProductsBySupermarket =
        Provider.of<ProductsProvider>(context).cheapestProductsBySupermarket;

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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.blue[300], // background color
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$supermarketName',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
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
                                                children: [
                                                  SizedBox(
                                                    width: 200,
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
                                                Navigator.of(context).pop();
                                                Provider.of<ProductsProvider>(
                                                        context,
                                                        listen: false)
                                                    .editProduct(
                                                  Product(
                                                      id: newProduct.id,
                                                      title: newName,
                                                      barcode: newBarCode,
                                                      supermarkets:
                                                          new_supermarkets,
                                                      isSelected: true),
                                                );
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
                                    Text('${product.supermarkets[0].price}€'),
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
