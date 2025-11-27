import './api_service.dart';

class LocalService {
  // Obtener todos los locales activos
  static Future<List<Map<String, dynamic>>> getLocales() async {
    try {
      print('🔄 Iniciando obtención de locales...');
      final results = await ApiService.getLocales();
      print('✅ Datos crudos recibidos de API: ${results.length} elementos');

      final transformedResults = results.map<Map<String, dynamic>>((local) {
        print('📝 Procesando local: ${local['loc_nombre']}');

        return {
          'id': local['loc_id'],
          'title': local['loc_nombre'],
          'description': local['loc_descripcion'] ?? 'Sin descripción',
          'telefono': local['loc_telefono'],
          'horario': '${local['loc_inicio']} - ${local['loc_final']}',
          'domicilio': local['loc_domicilio'],
          'tiempo': _calcularTiempoEstimado(
            local['loc_inicio'],
            local['loc_final'],
          ),
          'rating': '4.5',
          'image': _getLocalImage(local['loc_nombre']),
        };
      }).toList();

      print(
        '🎉 Transformación completada: ${transformedResults.length} locales',
      );
      return transformedResults;
    } catch (e) {
      print('💥 Error crítico en getLocales: $e');

      // Datos de respaldo temporal
      print('🆘 Usando datos de respaldo...');
      await Future.delayed(Duration(seconds: 2));

      return [
        {
          'id': 1,
          'title': 'Tacos Don José',
          'description': 'Los mejores tacos de la ciudad - DATOS DE RESPAldo',
          'telefono': '555-1234',
          'horario': '08:00 - 22:00',
          'domicilio': 'Av. Principal #123',
          'tiempo': '15-30 min',
          'rating': '4.5',
          'image':
              'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Tacos',
        },
        {
          'id': 2,
          'title': 'Pizza Italiana',
          'description': 'Auténtica pizza italiana - DATOS DE RESPAldo',
          'telefono': '555-5678',
          'horario': '10:00 - 23:00',
          'domicilio': 'Calle Secundaria #456',
          'tiempo': '20-40 min',
          'rating': '4.3',
          'image':
              'https://via.placeholder.com/300x200/FDBF50/2A2C41?text=Pizza',
        },
      ];
    }
  }

  // Buscar locales por nombre o descripción
  static Future<List<Map<String, dynamic>>> searchLocales(String query) async {
    try {
      final results = await ApiService.searchLocales(query);

      return results.map<Map<String, dynamic>>((local) {
        return {
          'id': local['loc_id'],
          'title': local['loc_nombre'],
          'description': local['loc_descripcion'] ?? 'Sin descripción',
          'telefono': local['loc_telefono'],
          'horario': '${local['loc_inicio']} - ${local['loc_final']}',
          'domicilio': local['loc_domicilio'],
          'tiempo': _calcularTiempoEstimado(
            local['loc_inicio'],
            local['loc_final'],
          ),
          'rating': '4.5',
          'image': _getLocalImage(local['loc_nombre']),
        };
      }).toList();
    } catch (e) {
      print('Error buscando locales: $e');
      return [];
    }
  }

  // Métodos auxiliares (los mantienes igual)
  static String _calcularTiempoEstimado(String inicio, String finalHorario) {
    try {
      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      if (_compareTime(currentTime, inicio) < 0) {
        return '30-45 min';
      } else if (_compareTime(currentTime, finalHorario) > 0) {
        return 'Cerrado';
      } else {
        return '15-30 min';
      }
    } catch (e) {
      return '20-35 min';
    }
  }

  static int _compareTime(String time1, String time2) {
    final parts1 = time1.split(':');
    final parts2 = time2.split(':');

    final hour1 = int.parse(parts1[0]);
    final minute1 = int.parse(parts1[1]);
    final hour2 = int.parse(parts2[0]);
    final minute2 = int.parse(parts2[1]);

    if (hour1 != hour2) {
      return hour1 - hour2;
    }
    return minute1 - minute2;
  }

  static String _getLocalImage(String nombre) {
    final imageMap = {
      'taco': 'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Tacos',
      'burger': 'https://via.placeholder.com/300x200/FDBF50/2A2C41?text=Burger',
      'pizza': 'https://via.placeholder.com/300x200/2A2C41/F4F4F8?text=Pizza',
      'sushi': 'https://via.placeholder.com/300x200/F4F4F8/2A2C41?text=Sushi',
      'mari':
          'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Doña+Mari',
    };

    final lowerNombre = nombre.toLowerCase();

    for (final key in imageMap.keys) {
      if (lowerNombre.contains(key)) {
        return imageMap[key]!;
      }
    }

    return 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=${Uri.encodeComponent(nombre)}';
  }
}
