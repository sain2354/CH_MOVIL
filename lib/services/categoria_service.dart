
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ch_movil/models/categoria.dart';

class CategoriaService {
  final String _baseUrl = 'https://www.chbackend.somee.com/api/Categoria';

  Future<List<Categoria>> getAll() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
