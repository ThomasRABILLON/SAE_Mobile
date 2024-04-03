import 'package:sae_mobile/models/annonce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sae_mobile/models/queries/userQueries.dart';
import 'package:sae_mobile/models/user.dart' as user_model;

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceQueries {
  static Future<void> createAnnonce(String title, String description, DateTime dateDeb, DateTime dateFin, user_model.User auteur) async {
    // dans sqflite
  }
  
  static Future<void> publishAnnonce(Annonce annonce) async {
    PostgrestList result = await supabaseClient.from('ANNONCES').insert({
      'id': annonce.id,
      'titre': annonce.titre,
      'description': annonce.description,
      'date_deb': annonce.dateDeb.toIso8601String(),
      'date_fin': annonce.dateFin.toIso8601String(),
      'id_type': '1',
      'id_etat': annonce.etat,
    }).select('id');

    if (result.isEmpty) {
      throw Exception('Failed to create annonce');
    }

    await supabaseClient.from('PUBLIE').insert({
      'id_a': annonce.id,
      'id_user': annonce.auteur.id,
    });
  }

  static Future<PostgrestList> getAnnoncesSupabase() async {
    final response = await supabaseClient.from('ANNONCES').select();
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceByIdSupabase(String id) async {
    final response = await supabaseClient.from('ANNONCES').select().eq('id', id);
    if (response.isEmpty) {
      throw Exception('Failed to get annonce');
    }
    return response;
  }

  static Future<String> getAnnonceUserPublieByIdSupabase(String id) async {
    final userId = await supabaseClient.from('PUBLIE').select().eq('id_a', id);
    if (userId.isEmpty) {
      throw Exception('Failed to get annonce');
    }
    return userId.first['id_user'] as String;
  }

  static Future<String> getAnnonceUserRepondById(String id) async {
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