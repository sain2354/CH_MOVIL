
class Talla {
  final int idTalla;
  final String categoria;
  final String usa;
  final String eur;
  final String cm;

  Talla({
    required this.idTalla,
    required this.categoria,
    required this.usa,
    required this.eur,
    required this.cm,
  });

  factory Talla.fromJson(Map<String, dynamic> json) {
    return Talla(
      idTalla: json['idTalla'],
      categoria: json['categoria'] as String,
      usa: json['usa'].toString(),
      eur: json['eur'].toString(),
      cm: json['cm'].toString(),
    );
  }
}
