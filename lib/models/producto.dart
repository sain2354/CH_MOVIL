
import 'dart:io';

class Producto {
  String? codigoBarra;
  String nombre;
  int? idCategoria;
  String? marca;
  double? precioCompra;
  double precioVenta;
  int stock;
  int? stockMinimo;
  int? idUnidadMedida;
  bool estado;
  String? genero;
  String? articulo;
  String? estilo;
  String? mpn;
  String? material;
  String? color;
  List<SizeWithStock> sizes;
  File? imagen;

  Producto({
    this.codigoBarra,
    required this.nombre,
    this.idCategoria,
    this.marca,
    this.precioCompra,
    required this.precioVenta,
    required this.stock,
    this.stockMinimo,
    this.idUnidadMedida,
    this.estado = true,
    this.genero,
    this.articulo,
    this.estilo,
    this.mpn,
    this.material,
    this.color,
    required this.sizes,
    this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigoBarra: json['codigoBarra'],
      nombre: json['nombre'],
      idCategoria: json['idCategoria'],
      marca: json['marca'],
      precioCompra: json['precioCompra']?.toDouble(),
      precioVenta: json['precioVenta'].toDouble(),
      stock: json['stock'],
      stockMinimo: json['stockMinimo'],
      idUnidadMedida: json['idUnidadMedida'],
      estado: json['estado'],
      genero: json['genero'],
      articulo: json['articulo'],
      estilo: json['estilo'],
      mpn: json['mpn'],
      material: json['material'],
      color: json['color'],
      sizes: (json['sizes'] as List? ?? []).map((s) => SizeWithStock.fromJson(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'Nombre': nombre,
      'PrecioVenta': precioVenta,
      'Stock': stock,
      'Estado': estado,
      'Sizes': sizes.map((s) => s.toJson()).toList(),
    };
    if (codigoBarra != null && codigoBarra!.isNotEmpty) data['CodigoBarra'] = codigoBarra;
    if (idCategoria != null) data['IdCategoria'] = idCategoria;
    if (marca != null) data['Marca'] = marca;
    if (precioCompra != null) data['PrecioCompra'] = precioCompra;
    if (stockMinimo != null) data['StockMinimo'] = stockMinimo;
    if (idUnidadMedida != null) data['IdUnidadMedida'] = idUnidadMedida;
    if (genero != null) data['Genero'] = genero;
    if (articulo != null) data['Articulo'] = articulo;
    if (estilo != null) data['Estilo'] = estilo;
    if (mpn != null) data['Mpn'] = mpn;
    if (material != null) data['Material'] = material;
    if (color != null) data['Color'] = color;
    return data;
  }
}

class SizeWithStock {
  int? idTalla;
  String? usa;
  String? eur;
  String? cm;
  int stock;

  SizeWithStock({
    this.idTalla,
    this.usa,
    this.eur,
    this.cm,
    required this.stock,
  });

  factory SizeWithStock.fromJson(Map<String, dynamic> json) {
    return SizeWithStock(
      idTalla: json['idTalla'],
      usa: json['usa']?.toString(),
      eur: json['eur']?.toString(),
      cm: json['cm']?.toString(),
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdTalla': idTalla,
      'Usa': usa,
      'Eur': eur,
      'Cm': cm,
      'Stock': stock,
    };
  }
}
