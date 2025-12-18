import 'package:app_comidas/pages/perfil.dart';
import 'package:app_comidas/pages/local.dart';
import 'package:app_comidas/services/local_service.dart';
import 'package:flutter/material.dart';

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
  final Color primaryColor = const Color(0xFFFF724C);
  final Color secondaryColor = const Color(0xFFFDBF50);
  final Color backgroundColor = const Color(0xFFF4F4F8);
  final Color textColor = const Color(0xFF2A2C41);

  // Lista de pantallas/páginas
  final List<Widget> _pages = [
    const HomeContent(), // Contenido del Home
    const OrdersScreen(), // Pantalla de Pedidos
    const PerfilScreen(), // Pantalla de perfil
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _currentIndex == 0 ? _buildCustomAppBar() : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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

// Contenido del Home
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

  late Future<List<Map<String, dynamic>>> _localesFuture;
  List<Map<String, dynamic>> _locales = [];
  List<Map<String, dynamic>> _filteredLocales = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _localesFuture = _cargarLocales();
    _searchController.addListener(_onSearchChanged);
  }

  Future<List<Map<String, dynamic>>> _cargarLocales() async {
    try {
      print('🔄 Iniciando carga de locales...');
      _locales = await LocalService.getLocales();
      _filteredLocales = _locales;
      print('✅ Locales cargados: ${_locales.length}');
      return _locales;
    } catch (e) {
      print('❌ Error cargando locales: $e');
      // Retornar datos vacíos para que FutureBuilder maneje el error
      return [];
    }
  }

  void _onSearchChanged() {
    _filtrarLocales(_searchController.text);
  }

  void _filtrarLocales(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocales = _locales;
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredLocales = _locales.where((local) {
          final title = local['title'].toString().toLowerCase();
          final description = local['description'].toString().toLowerCase();
          final searchText = query.toLowerCase();
          return title.contains(searchText) || description.contains(searchText);
        }).toList();
      }
    });
  }

  Future<void> _buscarLocales(String query) async {
    if (query.isEmpty) {
      _refrescarLocales();
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      print('🔍 Buscando locales con: $query');
    } catch (e) {
      print('❌ Error en búsqueda: $e');
      // Si falla la búsqueda en API, filtrar localmente
      _filtrarLocales(query);
    }
  }

  Future<void> _refrescarLocales() async {
    setState(() {
      _localesFuture = _cargarLocales();
      _searchController.clear();
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
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
                onChanged: (_) {
                  controller.openView();
                },
                onSubmitted: (value) {
                  _buscarLocales(value);
                  controller.closeView(value);
                },
                leading: Icon(Icons.search, color: primaryColor),
                trailing: [
                  if (controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        controller.clear();
                        _refrescarLocales();
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
              return _locales.where((local) {
                final title = local['title'].toString().toLowerCase();
                final searchText = controller.text.toLowerCase();
                return title.contains(searchText);
              }).map((local) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(local['image']),
                    backgroundColor: primaryColor.withOpacity(0.1),
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
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            local['rating'],
                            style: TextStyle(
                              fontSize: 12,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalScreen(local: local),
                        ),
                      );
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
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _localesFuture,
                builder: (context, snapshot) {
                  String texto = '';
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    texto = 'Cargando locales...';
                  } else if (snapshot.hasError) {
                    texto = 'Error al cargar';
                  } else if (_isSearching) {
                    texto = 'Resultados: ${_filteredLocales.length}';
                  } else {
                    texto = 'Locales disponibles: ${_locales.length}';
                  }
                  
                  return Text(
                    texto,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor.withOpacity(0.7),
                    ),
                  );
                },
              ),
              if (_isSearching)
                TextButton(
                  onPressed: _refrescarLocales,
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 16, color: primaryColor),
                      const SizedBox(width: 4),
                      Text('Ver todos', style: TextStyle(color: primaryColor)),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Lista de tarjetas con FutureBuilder
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _localesFuture,
            builder: (context, snapshot) {
              // Estado de carga
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }

              // Estado de error
              if (snapshot.hasError) {
                return _buildErrorState(snapshot.error.toString());
              }

              // Estado sin datos
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState();
              }

              // Estado con datos
              return _buildLocalesList();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocalesList() {
    return RefreshIndicator(
      onRefresh: _refrescarLocales,
      color: primaryColor,
      backgroundColor: Colors.white,
      child: _filteredLocales.isEmpty
          ? _buildNoResultsState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredLocales.length,
              itemBuilder: (context, index) {
                return _buildLocalCard(_filteredLocales[index]);
              },
            ),
    );
  }

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
                return _buildPlaceholderImage(local['title']);
              },
            ),
          ),

          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titulo
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

                // Información adicional
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: const Color(0xFFFDBF50),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          local['rating'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),

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
                          local['tiempo'],
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),

                    // Horario
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: textColor.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          local['horario'] ?? '08:00 - 22:00',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalScreen(local: local),
                        ),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Ver Menú',
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

  Widget _buildPlaceholderImage(String nombre) {
    final hash = nombre.hashCode;
    final hue = (hash % 360).toDouble();
    final color = HSLColor.fromAHSL(1.0, hue, 0.7, 0.8).toColor();
    
    return Container(
      height: 150,
      color: color.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 50, color: primaryColor),
            const SizedBox(height: 8),
            Text(
              nombre.length > 15 ? '${nombre.substring(0, 15)}...' : nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Cargando locales...',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Obteniendo información de la base de datos',
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'Error de conexión',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No se pudo conectar con el servidor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.contains('timeout')
                  ? 'El servidor tardó demasiado en responder'
                  : 'Verifica tu conexión a internet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refrescarLocales,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: Icon(Icons.refresh, size: 20),
              label: Text(
                'Reintentar',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Navegar a pantalla offline o mostrar datos locales
              },
              child: Text(
                'Usar datos de demostración',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_mall_directory_outlined,
            size: 80,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No hay locales disponibles',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Parece que no hay locales registrados en este momento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _refrescarLocales,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            icon: Icon(Icons.refresh, size: 20),
            label: Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: textColor.withOpacity(0.3),
          ),
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
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refrescarLocales,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: Text('Ver todos los locales'),
          ),
        ],
      ),
    );
  }
}

// Pantalla de Pedidos
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Pantalla de Pedidos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Aquí verás tu historial de pedidos',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}