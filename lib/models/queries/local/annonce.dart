import 'package:sae_mobile/database/DatabaseHelper.dart';

class AnnonceQueries {
  static Future<void> createAnnonce(String titre, String description, DateTime dateDeb, DateTime dateFin, int idEtat, int idObj, int idType) async {
    final db = await DatabaseHelper().db;
    await db.insert('ANNONCES', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'titre': titre,
      'description': description,
      'dateDeb': dateDeb.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'idEtat': idEtat,
      'idObj': idObj,
      'idType': idType,
    });
  }

  static Future<List<Map<String, dynamic>>> getAnnonces() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> annonces = await db.query('ANNONCES');
    return annonces;
  }

  static Future<Map<String, dynamic>> getAnnonceById(String id) async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> annonces = await db.query('ANNONCES', where: 'id = ?', whereArgs: [id]);
    return annonces.first;
  }

  static Future<void> updateAnnonceEtat(String id, int etat) async {
    final db = await DatabaseHelper().db;
    await db.update('ANNONCES', {'idEtat': etat}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateAnnonceId(String id, String newId) async {
    final db = await DatabaseHelper().db;
    await db.update('ANNONCES', {'id': newId}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAnnonce(String id) async {
    final db = await DatabaseHelper().db;
    await db.delete('ANNONCES', where: 'id = ?', whereArgs: [id]);
  }
}