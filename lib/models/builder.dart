import 'package:sae_mobile/models/queries/userQueries.dart';
import 'package:sae_mobile/models/queries/annonceQueries.dart';

import 'package:sae_mobile/models/user.dart' as user_model;
import 'package:sae_mobile/models/annonce.dart';

class Builder {
  static Future<user_model.User> buildUserById(String id) async {
    final data = await UserQueries.getUserById(id).then((value) => value.first);

    return user_model.User.fromJson(data);
  }

  static Future<List<Annonce>> buildAnnonces(String id) async {
    final data = await AnnonceQueries.getAnnonces().then((value) => value);

    List<Annonce> annonces = [];
    for (var annonce in data) {
      print(annonce);
      String user_id = await AnnonceQueries.getAnnonceUserPublieById(annonce['id']);
      annonces.add(Annonce.fromJson(annonce, await buildUserById(user_id), 0));
    }

    return annonces;
  }
}