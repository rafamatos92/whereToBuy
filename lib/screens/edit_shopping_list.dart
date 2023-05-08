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
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

    // Filter the list of products based on the search query
    final filteredProducts = products
        .where((product) =>
            product.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
                  trailing: Checkbox(
                    value: product.isSelected,
                    onChanged: (value) {
                      product.isSelected = value!;
                      final productsProvider =
                          Provider.of<ProductsProvider>(context, listen: false);

                      value
                          ? productsProvider.addToShoppingList(index)
                          : productsProvider
                              .deleteFromShoppingList(product.title);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
