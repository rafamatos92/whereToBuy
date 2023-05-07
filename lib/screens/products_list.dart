import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/supermarket.dart';
import 'package:shopping/providers/supermarket.dart';

import '../providers/product.dart';

class ProductsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

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
                  title: '',
                  supermarkets: SupermarketsProvider().getSupermarkets(),
                );
                print('list of supers: ${newProduct.toString()}');

                return AlertDialog(
                  title: Text('Add Product'),
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
                          itemCount:
                              SupermarketsProvider().getSupermarkets().length,
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
                      icon: Icon(Icons.cancel),
                    ),
                    IconButton(
                      onPressed: () {
                        newProduct.title = newName;
                        Navigator.of(context).pop();
                        Provider.of<ProductsProvider>(context, listen: false)
                            .addProduct(newProduct);
                      },
                      icon: Icon(Icons.save),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.add)),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product.title),
            subtitle: Text('${product.supermarkets.length} supermarkets'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
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
                            title: Text('Edit ${product.title}'),
                            content: Column(
                              children: [
                                TextField(
                                  controller: _controller,
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
                                    itemCount: product.supermarkets.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                          product.supermarkets[index].name,
                                        ),
                                        trailing: SizedBox(
                                          width: 100.0,
                                          child: TextField(
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true),
                                            decoration: const InputDecoration(
                                              hintText: '0.00',
                                            ),
                                            onChanged: (value) {
                                              double price =
                                                  double.tryParse(value) ?? 0.0;
                                              new_supermarkets[index].price =
                                                  price;
                                            },
                                            controller: TextEditingController(
                                                text: product
                                                    .supermarkets[index].price
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
                                icon: Icon(Icons.cancel),
                              ),
                              IconButton(
                                onPressed: () {
                                  product.title = newName;
                                  Navigator.of(context).pop();
                                  Provider.of<ProductsProvider>(context,
                                          listen: false)
                                      .editProduct(
                                    index,
                                    Product(
                                        title: newName,
                                        supermarkets: new_supermarkets),
                                  );
                                },
                                icon: Icon(Icons.save),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
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
    );
  }
}
