import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Model.dart';
class DbManager {
  Database? _database = null;

  Future openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "Contact Details"),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE contacts (id INTEGER PRIMARY KEY autoincrement, name TEXT, number TEXT, photoname TEXT)",
        );
      },
    );
    return _database;
  }

  Future<int?> insertData(Model model) async {
    await openDb();
    int? a = await _database?.insert('contacts', model.toJson());
    return a;
  }

  Future<List<Model>> getDataList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.rawQuery('SELECT * FROM contacts');
    return List.generate(maps.length, (i) {
      return Model(
        id: maps[i]['id'],
        personName: maps[i]['name'],
        number: maps[i]['number'],
        photoName: maps[i]['photoname'],
      );
    });
  }

  Future<int> updateData(Model model) async {
    await openDb();
    return await _database!.update('contacts', model.toJson(), where: "id = ?", whereArgs: [model.id]);
  }

  Future<void> deleteData(Model model) async {
    await openDb();
    await _database!.delete('contacts', where: "id = ?", whereArgs: [model.id]);
  }
  Future<List<Model>> getAllData() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.rawQuery('SELECT * FROM contacts');

    return List.generate(maps.length, (i) {
      return Model(
        id: maps[i]['id'],
        personName: maps[i]['name'],
        number: maps[i]['number'],
        photoName: maps[i]['photoname'],
      );
    });
  }
  Future<List<Model>> searchContacts(String query) async {
    await openDb();
    
    final List<Map<String, dynamic>> maps = await _database!.query(
      'contacts',
      where: 'name LIKE ? ',
      whereArgs: ['%$query%' ],
    );

    return List.generate(maps.length, (i) {
      return Model(
        id: maps[i]['id'],
        personName: maps[i]['name'],
        number: maps[i]['number'],
        photoName: maps[i]['photoname'],
      );
    });
  }
}

