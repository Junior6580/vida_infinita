import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vida_infinita/models/product.dart';
import 'package:vida_infinita/screens/home_comprador.dart';
import 'package:vida_infinita/models/database_helper.dart';

class ProductsComprador extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductsComprador> {
  int currentIndex = 1;
  List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      final existingProductIndex =
          cart.indexWhere((item) => item.id == product.id);

      if (existingProductIndex != -1) {
        cart[existingProductIndex].quantity++;
      } else {
        cart.add(product);
      }

      final snackBar = SnackBar(
        content: Text('${product.name} agregado al carrito'),
        duration: Duration(seconds: 2),
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
                builder: (context) => CartScreen(cart),
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
                      Text('Descripción: ${product.description}'),
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

class CartScreen extends StatefulWidget {
  final List<Product> cartProducts;

  CartScreen(this.cartProducts);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    total = widget.cartProducts.fold(0,
        (previous, current) => previous + (current.price * current.quantity));
  }

  void removeFromCart(Product product) {
    setState(() {
      widget.cartProducts.remove(product);
      calculateTotal();
    });
  }

  void clearCart() {
    setState(() {
      widget.cartProducts.clear();
      calculateTotal();
    });
  }

  void sendWhatsAppMessage() async {
    String phoneNumber = '+573245610826';
    final StringBuffer messageBuffer = StringBuffer();
    messageBuffer.write(
        'Hola, quiero confirmar una compra por un total de \$${total.toStringAsFixed(2)} en los siguientes productos:\n\n');

    for (final product in widget.cartProducts) {
      messageBuffer.write(
          '${product.name} - Cantidad: ${product.quantity} - \$${(product.price * product.quantity).toStringAsFixed(2)}\n');
    }

    String whatsappUrl =
        "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(messageBuffer.toString())}";

    if (await launch(whatsappUrl)) {
      await launch(whatsappUrl);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Solicitud enviada'),
            content:
                Text('Su solicitud de compra ha sido enviada por WhatsApp.'),
            actions: [
              TextButton(
                onPressed: () {
                  clearCart(); // Limpia el carrito al presionar OK
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'No se pudo abrir WhatsApp. Por favor, intente nuevamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: widget.cartProducts.isEmpty
          ? Center(child: Text('Carrito de Compras Vacío'))
          : ListView.builder(
              itemCount: widget.cartProducts.length,
              itemBuilder: (context, index) {
                final cartProduct = widget.cartProducts[index];
                return ListTile(
                  title: Text(cartProduct.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio: \$${cartProduct.price.toStringAsFixed(2)}'),
                      Text('Cantidad: ${cartProduct.quantity}'),
                      Text('Descripción: ${cartProduct.description}'),
                    ],
                  ),
                  leading: cartProduct.imagePath.startsWith('assets/')
                      ? Image.asset(
                          cartProduct.imagePath,
                          width: 50,
                          height: 50,
                        )
                      : Image.file(
                          File(cartProduct.imagePath),
                          width: 50,
                          height: 50,
                        ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeFromCart(cartProduct);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: widget.cartProducts.isEmpty
          ? null
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendWhatsAppMessage();
                    },
                    child: Text('Confirmar'),
                  ),
                ],
              ),
            ),
    );
  }
}
