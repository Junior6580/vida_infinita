import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vida_infinita/models/product.dart';

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
    total = widget.cartProducts
        .fold(0, (previous, current) => previous + current.price);
  }

  void removeFromCart(Product product) {
    setState(() {
      widget.cartProducts.remove(product);
      calculateTotal();
    });
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
                      Text(
                          'Descripción: ${cartProduct.description}'), // Mostrar descripción
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
                      // Agrega aquí la lógica para completar la compra
                      // Supongamos que completar la compra significa mostrar la pantalla de confirmación

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(
                              widget.cartProducts, total),
                        ),
                      ).then((value) {
                        // Limpiar el carrito si la compra fue confirmada
                        if (value == true) {
                          setState(() {
                            widget.cartProducts.clear();
                            calculateTotal();
                          });

                          // Mostrar una alerta de compra exitosa al regresar de la pantalla de confirmación
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Compra Exitosa'),
                              content: Text('¡Gracias por tu compra!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    },
                    child: Text('Comprar'),
                  ),
                ],
              ),
            ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  final List<Product> orderedProducts;
  final double total;

  OrderConfirmationScreen(this.orderedProducts, this.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmación de Compra'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Productos Comprados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: orderedProducts.length,
            itemBuilder: (context, index) {
              final orderedProduct = orderedProducts[index];
              return ListTile(
                title: Text(orderedProduct.name),
                subtitle: Text('\$${orderedProduct.price.toStringAsFixed(2)}'),
                leading: orderedProduct.imagePath.startsWith('assets/')
                    ? Image.asset(
                        orderedProduct.imagePath,
                        width: 50,
                        height: 50,
                      )
                    : Image.file(
                        File(orderedProduct.imagePath),
                        width: 50,
                        height: 50,
                      ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Total a Pagar: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                  context, true); // Retornar un valor al cerrar la pantalla
            },
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
