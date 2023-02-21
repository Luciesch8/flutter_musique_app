class Version {
  final int id;
  final String label;
  final String country;
  final String format;
  final String vignette;

  Version(
      {required this.id,
      required this.label,
      required this.country,
      required this.format,
      required this.vignette});

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      id: json['id'],
      label: json['label'],
      country: json['country'],
      format: json['format'],
      vignette: json['thumb'].toString(),
    );
  }
}
