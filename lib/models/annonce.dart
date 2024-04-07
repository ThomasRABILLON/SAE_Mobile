import 'package:sae_mobile/models/User.dart';
import 'package:sae_mobile/models/queries/distant/annonce.dart' as dist;
import 'package:sae_mobile/models/queries/local/annonce.dart' as local;

class Annonce {
  final String id;
  final String titre;
  final String description;
  final DateTime dateDeb;
  final DateTime dateFin;
  final User auteur;
  late final int etat;
  late AnnonceController controller;

  Annonce(this.id, this.titre, this.description, this.dateDeb, this.dateFin,
      this.auteur, this.etat) {
    switch (etat) {
      case 1:
        controller = AnnonceController(this, AnnonceNonPublie());
        break;
      case 2:
        controller = AnnonceController(this, AnnonceNonRepondu());
        break;
      case 3:
        controller = AnnonceController(this, AnnonceRepondu());
        break;
      case 4:
        controller = AnnonceController(this, AnnonceCloture());
        break;
    }
  }

  factory Annonce.fromJson(Map<String, dynamic> json, User auteur) {
    print(json);
    return Annonce(
      json['id'],
      json['titre'],
      json['description'],
      DateTime.parse(json['dateDeb']),
      DateTime.parse(json['dateFin']),
      auteur,
      json['idEtat'],
    );
  }

  void setEtat(int etat) {
    this.etat = etat;
  }

  void publier() {
    controller.publier();
  }

  void repondre(String id_u) {
    print(controller.etat);
    controller.repondre(id_u);
  }

  void cloturer() {
    controller.cloturer();
  }

  Future<void> mettreAvis(String id_u, String avis) async {
    controller.mettreAvis(id_u, avis);
  }
}

class AnnonceController {
  final Annonce annonce;
  late EtatAnnonce etat;

  AnnonceController(this.annonce, this.etat);

  void setEtat(EtatAnnonce etat) {
    this.etat = etat;
  }

  void publier() {
    etat.publier(this.annonce);
  }

  void repondre(String id_u) {
    etat.repondre(this.annonce, id_u);
  }

  void cloturer() {
    etat.cloturer(this.annonce);
  }

  void mettreAvis(String id_u, String avis) {
    etat.mettreAvis(this.annonce, id_u, avis);
  }
}

class EtatAnnonce {
  void publier(Annonce a) async {}

  void repondre(Annonce a, String id_u) async {}

  void cloturer(Annonce a) async {}

  void mettreAvis(Annonce a, String id_u, String avis) async {}
}

class AnnonceNonPublie extends EtatAnnonce {
  @override
  void publier(Annonce a) async {
    await local.AnnonceQueries.updateAnnonceEtat(a.id, 2);
    String newId = await dist.AnnonceQueries.publishAnnonce(a);
    await local.AnnonceQueries.updateAnnonceId(a.id, newId);
    a.controller.setEtat(AnnonceNonRepondu());
  }
}

class AnnonceNonRepondu extends EtatAnnonce {
  @override
  void repondre(Annonce a, String id_u) async {
    await dist.AnnonceQueries.accepterAnnonce(a.id, id_u);
    await local.AnnonceQueries.updateAnnonceEtat(a.id, 3);
    await dist.AnnonceQueries.updateAnnonceEtat(a.id, 3);
    a.controller.setEtat(AnnonceRepondu());
  }
}

class AnnonceRepondu extends EtatAnnonce {
  @override
  void cloturer(Annonce a) async {
    await local.AnnonceQueries.updateAnnonceEtat(a.id, 4);
    await dist.AnnonceQueries.updateAnnonceEtat(a.id, 4);
    a.controller.setEtat(AnnonceCloture());
  }
}

class AnnonceCloture extends EtatAnnonce {
  @override
  void mettreAvis(Annonce a, String id_u, String avis) async {
    await dist.AnnonceQueries.mettreAvis(a.id, id_u, avis);
  }
}
