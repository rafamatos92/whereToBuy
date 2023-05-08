import 'package:flutter/material.dart';
import 'package:shopping/screens/products_list.dart';
import 'package:shopping/screens/supermarkets_list.dart';

class EditWidget extends StatefulWidget {
  const EditWidget({Key? key}) : super(key: key);

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProductsListWidget(),
    const SupermarketsListWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Produtos',
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Lojas',
            icon: Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}
