class Objet {
  int id;
  String nom;

  Objet({required this.id, required this.nom});

  factory Objet.fromJson(Map<String, dynamic> json) {
    return Objet(
      id: json['idObj'],
      nom: json['nom'],
    );
  }
}