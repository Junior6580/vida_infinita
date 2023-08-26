import 'package:flutter/material.dart';
import 'dart:io'; // Importa esto para usar File
import 'package:vida_infinita/models/product.dart';
import 'package:vida_infinita/screens/home_admin.dart';
import 'package:vida_infinita/screens/add_product.dart';
import 'package:vida_infinita/models/database_helper.dart';

class ProductsAdmin extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductsAdmin> {
  int currentIndex = 1; // Inicializa el índice actual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        automaticallyImplyLeading: false, // Esto oculta la flecha de retroceso
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
                  subtitle:
                      Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                  leading: product.imagePath.startsWith(
                          'assets/') // Verifica si la imagen es de la carpeta assets
                      ? Image.asset(
                          product
                              .imagePath, // Ruta de la imagen en la carpeta assets
                          width: 50,
                          height: 50,
                        )
                      : Image.file(
                          File(product
                              .imagePath), // Carga la imagen desde el almacenamiento
                          width: 50,
                          height: 50,
                        ),
                  // Agrega más información para mostrar si es necesario
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Nuevo',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (val) {
          setState(() {
            currentIndex = val;
            if (val == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeAdmin(),
              ));
            } else if (val == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddProduct(),
              ));
            }
          });
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ProductsAdmin()));
}
