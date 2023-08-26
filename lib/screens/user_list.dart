import 'package:flutter/material.dart';
import 'package:vida_infinita/models/database_helper.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final db = await DatabaseProvider.instance.database;
    final users = await db.query('users');

    setState(() {
      _users = users;
    });
  }

  Future<void> _deleteUser(int userId) async {
    final db = await DatabaseProvider.instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);

    _fetchUsers();
  }

  Future<void> _editUser(int userId, String editedData, String editedUsername,
      String editedPassword, String editedProfile) async {
    final db = await DatabaseProvider.instance.database;

    await db.update(
      'users',
      {
        'id': userId,
        'data': editedData,
        'username': editedUsername,
        'password': editedPassword,
        'profile': editedProfile,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );

    _fetchUsers();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario Editado con Éxito'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          final userId = user['id'];
          String editedData = user['data'];
          String editedUsername = user['username'];
          String editedPassword = user['password'];
          String editedProfile = user['profile'];

          return ListTile(
            title: Text(editedData),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(editedUsername),
                Text('Perfil: $editedProfile'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Editar Usuario'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                initialValue: editedData,
                                onChanged: (newValue) {
                                  editedData = newValue;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Nombres'),
                              ),
                              TextFormField(
                                initialValue: editedUsername,
                                onChanged: (newValue) {
                                  editedUsername = newValue;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Nombre de usuario'),
                              ),
                              TextFormField(
                                initialValue: editedPassword,
                                onChanged: (newValue) {
                                  editedPassword = newValue;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Contraseña'),
                              ),
                              TextFormField(
                                initialValue: editedProfile,
                                onChanged: (newValue) {
                                  editedProfile = newValue;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Perfil'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _editUser(
                                    userId,
                                    editedData,
                                    editedUsername,
                                    editedPassword,
                                    editedProfile);
                                Navigator.pop(context);
                              },
                              child: Text('Guardar'),
                            ),
                          ],
                        );
                      },
                    );

                    _fetchUsers();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Eliminar Usuario'),
                          content: Text(
                              '¿Estás seguro de que deseas eliminar este usuario?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteUser(userId);
                                Navigator.pop(context);
                              },
                              child: Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
