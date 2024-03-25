import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/models/queries/userQueries.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceQueries {
  static Future<PostgrestList> createAnnonce({required String title, required String description, required DateTime dateDeb, required DateTime dateFin, }) async {
    return await supabaseClient.from('ANNONCES').insert({
      'title': title,
      'description': description,
      'dateDeb': dateDeb.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
    }).select('id');
  }

  static Future<PostgrestList> getAnnonces() async {
    final response = await supabaseClient.from('ANNONCES').select();
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceById(String id) async {
    final response = await supabaseClient.from('ANNONCES').select().eq('id', id);
    if (response.isEmpty) {
      throw Exception('Failed to get annonce');
    }
    return response;
  }

  static Future<String> getAnnonceUserPublieById(String id) async {
    final userId = await supabaseClient.from('PUBLIE').select().eq('id_a', id);
    if (userId.isEmpty) {
      throw Exception('Failed to get annonce');
    }
    return userId.first['id_user'] as String;
  }

  static Future<String>? getAnnonceUserRepondById(String id) async {
    final userId = await supabaseClient.from('REPONDS').select().eq('id_a', id);
    if (userId.isEmpty) {
      throw Exception('Failed to get annonce');
    }
    return userId.first['id_user'] as String;
  }

  static void accepterAnnonce(String id_a, String id_user) {
    supabaseClient.from('REPONDS').insert({
      'id_a': id_a,
      'id_user': id_user,
    });
  }

  static void cloturerAnnonce(String id) {
    supabaseClient.from('REPONDS').delete().eq('id_a', id);
  }
}