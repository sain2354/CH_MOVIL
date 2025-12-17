
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ch_movil/models/producto.dart';

class ProductoService {
  final String _baseUrl = 'https://www.chbackend.somee.com/api/Producto';

  Future<Producto> getProductoByBarcode(String barcode) async {
    final url = Uri.parse('$_baseUrl/$barcode');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Producto no encontrado');
    } else {
      throw Exception('Error al buscar el producto: ${response.body}');
    }
  }

  Future<void> agregarStock(String codigoBarra, List<Map<String, int>> tallasStock) async {
    final url = Uri.parse('$_baseUrl/add-stock');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'codigoBarra': codigoBarra,
        'tallas': tallasStock,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el stock: ${response.body}');
    }
  }

  Future<Producto> crearProducto(Producto producto) async {
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<Producto> crearProductoConArchivo(Producto producto, File imagen) async {
    final url = Uri.parse('$_baseUrl/createWithFile');
    final request = http.MultipartRequest('POST', url);

    // Add fields
    request.fields['Nombre'] = producto.nombre;
    request.fields['PrecioVenta'] = producto.precioVenta.toString();
    request.fields['Stock'] = producto.stock.toString();
    request.fields['Estado'] = producto.estado.toString();

    if (producto.codigoBarra != null) request.fields['CodigoBarra'] = producto.codigoBarra!;
    if (producto.idCategoria != null) request.fields['IdCategoria'] = producto.idCategoria.toString();
    if (producto.marca != null) request.fields['Marca'] = producto.marca!;
    if (producto.precioCompra != null) request.fields['PrecioCompra'] = producto.precioCompra.toString();
    if (producto.stockMinimo != null) request.fields['StockMinimo'] = producto.stockMinimo.toString();
    if (producto.idUnidadMedida != null) request.fields['IdUnidadMedida'] = producto.idUnidadMedida.toString();
    if (producto.genero != null) request.fields['Genero'] = producto.genero!;
    if (producto.articulo != null) request.fields['Articulo'] = producto.articulo!;
    if (producto.estilo != null) request.fields['Estilo'] = producto.estilo!;
    if (producto.mpn != null) request.fields['Mpn'] = producto.mpn!;
    if (producto.material != null) request.fields['Material'] = producto.material!;
    if (producto.color != null) request.fields['Color'] = producto.color!;

    for (var i = 0; i < producto.sizes.length; i++) {
      request.fields['Sizes[$i].Usa'] = producto.sizes[i].usa ?? '';
      request.fields['Sizes[$i].Eur'] = producto.sizes[i].eur ?? '';
      request.fields['Sizes[$i].Cm'] = producto.sizes[i].cm ?? '';
      request.fields['Sizes[$i].Stock'] = producto.sizes[i].stock.toString();
    }

    // Add image
    if (producto.imagen != null) {
      request.files.add(await http.MultipartFile.fromPath('imagen', producto.imagen!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return Producto.fromJson(json.decode(responseBody));
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create product with file: $responseBody');
    }
  }
}
