import 'package:flutter/material.dart';
import 'package:vida_infinita/screens/login.dart';
import 'package:vida_infinita/utils/color_utils.dart';
import 'package:vida_infinita/models/database_helper.dart';
import 'package:vida_infinita/reusable_widgets/reusable_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _dataTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  Future<void> _registerUser() async {
    final data = _dataTextController.text;
    final username = _userNameTextController.text;
    final password = _passwordTextController.text;
    final profile = "comprador";

    if (data.isEmpty || username.isEmpty || password.isEmpty) {
      return;
    }

    final db = await DatabaseProvider.instance.database;
    final success = await db.insert(
      'users',
      {
        'data': data,
        'username': username,
        'password': password,
        'profile': profile,
      },
    );

    if (success != null && success > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("No se ha podido guardar la información del usuario"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Registrarse",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor('0502a8'),
              hexStringToColor('00c1ff'),
              hexStringToColor('0488d8')
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Nombres", Icons.person, false, _dataTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Usuario", Icons.person_outline, false,
                    _userNameTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Contraseña", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, _registerUser)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
