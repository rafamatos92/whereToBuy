import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/models/supermarket.dart';
import '../providers/product.dart';
import '../providers/supermarket.dart';

class SupermarketsListWidget extends StatefulWidget {
  const SupermarketsListWidget({Key? key}) : super(key: key);

  @override
  State<SupermarketsListWidget> createState() => _SupermarketsListWidget();
}

class _SupermarketsListWidget extends State<SupermarketsListWidget> {
  @override
  Widget build(BuildContext context) {
    final supermarkets =
        Provider.of<SupermarketsProvider>(context).supermarkets;

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (
              BuildContext context,
            ) {
              String newName = ''; // initial value

              return AlertDialog(
                title: const Text('Editar loja'),
                content: TextField(
                  onChanged: (value) {
                    newName = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Introduz novo nome',
                  ),
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
                      Navigator.of(context).pop();
                      Provider.of<SupermarketsProvider>(context, listen: false)
                          .addSupermarket(
                              Supermarket(name: newName, price: 0.0));
                      Provider.of<ProductsProvider>(context, listen: false)
                          .addSupermarket(
                              Supermarket(name: newName, price: 0.0));
                      Provider.of<ProductsProvider>(context, listen: false)
                          .notifyListeners();
                    },
                    icon: const Icon(Icons.save),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: supermarkets.length,
        itemBuilder: (context, index) {
          final supermarket = supermarkets[index];

          return Container(
            width: double.infinity, // or use a fixed width like 500.0
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(supermarket.name),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Open dialog to edit supermarket name
                    final TextEditingController _controller =
                        TextEditingController(text: supermarket.name);

                    showDialog(
                      context: context,
                      builder: (
                        BuildContext context,
                      ) {
                        String newName = supermarket.name; // initial value

                        return AlertDialog(
                          title: const Text('Editar Loja'),
                          content: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              newName = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Introduz novo nome',
                            ),
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
                                supermarket.name = newName;
                                Navigator.of(context).pop();
                                Provider.of<SupermarketsProvider>(context,
                                        listen: false)
                                    .editSupermarket(
                                  index,
                                  Supermarket(
                                      name: newName, price: supermarket.price),
                                );
                              },
                              icon: const Icon(Icons.save),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<SupermarketsProvider>(context, listen: false)
                        .deleteSupermarket(index);
                    Provider.of<ProductsProvider>(context, listen: false)
                        .deleteSupermarket(supermarket);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
