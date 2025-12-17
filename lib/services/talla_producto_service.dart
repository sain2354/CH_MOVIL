
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ch_movil/models/talla_producto.dart';

class TallaProductoService {
  final String _baseUrl = 'https://www.chbackend.somee.com/api/TallaProducto';

  Future<List<TallaProducto>> getTallasByProducto(int idProducto) async {
    final url = Uri.parse('$_baseUrl/porProducto/$idProducto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TallaProducto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tallas for a product');
    }
  }
}
