
class Categoria {
  final int idCategoria;
  final String descripcion;

  Categoria({required this.idCategoria, required this.descripcion});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idCategoria'],
      descripcion: json['descripcion'],
    );
  }
}
