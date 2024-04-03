import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/models/queries/annonceQueries.dart';

class Annonce {
  final String id;
  final String titre;
  final String description;
  final DateTime dateDeb;
  final DateTime dateFin;
  final User auteur;
  late final int etat;
  late AnnonceController controller;

  Annonce(this.id, this.titre, this.description, this.dateDeb, this.dateFin, this.auteur, this.etat) {
    controller = AnnonceController(this, AnnonceNonPublie());
  }

  factory Annonce.fromJson(Map<String, dynamic> json, User auteur) {
    return Annonce(
      json['id'],
      json['titre'],
      json['description'],
      DateTime.parse(json['dateDeb']),
      DateTime.parse(json['dateFin']),
      auteur,
      json['etat'],
    );
  }

  void setEtat(int etat) {
    this.etat = etat;
  }

  void publier() {
    controller.publier();
  }

  void repondre() {
    controller.repondre();
  }

  void cloturer() {
    controller.cloturer();
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

  void repondre() {
    etat.repondre(this.annonce);
  }

  void cloturer() {
    etat.cloturer(this.annonce);
  }
}

class EtatAnnonce {
  void publier(Annonce a) async {}

  void repondre(Annonce a) async {}

  void cloturer(Annonce a) async {}
}

class AnnonceNonPublie extends EtatAnnonce {
  @override
  void publier(Annonce a) async {
    a.setEtat(2);
    await AnnonceQueries.createAnnonce(a.titre, a.description, a.dateDeb, a.dateFin, a.auteur);
    a.controller.setEtat(AnnonceNonRepondu());
  }

  @override
  void repondre(Annonce a) async {
    // repondre à l'annonce
  }

  @override
  void cloturer(Annonce a) async {
    // supprimer l'annonce
  }
}

class AnnonceNonRepondu extends EtatAnnonce {
  @override
  void publier(Annonce a) async {
    // publier l'annonce
  }

  @override
  void repondre(Annonce a) async {
    // repondre à l'annonce
  }

  @override
  void cloturer(Annonce a) async {
    // supprimer l'annonce
  }
}

class AnnonceRepondu extends EtatAnnonce {
  @override
  void publier(Annonce a) async {
    // publier l'annonce
  }

  @override
  void repondre(Annonce a) async {
    // repondre à l'annonce
  }

  @override
  void cloturer(Annonce a) async {
    // supprimer l'annonce
  }
}