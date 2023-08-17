import 'package:flutter/material.dart';
import 'package:vida_infinita/screens/home.dart';

class Products extends StatefulWidget {
  final String? title;
  Products({this.title});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '${widget.title}',
            style: TextStyle(
              color: Colors.black,
            ),
          )),
      body: Center(
        child: Row(
          children: [
            Column(
              children: [
                ProductCard(
                  image: 'assets/images/image_1.png',
                  description: 'Producto Uno',
                ),
                ProductCard(
                  image: 'assets/images/image_1.png',
                  description: 'Producto Tres',
                ),
                ProductCard(
                  image: 'assets/images/image_1.png',
                  description: 'Producto Cinco',
                ),
              ],
            ),
            Column(
              children: [
                ProductCard(
                  image: 'assets/images/image_2.png',
                  description: 'Producto Dos',
                ),
                ProductCard(
                  image: 'assets/images/image_2.png',
                  description: 'Producto Cuatro',
                ),
                ProductCard(
                  image: 'assets/images/image_2.png',
                  description: 'Producto Seis',
                ),
              ],
            ),
          ],
        ),
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
                builder: (context) => Home(),
              ));
            } else if (val == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    Products(title: 'Vida Saludable - Productos'),
              ));
            } else if (val == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Home(),
              ));
            }
          });
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String description;

  ProductCard({required this.image, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(22),
      child: Container(
        constraints: BoxConstraints.tightFor(height: 150, width: 150),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
