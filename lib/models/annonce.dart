import 'package:sae_mobile/models/user.dart';
import 'package:sae_mobile/models/queries/annonceQueries.dart';

class Annonce {
  final String id;
  final String title;
  final String description;
  final DateTime dateDeb;
  final DateTime dateFin;
  final User auteur;
  late final User? repondant;
  late final ControllerAnnonce controller;

  Annonce({
    required this.id,
    required this.title,
    required this.description,
    required this.dateDeb,
    required this.dateFin,
    required this.auteur,
    this.repondant,
  }) {
    controller = ControllerAnnonce(this, AnnonceEnValidation());
  }

  factory Annonce.fromJson(Map<String, dynamic> json, User auteur, {User? repondant}) {
    return Annonce(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateDeb: DateTime.parse(json['dateDeb'] as String),
      dateFin: DateTime.parse(json['dateFin'] as String),
      auteur: auteur,
      repondant: repondant,
    );
  }

  void setPreteur(User repondant) {
    this.repondant = repondant;
  }

  ControllerAnnonce getController(EtatAnnonce etat) {
    return ControllerAnnonce(this, etat);
  }

  void valider() {
    controller.valider();
  }

  void accepter(User repondant) {
    controller.accepter(repondant);
  }

  void cloturer() {
    controller.cloturer();
  }
}

class ControllerAnnonce {
  final Annonce annonce;
  late final EtatAnnonce etat;

  const ControllerAnnonce(this.annonce, this.etat);

  void setEtat(EtatAnnonce etat) {
    this.etat = etat;
  }

  void valider() {
    etat.valider(annonce);
  }

  void accepter(User repondant) {
    etat.accepter(annonce, repondant);
  }

  void cloturer() {
    etat.cloturer(annonce);
  }
}

abstract class EtatAnnonce {
  void valider(Annonce annonce);
  void accepter(Annonce annonce, User repondant);
  void cloturer(Annonce annonce);
}

class AnnonceEnValidation implements EtatAnnonce {
  @override
  void valider(Annonce annonce) {
    AnnonceQueries.createAnnonce(
      title: annonce.title,
      description: annonce.description,
      dateDeb: annonce.dateDeb,
      dateFin: annonce.dateFin,
    );
    annonce.get
  }

  @override
  void accepter(Annonce annonce, User repondant) {
    throw Exception("Impossible d'accepter une annonce en attente");
  }

  @override
  void cloturer(Annonce annonce) {
    throw Exception("Impossible de cloturer une annonce en attente");
  }
}

class AnnonceEnAttenteAcceptation implements EtatAnnonce {
  @override
  void valider(Annonce annonce) {
    throw Exception("Impossible de valider une annonce en attente d'acceptation");
  }

  @override
  void accepter(Annonce annonce, User repondant) {
    AnnonceQueries.accepterAnnonce(annonce.id, annonce.repondant!.id);
  }

  @override
  void cloturer(Annonce annonce) {
    throw Exception("Impossible de cloturer une annonce en attente d'acceptation");
  }
}

class AnnonceAcceptee implements EtatAnnonce {
  @override
  void valider(Annonce annonce) {
    throw Exception("Impossible de valider une annonce déjà acceptée");
  }

  @override
  void accepter(Annonce annonce, User repondant) {
    throw Exception("Impossible d'accepter une annonce déjà acceptée");
  }

  @override
  void cloturer(Annonce annonce) {
    AnnonceQueries.cloturerAnnonce(annonce.id);
  }
}