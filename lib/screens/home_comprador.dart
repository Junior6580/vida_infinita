import 'package:flutter/material.dart';
import 'package:vida_infinita/screens/login.dart';
import 'package:vida_infinita/screens/products_comprador.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeComprador(),
        '/login': (context) => LoginPage(),
        '/productos': (context) => ProductsComprador(),
      },
    );
  }
}

class HomeComprador extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeComprador> {
  int currentIndex = 0;

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
        title: Text('Vida Saludable'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cerrar Sesión'),
                    content: Text('Sesión cerrada con éxito.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Text('Aceptar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: currentIndex == 0
            ? Jumbotron()
            : Text('Contenido de la vista de inicio'),
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

class Jumbotron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20.0),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historia de los Productos Naturistas',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'La historia de los productos naturistas se remonta a épocas antiguas, cuando las civilizaciones humanas comenzaron a utilizar plantas, hierbas y otros recursos naturales para tratar enfermedades y promover la salud. A lo largo de los siglos, diversas culturas han desarrollado prácticas y conocimientos en torno a la medicina herbal y las terapias naturales.',
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('Leer más'),
            ),
          ],
        ),
      ),
    );
  }
}
