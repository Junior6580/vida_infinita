import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vida_infinita/models/product.dart';
import 'package:vida_infinita/screens/shopping_cart.dart';
import 'package:vida_infinita/models/database_helper.dart';
import 'package:vida_infinita/screens/home_comprador.dart';

class ProductsComprador extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductsComprador> {
  int currentIndex = 1;
  List<Product> cart = []; // Lista para almacenar los productos en el carrito

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
      // Mostrar un SnackBar como mensaje de confirmación
      final snackBar = SnackBar(
        content: Text('${product.name} agregado al carrito'),
        duration: Duration(seconds: 2), // Duración del SnackBar
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartScreen(
                    cart), // Pasa la lista de productos en el carrito
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: DatabaseProvider.instance.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los productos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay productos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                      Text(
                          'Descripción: ${product.description}'), // Mostrar descripción
                    ],
                  ),
                  leading: product.imagePath.startsWith('assets/')
                      ? Image.asset(
                          product.imagePath,
                          width: 50,
                          height: 50,
                        )
                      : Image.file(
                          File(product.imagePath),
                          width: 50,
                          height: 50,
                        ),
                  trailing: IconButton(
                    icon: Icon(Icons.add_chart),
                    onPressed: () {
                      addToCart(product);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Productos',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (val) {
          setState(() {
            currentIndex = val;
            if (val == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeComprador(),
              ));
            } else if (val == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductsComprador(),
              ));
            }
          });
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ProductsComprador()));
}
