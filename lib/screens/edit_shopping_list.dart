import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/product.dart';

class EditShoppingList extends StatefulWidget {
  const EditShoppingList({Key? key}) : super(key: key);

  @override
  State<EditShoppingList> createState() => _EditShoppingListState();
}

class _EditShoppingListState extends State<EditShoppingList> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Lista'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                title: Text(product.title),
                trailing: Checkbox(
                  value: product.isSelected,
                  onChanged: (value) {
                    product.isSelected = value!;
                    final productsProvider =
                        Provider.of<ProductsProvider>(context, listen: false);

                    value
                        ? productsProvider.addToShoppingList(index)
                        : productsProvider.delFromShoppingList(product.title);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
