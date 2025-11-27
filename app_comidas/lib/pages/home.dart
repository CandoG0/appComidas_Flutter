import 'package:app_comidas/pages/perfil.dart' show PerfilScreen;
import 'package:flutter/material.dart';
import '../services/local_service.dart'; // Cambiado a local_service
import 'local.dart'; // Tu pantalla de locales
import 'perfil.dart'; // Tu nueva pantalla de perfil

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final SearchController _searchController = SearchController();
  final Color primaryColor = const Color(0xFFFF724C);
  final Color textColor = const Color(0xFF2A2C41);
  final Color backgroundColor = const Color(0xFFF4F4F8);

  List<Map<String, dynamic>> _locales = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLocales();
  }

  // Cargar locales desde la API
  void _loadLocales() async {
    try {
      final locales =
          await LocalService.getLocales(); // Cambiado a LocalService
      setState(() {
        _locales = locales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error cargando locales: $e';
        _isLoading = false;
      });
    }
  }

  // Buscar locales
  void _searchLocales(String query) async {
    if (query.isEmpty) {
      _loadLocales(); // Recargar todos si la búsqueda está vacía
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final resultados = await LocalService.searchLocales(
        query,
      ); // Cambiado a LocalService
      setState(() {
        _locales = resultados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error buscando locales: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredLocales {
    return _locales;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (value) {
                  _searchLocales(value);
                },
                leading: Icon(Icons.search, color: primaryColor),
                trailing: [
                  if (controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        controller.clear();
                        _loadLocales(); // Recargar todos los locales
                        setState(() {});
                      },
                      icon: Icon(Icons.close, color: primaryColor),
                    ),
                ],
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                shadowColor: WidgetStatePropertyAll(textColor.withOpacity(0.1)),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return _locales
                      .where((local) {
                        final title = local['title'].toString().toLowerCase();
                        final searchText = controller.text.toLowerCase();
                        return title.contains(searchText);
                      })
                      .map((local) {
                        return ListTile(
                          title: Text(
                            local['title'],
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            local['description'],
                            style: TextStyle(color: textColor.withOpacity(0.7)),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                local['tiempo'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              controller.closeView(local['title']);
                            });
                          },
                        );
                      });
                },
          ),
        ),

        // Indicador de resultados
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isLoading)
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cargando locales...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                )
              else if (_errorMessage.isNotEmpty)
                Expanded(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                Text(
                  _searchController.text.isEmpty
                      ? 'Locales disponibles (${_locales.length})'
                      : 'Resultados: ${_locales.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              if (_searchController.text.isNotEmpty && !_isLoading)
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    _loadLocales();
                    setState(() {});
                  },
                  child: Text('Limpiar', style: TextStyle(color: primaryColor)),
                ),
            ],
          ),
        ),

        // Lista de tarjetas
        Expanded(
          child: _isLoading
              ? _buildLoadingState()
              : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _filteredLocales.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredLocales.length,
                  itemBuilder: (context, index) {
                    return _buildLocalCard(_filteredLocales[index]);
                  },
                ),
        ),
      ],
    );
  }

  // Estado de carga
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando locales...',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Estado de error
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Error de conexión',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadLocales,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // Estado cuando no hay resultados
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: textColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No se encontraron locales',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'No hay locales disponibles en este momento'
                : 'No se encontraron resultados para "${_searchController.text}"',
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.4)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Tarjeta de local individual
  Widget _buildLocalCard(Map<String, dynamic> local) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del local
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              local['image'],
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  color: backgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: const Color(0xFFFDBF50).withOpacity(0.1),
                  child: Icon(Icons.store, size: 50, color: primaryColor),
                );
              },
            ),
          ),

          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  local['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 8),

                // Descripción
                Text(
                  local['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Información adicional
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horario
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: textColor.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Horario: ${local['horario']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Tiempo estimado
                    Row(
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          size: 16,
                          color: textColor.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tiempo estimado: ${local['tiempo']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    if (local['domicilio'] != null) ...[
                      const SizedBox(height: 4),
                      // Domicilio
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: textColor.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${local['domicilio']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla Local pasando el ID
/*                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LocalScreen(localId: local['id']),
                        ),
                      ); */
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Visitar Local',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
