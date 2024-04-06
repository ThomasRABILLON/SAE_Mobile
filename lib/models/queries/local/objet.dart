import 'package:sae_mobile/database/DatabaseHelper.dart';

class ObjetQueries {
  static void createObjet(String nom) async {
    final db = await DatabaseHelper().db;
    await db.insert('OBJET', {
      'nom': nom,
    });
  }

  static Future<List<Map<String, dynamic>>> getObjets() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> objets = await db.query('OBJET');
    return objets;
  }

  static Future<Map<String, dynamic>> getObjetById(int id) async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> objets = await db.query('OBJET', where: 'idObj = ?', whereArgs: [id]);
    return objets.first;
  }

  static void updateObjet(int id, String nom) async {
    final db = await DatabaseHelper().db;
    await db.update('OBJET', {
      'nom': nom,
    }, where: 'idObj = ?', whereArgs: [id]);
  }

  static void deleteObjet(int id) async {
    final db = await DatabaseHelper().db;
    await db.delete('OBJET', where: 'idObj = ?', whereArgs: [id]);
  }
}