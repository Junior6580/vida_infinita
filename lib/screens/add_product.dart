import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vida_infinita/models/product.dart';
import 'package:vida_infinita/screens/home_admin.dart';
import 'package:vida_infinita/models/database_helper.dart';
import 'package:vida_infinita/screens/products_admin.dart';

class AddProduct extends StatefulWidget {
  final String? title;
  AddProduct({this.title});
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  late String _name = '';
  late String _description = '';
  late double _price = 0.0;
  late File _image = File('');

  final ImagePicker _picker = ImagePicker();
  int currentIndex = 2;

  void _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro Exitoso'),
          content: Text('El producto se ha guardado correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsAdmin()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _name,
        description: _description,
        price: _price,
        imagePath: _image.path,
      );

      try {
        await DatabaseProvider.instance.insertProduct(product);
        _showSuccessDialog(); // Show the success dialog
      } catch (e) {
        _showAlertDialog(
            'Error al Guardar', 'Ocurrió un error al guardar el producto: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Nombres'),
              ),
              TextFormField(
                onChanged: (value) => _description = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la descripción del producto';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio del producto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un valor numérico válido';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Precio'),
              ),
              SizedBox(height: 20),
              _image.path.isEmpty
                  ? TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo),
                      label: Text('Seleccionar Imagen'),
                    )
                  : Image.file(
                      _image,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              Spacer(),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Guardar Producto'),
              ),
            ],
          ),
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
