import 'package:sae_mobile/models/annonce.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseClient = Supabase.instance.client;

class AnnonceQueries {
  static Future<String> publishAnnonce(Annonce annonce) async {
    print("publishAnnonce");
    print(annonce.dateDeb.toIso8601String());
    print(annonce.dateFin.toIso8601String());
    print(annonce.titre);
    PostgrestList result = await supabaseClient.from('ANNONCES').insert({
      'titre': annonce.titre,
      'description': annonce.description,
      'dateDeb': annonce.dateDeb.toIso8601String(),
      'dateFin': annonce.dateFin.toIso8601String(),
      'idType': 2,
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

  static Future<PostgrestList> getAnnoncesByType(String id) async {
    final response =
        await supabaseClient.from('ANNONCES').select().eq('idType', id);
    if (response.isEmpty) {
      throw Exception('Aucune annonce de ce type');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceNonRepondu() async {
    final response =
        await supabaseClient.from('ANNONCES').select().eq('idEtat', 2);
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceRepondu(String id_u) async {
    final ids_a =
        await supabaseClient.from('REPONDS').select().eq('id_user', id_u);
    if (ids_a.isEmpty) {
      throw Exception("Pas d'annonces repondues");
    }
    final response = await supabaseClient
        .from('ANNONCES')
        .select()
        .inFilter('id', ids_a.map((e) => e['id_a']).toList());
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceCloturer(String id_u) async {
    final ids_a =
        await supabaseClient.from('REPONDS').select().eq('id_user', id_u);
    if (ids_a.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    final response = await supabaseClient.from('ANNONCES').select().inFilter(
        'id',
        ids_a.map((e) => e['id_a']).where((e) => e['id_etat'] == 3).toList());
    if (response.isEmpty) {
      throw Exception('Failed to get annonces');
    }
    return response;
  }

  static Future<PostgrestList> getAnnonceById(String id) async {
    final response =
        await supabaseClient.from('ANNONCES').select().eq('id', id);
    if (response.isEmpty) {
      throw Exception('Failed to get annonce');
    }
    return response;
  }

  static Future<String> getAuteurAnnonce(String id) async {
    final response =
        await supabaseClient.from('PUBLIE').select().eq('id_a', id);
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

  static Future<void> mettreAvis(String id_a, String id_u, String avis) async {
    print(id_a);
    print(id_u);
    final existingReview = await supabaseClient
        .from('AVIS')
        .select()
        .eq('id_a', id_a)
        .eq('id_user', id_u);

    if (existingReview.isNotEmpty) {
      throw Exception('Vous avez déjà soumis un avis pour cette annonce.');
    }
    await supabaseClient.from('AVIS').insert({
      'id_a': id_a,
      'id_user': id_u,
      'avis': avis,
    });
  }

  static Future<PostgrestList> getAnnonceAvis(String id_a) async {
    final response = await supabaseClient
        .from('AVIS')
        .select('avis, users:id_user (username)')
        .eq('id_a', id_a);
    return response;
  }
}
