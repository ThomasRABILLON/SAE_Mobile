import 'package:sae_mobile/models/queries/userQueries.dart';
import 'package:sae_mobile/models/queries/annonceQueries.dart';

import 'package:sae_mobile/models/user.dart' as user_model;
import 'package:sae_mobile/models/annonce.dart';

class Builder {
  static Future<user_model.User> buildUserById(String id) async {
    final data = await UserQueries.getUserById(id).then((value) => value.first);

    return user_model.User.fromJson(data);
  }

  static Future<Annonce> buildAnnonceById(String id) async {
    final user_model.User auteur = await buildUserById(AnnonceQueries.getAnnonceUserPublieById(id) as String);
    final String repondId = AnnonceQueries.getAnnonceUserRepondById(id) as String;

    if (repondId.isEmpty) {
      final user_model.User repond = await buildUserById(repondId);
      final data = await AnnonceQueries.getAnnonceById(id).then((value) => value.first);
      return Annonce.fromJson(data, auteur, repondant: repond);
    }

    final data = await AnnonceQueries.getAnnonceById(id).then((value) => value.first);
    return Annonce.fromJson(data, auteur);
  }

  static Future<List<Annonce>> buildAnnonces() async {
    final data = await AnnonceQueries.getAnnonces();
    final List<Annonce> annonces = [];

    for (var annonce in data) {
      final user_model.User auteur = await buildUserById(AnnonceQueries.getAnnonceUserPublieById(annonce['id'] as String) as String);
      final String repondId = AnnonceQueries.getAnnonceUserRepondById(annonce['id'] as String) as String;

      if (repondId.isEmpty) {
        final user_model.User repond = await buildUserById(repondId);
        annonces.add(Annonce.fromJson(annonce, auteur, repondant: repond));
      } else {
        annonces.add(Annonce.fromJson(annonce, auteur));
      }
    }

    return annonces;
  }
}