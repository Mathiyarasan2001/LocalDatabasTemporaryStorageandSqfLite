import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SqfliteHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
      """CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        number TEXT,
        imagePath TEXT,  -- Added column for image path
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""",
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), "study.db"),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<int> createItems(
      String name, String number, String? imagePath) async {
    final db = await SqfliteHelper.db();
    final data = {
      "name": name,
      "number": number,
      "imagePath": imagePath,
    };
    try {
      return await db.insert(
        "items",
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("Error inserting item: $e");
      return -1;
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqfliteHelper.db();
    try {
      return await db.query("items", orderBy: "id");
    } catch (e) {
      debugPrint("Error fetching items: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SqfliteHelper.db();
    try {
      final result = await db.query(
        "items",
        limit: 1,
        where: "id = ?",
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      debugPrint("Error fetching item with ID $id: $e");
      return [];
    }
  }

  static Future<int> updateItem(
      int id, String name, String number, String? imagePath) async {
    final db = await SqfliteHelper.db();
    final data = {
      "name": name,
      "number": number,
      "imagePath": imagePath,
      "createdAt": DateTime.now().toString(),
    };
    try {
      return await db.update("items", data, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Error updating item with ID $id: $e");
      return -1;
    }
  }

  static Future<void> deleteItem(int id) async {
    final db = await SqfliteHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Error deleting item with ID $id: $e");
    }
  }

  static Future<void> closeDatabase() async {
    final db = await SqfliteHelper.db();
    await db.close();
  }
}

