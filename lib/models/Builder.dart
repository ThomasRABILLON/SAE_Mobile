import 'package:sae_mobile/models/Objet.dart';
import 'package:sae_mobile/models/TypeAnnonce.dart';
import 'package:sae_mobile/models/annonce.dart';
import 'package:sae_mobile/models/queries/distant/user.dart' as uqd;
import 'package:sae_mobile/models/queries/distant/annonce.dart' as aqd;

import 'package:sae_mobile/models/queries/local/annonce.dart' as aql;
import 'package:sae_mobile/models/queries/local/objet.dart';
import 'package:sae_mobile/models/queries/local/typeAnnonce.dart';

import 'package:sae_mobile/models/User.dart' as user_model;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/models/queries/distant/typeAnnonce.dart' as tqd;

final SupabaseClient supabaseClient = Supabase.instance.client;

/// Classe Builder
///
/// Cette classe permet de construire des objets à partir de données distantes ou locales.
class Builder {
  /// Construit un utilisateur à partir de son id.
  ///
  /// [id] est l'id de l'utilisateur.
  ///
  /// Retourne un objet de type [user_model.User].
  static Future<user_model.User> buildUserById(String id) async {
    final data =
        await uqd.UserQueries.getUserById(id).then((value) => value.first);

    return user_model.User.fromJson(data);
  }

  /// Construit une liste d'annonces à partir de données distantes.
  ///
  /// Retourne une liste d'annonces.
  static Future<List<Annonce>> buildAnnoncesDistant() async {
    final data = await aqd.AnnonceQueries.getAnnonces().then((value) => value);

    List<Annonce> annonces = [];
    for (var annonce in data) {
      String user_id = await aqd.AnnonceQueries.getAuteurAnnonce(annonce['id']);
      annonces.add(Annonce.fromJson(annonce, (await buildUserById(user_id))));
    }

    return annonces;
  }

  static Future<List<Annonce>> buildAnnoncesDistantByType(String type) async {
    final data =
        await aqd.AnnonceQueries.getAnnoncesByType(type).then((value) => value);

    List<Annonce> annonces = [];
    for (var annonce in data) {
      print("les annonces du type $type sont : $annonce");
      String user_id = await aqd.AnnonceQueries.getAuteurAnnonce(annonce['id']);
      annonces.add(Annonce.fromJson(annonce, (await buildUserById(user_id))));
    }

    return annonces;
  }

  /// Construit une liste d'annonces non répondues à partir de données distantes.
  ///
  /// Retourne une liste d'annonces.
  static Future<List<Annonce>> buildAnnoncesDistantNonRepondu() async {
    final data =
        await aqd.AnnonceQueries.getAnnonceNonRepondu().then((value) => value);

    List<Annonce> annonces = [];
    for (var annonce in data) {
      String user_id = await aqd.AnnonceQueries.getAuteurAnnonce(annonce['id']);
      annonces.add(Annonce.fromJson(annonce, (await buildUserById(user_id))));
    }

    return annonces;
  }

  /// Construit une liste d'annonces répondues par l'utilisateur à partir de données distantes.
  ///
  /// [id] est l'id de l'utilisateur.
  ///
  /// Retourne une liste d'annonces.
  static Future<List<Annonce>> buildAnnoncesDistantRepondu(String id) async {
    print("L'id de l'utilisateur est annonce distant repondu : $id");
    final data =
        await aqd.AnnonceQueries.getAnnonceRepondu(id).then((value) => value);

    List<Annonce> annonces = [];
    for (var annonce in data) {
      String user_id = await aqd.AnnonceQueries.getAuteurAnnonce(annonce['id']);
      annonces.add(Annonce.fromJson(annonce, (await buildUserById(user_id))));
    }
    print("Les annonces répondues : $annonces");
    return annonces;
  }

  static Future<List<Annonce>> buildAnnoncesLocalUtilisateur(String id) async {
    final data = await aql.AnnonceQueries.getAnnoncesByUser(id);

    List<Annonce> annonces = [];
    for (var annonce in data) {
      annonces.add(Annonce.fromJson(annonce, await buildUserById(id)));
    }
    print("Les annonces locales : $annonces");
    return annonces;
  }

  /// Construit une liste d'annonces par id de l'annonce à partir de données distantes.
  ///
  /// [id] est l'id de l'annonce.
  ///
  /// Retourne une liste d'annonces.
  static Future<Annonce> buildAnnonceByIdDistant(String id) async {
    final data = await aqd.AnnonceQueries.getAnnonceById(id)
        .then((value) => value.first);

    String user_id = await aqd.AnnonceQueries.getAnnonceById(data['id'])
        .then((value) => value.first['id_user']);
    return Annonce.fromJson(data, await buildUserById(user_id));
  }

  /// Construit une liste d'annonces à partir de données locales.
  static Future<List<Annonce>> buildAnnoncesLocal() async {
    final data = await aql.AnnonceQueries.getAnnonces().then((value) => value);
    List<Annonce> annonces = [];
    print(data);
    for (var annonce in data) {
      annonces.add(Annonce.fromJson(
          annonce, await buildUserById(supabaseClient.auth.currentUser!.id)));
    }

    return annonces;
  }

  /// Construit une liste d'annonces par id de l'annonce à partir de données locales.
  static Future<Annonce> buildAnnonceByIdLocal(String id) async {
    final data = await aql.AnnonceQueries.getAnnonceById(id);

    return Annonce.fromJson(
        data, await buildUserById(supabaseClient.auth.currentUser!.id));
  }

  /// Construit une liste d'objets à partir de données locales.
  ///
  /// Retourne une liste d'objets.
  static Future<List<Objet>> buildObjets() async {
    final data = await ObjetQueries.getObjets().then((value) => value);

    List<Objet> objets = [];
    for (var objet in data) {
      objets.add(Objet.fromJson(objet));
    }

    return objets;
  }

  /// Construit une liste de types d'annonces à partir de données locales.
  ///
  /// Retourne une liste de types d'annonces.
  static Future<List<TypeAnnonce>> buildTypesAnnonce() async {
    final data =
        await TypeAnnoncesQueries.getTypeAnnonces().then((value) => value);

    List<TypeAnnonce> typesAnnonce = [];
    for (var typeAnnonce in data) {
      print('la categorie est : $typeAnnonce');
      typesAnnonce.add(TypeAnnonce.fromJson(typeAnnonce));
    }

    return typesAnnonce;
  }

  static Future<List<TypeAnnonce>> buildTypesAnnonceDistant() async {
    final data =
        await tqd.TypeAnnonceQueries.getTypeAnnonces().then((value) => value);

    List<TypeAnnonce> typesAnnonce = [];
    for (var typeAnnonce in data) {
      print(typeAnnonce);
      typesAnnonce.add(TypeAnnonce.fromJson(typeAnnonce));
    }

    return typesAnnonce;
  }
}
