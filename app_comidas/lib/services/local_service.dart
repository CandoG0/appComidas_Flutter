import 'package:app_comidas/services/api_service.dart';

class LocalService {
  // Solo transformar los datos
  static Future<List<Map<String, dynamic>>> getLocales() async {
    try {
      final results = await ApiService.getLocales();
      
      return results.map<Map<String, dynamic>>((local) {
        return {
          'id': local['loc_id'] ?? local['id'],
          'title': local['loc_nombre'] ?? local['nombre'],
          'description': local['loc_descripcion'] ?? 'Sin descripción',
          'telefono': local['loc_telefono'],
          'horario': '${local['loc_inicio']} - ${local['loc_final']}',
          'domicilio': local['loc_domicilio'],
          'tiempo': '15-30 min', // Fijo por ahora
          'rating': '4.5', // Fijo por ahora
          'image': _getLocalImage(local['loc_nombre'] ?? 'Local'),
        };
      }).toList();
      
    } catch (e) {
      print('Error: $e');
      return []; // Lista vacía si hay error
    }
  }
  
  // Mantener el helper de imagen
  static String _getLocalImage(String nombre) {
    final lower = nombre.toLowerCase();
    
    if (lower.contains('taco') || lower.contains('mexic')) {
      return 'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Tacos';
    } else if (lower.contains('burger') || lower.contains('hamburguesa')) {
      return 'https://via.placeholder.com/300x200/FDBF50/2A2C41?text=Burger';
    } else if (lower.contains('pizza') || lower.contains('ital')) {
      return 'https://via.placeholder.com/300x200/2A2C41/F4F4F8?text=Pizza';
    } else {
      return 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=${Uri.encodeComponent(nombre.split(' ').first)}';
    }
  }
}