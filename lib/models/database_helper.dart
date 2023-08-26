import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vida_infinita/models/product.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('my_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        data TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        profile TEXT NOT NULL
      )
    ''');

    await _insertInitialUser(db);

    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price REAL,          -- Adding the price field
        imagePath TEXT
      )
    ''');

    await _insertInitialProduct(db);
  }

  Future<void> _insertInitialUser(Database db) async {
    await db.insert(
      'users',
      {
        'id': 1,
        'data': 'Junior Medina',
        'username': 'junior890',
        'password': '123456',
        'profile': 'admin',
      },
    );
  }

  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<void> _insertInitialProduct(Database db) async {
    final initialProducts = [
      Product(
        id: 1,
        name: 'Gengibre',
        description: 'Mayor Calidad',
        price: 5.99,
        imagePath: 'assets/images/image_1.png',
      ),
      Product(
        id: 2,
        name: 'Vitacerebrina',
        description: 'Nutritivo',
        price: 9.99,
        imagePath: 'assets/images/image_2.png',
      ),
      // Add more products as needed
    ];

    final batch = db.batch();
    for (var product in initialProducts) {
      batch.insert('products', product.toMap());
    }

    await batch.commit();
  }

  Future<List<Product>> fetchProducts() async {
    final db = await instance.database;
    final maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        description: maps[i]['description'] as String,
        price: maps[i]['price'] as double,
        imagePath: maps[i]['imagePath'] as String,
      );
    });
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
