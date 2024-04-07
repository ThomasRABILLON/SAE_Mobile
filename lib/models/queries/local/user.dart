import 'package:sae_mobile/database/DatabaseHelper.dart';

class UserQueries {
  static Future<void> createUser(String id, String email, String text) async {
    final db = await DatabaseHelper().db;
    await db.insert('USERS', {
      'id': id,
      'email': email,
      'username': text,
    });
  }
}
