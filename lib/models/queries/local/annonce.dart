import 'package:sae_mobile/database/DatabaseHelper.dart';

class AnnonceQueries {
  static Future<Map<String, dynamic>> createAnnonce(
      String id_u,
      String titre,
      String description,
      DateTime dateDeb,
      DateTime dateFin,
      int idEtat,
      int idObj,
      int idType) async {
    final db = await DatabaseHelper().db;
    String id_a = DateTime.now().millisecondsSinceEpoch.toString();
    await db.insert('ANNONCES', {
      'id': id_a,
      'titre': titre,
      'description': description,
      'dateDeb': dateDeb.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'idEtat': idEtat,
      'idObj': idObj,
      'idType': idType,
    });
    await db.insert('PUBLIE', {
      'id_a': id_a,
      'id_u': id_u,
    });

    // Get the created announcement
    final List<Map<String, dynamic>> annonces =
        await db.query('ANNONCES', where: 'id = ?', whereArgs: [id_a]);
    return annonces.first;
  }

  static Future<List<Map<String, dynamic>>> getAnnonces() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> annonces = await db.query('ANNONCES');
    return annonces;
  }

  static Future<Map<String, dynamic>> getAnnonceById(String id) async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> annonces =
        await db.query('ANNONCES', where: 'id = ?', whereArgs: [id]);
    return annonces.first;
  }

  static Future<void> updateAnnonceEtat(String id, int etat) async {
    final db = await DatabaseHelper().db;
    await db.update('ANNONCES', {'idEtat': etat},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateAnnonceId(String id, String newId) async {
    final db = await DatabaseHelper().db;
    await db.update('ANNONCES', {'id': newId},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAnnonce(String id) async {
    final db = await DatabaseHelper().db;
    await db.delete('ANNONCES', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getAnnoncesByUser(String id) async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> annonces = await db.rawQuery('''
    SELECT ANNONCES.* 
    FROM ANNONCES 
    JOIN PUBLIE ON ANNONCES.id = PUBLIE.id_a 
    WHERE PUBLIE.id_u = ?
  ''', [id]);
    print("Les annonces local" + annonces.toString());
    return annonces;
  }
}
