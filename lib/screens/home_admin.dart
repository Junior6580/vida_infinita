import 'package:flutter/material.dart';
import 'package:vida_infinita/screens/login.dart';
import 'package:vida_infinita/screens/user_list.dart';
import 'package:vida_infinita/screens/add_product.dart';
import 'package:vida_infinita/screens/products_admin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeAdmin(),
        '/login': (context) => const LoginPage(),
        '/productos': (context) => ProductsAdmin(),
      },
    );
  }
}

class HomeAdmin extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeAdmin> {
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
        title: const Text('Vida Infinita'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('Sesión cerrada con éxito.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                          Navigator.pushNamed(context, 'login');
                        },
                        child: const Text('Aceptar'),
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
            : const Text('Contenido de la vista de inicio'),
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
            } else if (val == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductsAdmin(),
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

class Jumbotron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
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
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // You can navigate to a dedicated history page if needed
              },
              child: const Text('Leer más'),
            ),
          ],
        ),
      ),
    );
  }
}
