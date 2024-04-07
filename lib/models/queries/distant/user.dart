import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class UserQueries {
  static Future<PostgrestList> getUsers() async {
    final response = await supabaseClient.from('USERS').select();
    if (response.isEmpty) {
      throw Exception('Failed to get users');
    }
    return response;
  }

  static Future<PostgrestList> getUserById(String id) async {
    final response = await supabaseClient.from('USERS').select().eq('id', id);
    if (response.isEmpty) {
      throw Exception('Failed to get user');
    }
    return response;
  }

  static Future<void> mettreAvisUtilisateur(
      String id_upush, String id_uget, String avis) async {
    await supabaseClient.from('AVIS_USERS').insert({
      'id_upush': id_upush,
      'id_uget': id_uget,
      'avis': avis,
    });
  }

  static Future<PostgrestList> getUtilisateurAvis(String id_uget) async {
    final response = await supabaseClient
        .from('AVIS_USERS')
        .select('avis, users:id_upush (username)')
        .eq('id_uget', id_uget);
    if (response.isEmpty) {
      throw Exception("Aucun avis pour cet utilisateur");
    }
    return response;
  }
}
