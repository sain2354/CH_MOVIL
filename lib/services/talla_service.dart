
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ch_movil/models/talla.dart';

class TallaService {
  final String _baseUrl = 'https://www.chbackend.somee.com/api/Talla';

  Future<List<Talla>> getTallas([String? categoria]) async {
    String url = _baseUrl;
    if (categoria != null && categoria.isNotEmpty) {
      url += '?categoria=${Uri.encodeComponent(categoria)}';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Talla.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tallas');
    }
  }
}
