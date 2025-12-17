
class TallaProducto {
  final int idTalla;
  final String usa;
  final String eur;
  final String cm;
  final int stock;

  TallaProducto({
    required this.idTalla,
    required this.usa,
    required this.eur,
    required this.cm,
    required this.stock,
  });

  factory TallaProducto.fromJson(Map<String, dynamic> json) {
    return TallaProducto(
      idTalla: json['idTalla'],
      usa: json['usa'],
      eur: json['eur'],
      cm: json['cm'],
      stock: json['stock'],
    );
  }
}
