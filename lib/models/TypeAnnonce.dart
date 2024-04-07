class TypeAnnonce {
  int id;
  String libelle;

  TypeAnnonce({required this.id, required this.libelle});

  factory TypeAnnonce.fromJson(Map<String, dynamic> json) {
    return TypeAnnonce(
      id: json['idType'],
      libelle: json['libelleType'],
    );
  }
}