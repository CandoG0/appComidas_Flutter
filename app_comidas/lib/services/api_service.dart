import 'dart:convert' show json;
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // Cambia si es necesario
  
  // Obtener locales
  static Future<List<dynamic>> getLocales() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/local'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getLocales: $e');
      rethrow;
    }
  }
  
  // NUEVO: Obtener platillos por local
  static Future<List<dynamic>> getPlatillosByLocal(int localId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/platillos/local/$localId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Si tu API devuelve un objeto con 'data', accede a él
        if (data is Map && data.containsKey('data')) {
          return data['data'];
        }
        return data;
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getPlatillosByLocal: $e');
      rethrow;
    }
  }
  
  // NUEVO: Obtener categorías
  static Future<List<dynamic>> getCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categorias'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Si tu API devuelve un objeto con 'data', accede a él
        if (data is Map && data.containsKey('data')) {
          return data['data'];
        }
        return data;
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getCategorias: $e');
      rethrow;
    }
  }
}