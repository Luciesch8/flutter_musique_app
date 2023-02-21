class Artist {
  final int id;
  final String nom;
  final String vignette;

  Artist({required this.id, required this.nom, required this.vignette});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      nom: json['title'],
      vignette: json['thumb'],
    );
  }
}
