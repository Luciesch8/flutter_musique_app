class Master {
  final int id;
  final String annee;
  final String nom;
  final String vignette;

  Master(
      {required this.id,
      required this.nom,
      required this.vignette,
      required this.annee});

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      id: json['id'],
      nom: json['title'],
      vignette: json['thumb'],
      annee: json['year'].toString(),
    );
  }
}
