import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.14:8080';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtener todos los locales
  static Future<List<dynamic>> getLocales() async {
    try {
      print('🔗 Conectando a: $baseUrl/locales');

      final response = await http
          .get(Uri.parse('$baseUrl/locales'), headers: headers)
          .timeout(Duration(seconds: 10));

      print('✅ Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Locales recibidos: ${data.length}');
        return data;
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getLocales: $e');
      rethrow;
    }
  }

  // Buscar locales
  static Future<List<dynamic>> searchLocales(String query) async {
    try {
      final url =
          '$baseUrl/locales/search?q=${Uri.encodeQueryComponent(query)}';
      print('🔍 Buscando: $url');

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: 10));

      print('✅ Búsqueda completada: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Resultados encontrados: ${data.length}');
        return data;
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en searchLocales: $e');
      rethrow;
    }
  }

  // Obtener local por ID (si lo necesitas después)
  static Future<Map<String, dynamic>?> getLocalById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/locales/$id'), headers: headers)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getLocalById: $e');
      rethrow;
    }
  }
}
