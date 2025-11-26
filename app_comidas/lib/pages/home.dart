import 'package:flutter/material.dart';
import 'local.dart'; // Importa la pantalla Local

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final SearchController _searchController = SearchController();
  bool isDark = false;

  // Definición de colores de la paleta
  final Color primaryColor = const Color(0xFFFF724C); // Naranja principal
  final Color secondaryColor = const Color(0xFFFDBF50); // Amarillo
  final Color backgroundColor = const Color(0xFFF4F4F8); // Fondo gris claro
  final Color textColor = const Color(0xFF2A2C41); // Texto oscuro

  // Datos de ejemplo para los locales
  final List<Map<String, dynamic>> _locales = [
    {
      'image':
          'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Doña+Mari',
      'title': 'Local de Doña Mari',
      'description': 'Comida mexicana tradicional - Tacos, quesadillas y más',
      'rating': '4.8',
      'tiempo': '15-20 min',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/FDBF50/2A2C41?text=Burger+House',
      'title': 'Burger House',
      'description': 'Hamburguesas gourmet y papas fritas',
      'rating': '4.5',
      'tiempo': '10-15 min',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/2A2C41/F4F4F8?text=Pizza+Italia',
      'title': 'Pizza Italia',
      'description': 'Pizzas artesanales y pastas frescas',
      'rating': '4.7',
      'tiempo': '20-25 min',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/F4F4F8/2A2C41?text=Sushi+Bar',
      'title': 'Sushi Bar',
      'description': 'Sushi fresco y platos japoneses',
      'rating': '4.9',
      'tiempo': '25-30 min',
    },
  ];

  // Lista filtrada para la búsqueda
  List<Map<String, dynamic>> get _filteredLocales {
    if (_searchController.text.isEmpty) {
      return _locales;
    }
    return _locales.where((local) {
      final title = local['title'].toString().toLowerCase();
      final description = local['description'].toString().toLowerCase();
      final searchText = _searchController.text.toLowerCase();
      return title.contains(searchText) || description.contains(searchText);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildCustomAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Toolbar personalizada con color primario
  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getCurrentDate(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '¡Hola, Juan Pérez!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: 100,
    );
  }

  // Cuerpo principal con barra de búsqueda y tarjetas
  Widget _buildBody() {
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
                onChanged: (_) {
                  controller.openView();
                },
                leading: Icon(Icons.search, color: primaryColor),
                trailing: [
                  if (controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        controller.clear();
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
                  final suggestions = _locales.where((local) {
                    final title = local['title'].toString().toLowerCase();
                    final searchText = controller.text.toLowerCase();
                    return title.contains(searchText);
                  }).toList();

                  return suggestions.map((local) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: secondaryColor.withOpacity(0.2),
                        child: Icon(Icons.store, color: primaryColor),
                      ),
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                local['rating'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
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
              Text(
                _searchController.text.isEmpty
                    ? 'Locales disponibles'
                    : 'Resultados: ${_filteredLocales.length}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: Text('Limpiar', style: TextStyle(color: primaryColor)),
                ),
            ],
          ),
        ),

        // Lista de tarjetas filtradas
        Expanded(
          child: _filteredLocales.isEmpty
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
            'Intenta con otros términos de búsqueda',
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.4)),
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
                  color: secondaryColor.withOpacity(0.1),
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
                //Titulo
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
                ),

                const SizedBox(height: 12),

                // Tiempo de entrega
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tiempo estimado: ${local['tiempo']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Botón de acción - Navega a la pantalla Local
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla Local
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Local()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront, size: 20), // Icono cambiado
                        const SizedBox(width: 8),
                        const Text(
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

  // Navegación inferior
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor.withOpacity(0.5),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor.withOpacity(0.5),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    return '${days[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]} de ${now.year}';
  }
}
