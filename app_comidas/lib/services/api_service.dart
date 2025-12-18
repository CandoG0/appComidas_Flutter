import 'dart:convert' show json;

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';
  
  // SOLO ESTE MÉTODO ES NECESARIO
  static Future<List<dynamic>> getLocales() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/local'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
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

}