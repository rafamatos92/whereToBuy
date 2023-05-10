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
  List<String> categories = [
    "All",
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
  List<bool> selectedCategories = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

    final filteredProducts = products
        .where((product) =>
            (searchQuery.isEmpty ||
                product.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                product.barcode
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())) &&
            (selectedCategories[0] ||
                selectedCategories[1] && product.category == categories[1] ||
                selectedCategories[2] && product.category == categories[2] ||
                selectedCategories[3] && product.category == categories[3] ||
                selectedCategories[4] && product.category == categories[4] ||
                selectedCategories[5] && product.category == categories[5] ||
                selectedCategories[6] && product.category == categories[6] ||
                selectedCategories[7] && product.category == categories[7] ||
                selectedCategories[8] && product.category == categories[8] ||
                selectedCategories[9] && product.category == categories[9] ||
                selectedCategories[10] && product.category == categories[10] ||
                selectedCategories[11] && product.category == categories[11] ||
                selectedCategories[12] && product.category == categories[12]))
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < categories.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: TextButton(
                          child: Text(
                            categories[i],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedCategories[i]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              for (int j = 0;
                                  j < selectedCategories.length;
                                  j++) {
                                if (j == i) {
                                  selectedCategories[j] = true;
                                } else {
                                  selectedCategories[j] = false;
                                }
                              }
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              selectedCategories[i]
                                  ? Colors.blue
                                  : Colors.grey[100],
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return Column(
                  children: [
                    ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.supermarkets
                          .map(
                              (s) => '${s.name}: ${s.price}€ /${product.units}')
                          .join(', ')),
                      trailing: Checkbox(
                        value: product.isSelected,
                        onChanged: (value) {
                          product.isSelected = value!;
                          final productsProvider =
                              Provider.of<ProductsProvider>(context,
                                  listen: false);

                          value
                              ? productsProvider.addToShoppingList(index)
                              : productsProvider
                                  .deleteFromShoppingList(product.title);
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
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
                  width: MediaQuery.of(context).size.width - 25,
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
