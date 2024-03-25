import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/models/queries/annonceQueries.dart';

class Annonce {
  final String id;
  final String titre;
  final String description;
  final DateTime dateDeb;
  final DateTime dateFin;
  final User auteur;
  final User? repondant;
  late AnnonceController controller;

  Annonce(this.id, this.titre, this.description, this.dateDeb, this.dateFin, this.auteur, int etat, {this.repondant}) {
    switch(etat) {
      case 0:
        controller = AnnonceController(this, AnnonceNonPublie());
        break;
      case 1:
        controller = AnnonceController(this, AnnonceNonRepondu());
        break;
      case 2:
        controller = AnnonceController(this, AnnonceRepondu());
        break;
    }
  }


  factory Annonce.fromJson(Map<String, dynamic> data, User auteur, int etat, {User? repondant}) {
    return Annonce(
      data['id'] as String,
      data['titre'] as String,
      data['description'] as String,
      DateTime.parse(data['date_deb'] as String),
      DateTime.parse(data['date_fin'] as String),
      auteur,
      etat,
      repondant: repondant,
    );
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