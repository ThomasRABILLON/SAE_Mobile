import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/models/queries/userQueries.dart';
import 'package:sae_mobile/models/user.dart' as user_model;

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceQueries {
  static Future<String> createAnnonce(String title, String description, DateTime dateDeb, DateTime dateFin, user_model.User auteur) async {
    PostgrestList result = await supabaseClient.from('ANNONCES').insert({
      'titre': title,
      'description': description,
      'date_deb': dateDeb.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
    }).select('id');
    if (result.isEmpty) {
      throw Exception('Failed to create annonce');
    }
    String id = result.first['id'] as String;
    await supabaseClient.from('PUBLIE').insert({
      'id_a': id,
      'id_user': auteur.id,
    });
    return id;
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