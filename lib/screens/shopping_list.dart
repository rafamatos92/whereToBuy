import 'package:flutter/material.dart';
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
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditShoppingList()),
          );
        },
        icon: const Icon(Icons.add),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Dismissible(
                    key: Key(product.id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        Provider.of<ProductsProvider>(context, listen: false)
                            .deleteFromShoppingList(product.title);
                      }
                    },
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        return true;
                      } else if (direction == DismissDirection.endToStart) {
                        final TextEditingController _controller =
                            TextEditingController(text: product.title);

                        final confirm = await showDialog(
                          context: context,
                          builder: (
                            BuildContext context,
                          ) {
                            int newProdIndex =
                                Provider.of<ProductsProvider>(context)
                                    .products
                                    .indexWhere(
                                        (element) => element.id == product.id);
                            Product newProduct =
                                Provider.of<ProductsProvider>(context)
                                    .products[newProdIndex];
                            String newName = product.title;
                            List<Supermarket> new_supermarkets =
                                newProduct.supermarkets;

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
                                            newProduct.supermarkets.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(
                                              newProduct
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
                                                      double.tryParse(value) ??
                                                          0.0;
                                                  new_supermarkets[index]
                                                      .price = price;
                                                },
                                                controller:
                                                    TextEditingController(
                                                        text: newProduct
                                                            .supermarkets[index]
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
                                            id: newProduct.id,
                                            title: newName,
                                            supermarkets: new_supermarkets,
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
                      subtitle: Text('${product.supermarkets[0].price}€'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          Provider.of<ProductsProvider>(context, listen: false)
                              .deleteFromShoppingList(product.title);
                        },
                      ),
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
