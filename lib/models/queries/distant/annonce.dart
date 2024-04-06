import 'package:sae_mobile/models/Annonce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceQueries {
  static Future<String> publishAnnonce(Annonce annonce) async {
    print("publishAnnonce");
    PostgrestList result = await supabaseClient.from('ANNONCES').insert({
      'titre': annonce.titre,
      'description': annonce.description,
      'dateDeb': annonce.dateDeb.toIso8601String(),
      'dateFin': annonce.dateFin.toIso8601String(),
      'idType': 'f138bd6d-332d-47a2-898c-635d59e6e27a',
      'idEtat': 2,
    }).select('id');
    print("result");

    if (result.isEmpty) {
      throw Exception('Failed to create annonce');
    }

    String id = result[0]['id'];

    await supabaseClient.from('PUBLIE').insert({
      'id_a': id,
      'id_user': annonce.auteur.id,
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

  static Future<PostgrestList> getAnnonceNonRepondu() async {
    final response = await supabaseClient.from('ANNONCES').select().eq('id_etat', 2);
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceRepondu(String id_u) async {
    final ids_a = await supabaseClient.from('REPONDS').select().eq('id_user', id_u);
    if (ids_a.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    final response = await supabaseClient.from('ANNONCES').select().inFilter('id', ids_a.map((e) => e['id_a']).toList());
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceCloturer(String id_u) async {
    final ids_a = await supabaseClient.from('REPONDS').select().eq('id_user', id_u);
    if (ids_a.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    final response = await supabaseClient.from('ANNONCES').select().inFilter('id', ids_a.map((e) => e['id_a']).where((e) => e['id_etat'] == 3).toList());
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

  static Future<String> getAuteurAnnonce(String id) async {
    final response = await supabaseClient.from('PUBLIE').select().eq('id_a', id);
    if (response.isEmpty) {
      throw Exception('Failed to get auteur');
    }
    return response[0]['id_user'];
  }

  static Future<void> accepterAnnonce(String id_a, String id_user) async {
    await supabaseClient.from('REPONDS').insert({
      'id_a': id_a,
      'id_user': id_user,
    });
  }

  static Future<void> updateAnnonceEtat(String id, int etat) async {
    await supabaseClient.from('ANNONCES').update({'idEtat': etat}).eq('id', id);
  }
}
