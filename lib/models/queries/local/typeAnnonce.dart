import 'package:sae_mobile/database/DatabaseHelper.dart';

class TypeAnnoncesQueries {
  static void createTypeAnnonce(String libelleType) async {
    final db = await DatabaseHelper().db;
    await db.insert('TYPEANNONCES', {
      'libelleType': libelleType,
    });
  }

  static Future<List<Map<String, dynamic>>> getTypeAnnonces() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> typeAnnonces =
        await db.query('TYPEANNONCES');
    return typeAnnonces;
  }

  static Future<Map<String, dynamic>> getTypeAnnonceById(int id) async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> typeAnnonces =
        await db.query('TYPEANNONCES', where: 'idType = ?', whereArgs: [id]);
    return typeAnnonces.first;
  }
}
