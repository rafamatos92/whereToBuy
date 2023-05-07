import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/product.dart';
import 'package:shopping/providers/supermarket.dart';
import 'package:shopping/screens/edit_lists.dart';
import 'package:shopping/screens/shopping_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProductsProvider().loadShoppingList();
  await SupermarketsProvider().loadSupermarkets();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => SupermarketsProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping List',
          home: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditWidget()),
                );
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: CheapestProductsListWidget(),
      ),
    );
  }
}
