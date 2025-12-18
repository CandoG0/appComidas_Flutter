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

  static const Color primaryColor = Color(0xFFFF724C);
  static const Color backgroundColor = Color(0xFFF4F4F8);
  static const Color textColor = Color(0xFF2A2C41);

  final List<Widget> _pages = const [
    HomeContent(),
    OrdersScreen(),
    PerfilScreen(),
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

  PreferredSizeWidget _buildCustomAppBar() => AppBar(
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

  Widget _buildBottomNavigationBar() => Container(
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
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: textColor.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final SearchController _searchController = SearchController();

  static const Color primaryColor = Color(0xFFFF724C);
  static const Color textColor = Color(0xFF2A2C41);
  static const Color backgroundColor = Color(0xFFF4F4F8);

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
        _buildSearchBar(),
        _buildResultsIndicator(),
        _buildLocalesList(),
      ],
    );
  }

  // Métodos de lógica
  Future<List<Map<String, dynamic>>> _cargarLocales() async {
    try {
      _locales = await LocalService.getLocales();
      _filteredLocales = _locales;
      return _locales;
    } catch (e) {
      print('Error cargando locales: $e');
      return [];
    }
  }

  void _onSearchChanged() => _filtrarLocales(_searchController.text);

  void _filtrarLocales(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocales = _locales;
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredLocales = _locales.where((local) {
          final title = local['title'].toString().toLowerCase();
          final desc = local['description'].toString().toLowerCase();
          return title.contains(query.toLowerCase()) || 
                 desc.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _refrescarLocales() async {
    setState(() {
      _localesFuture = _cargarLocales();
      _searchController.clear();
      _isSearching = false;
    });
  }

  // Widgets de UI
  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SearchAnchor(
          builder: (context, controller) => SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () => controller.openView(),
            onChanged: (_) => controller.openView(),
            onSubmitted: (value) {
              _filtrarLocales(value);
              controller.closeView(value);
            },
            leading: const Icon(Icons.search, color: primaryColor),
            trailing: _buildSearchTrailing(controller),
            backgroundColor: const WidgetStatePropertyAll(Colors.white),
            shadowColor: WidgetStatePropertyAll(textColor.withOpacity(0.1)),
          ),
          suggestionsBuilder: (context, controller) => _buildSuggestions(controller),
        ),
      );

  List<Widget> _buildSearchTrailing(SearchController controller) => [
        if (controller.text.isNotEmpty)
          IconButton(
            onPressed: () {
              controller.clear();
              _refrescarLocales();
            },
            icon: const Icon(Icons.close, color: primaryColor),
          ),
      ];

  List<ListTile> _buildSuggestions(SearchController controller) {
    return _locales.where((local) {
      return local['title'].toString().toLowerCase()
          .contains(controller.text.toLowerCase());
    }).map((local) => ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(local['image']),
        backgroundColor: primaryColor.withOpacity(0.1),
      ),
      title: Text(
        local['title'],
        style: const TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        local['description'],
        style: TextStyle(color: textColor.withOpacity(0.7)),
      ),
      trailing: _buildSuggestionTrailing(local),
      onTap: () {
        controller.closeView(local['title']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LocalScreen()),
        );
      },
    )).toList();
  }

  Widget _buildSuggestionTrailing(Map<String, dynamic> local) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 2),
              Text(
                local['rating'],
                style: const TextStyle(
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
      );

  Widget _buildResultsIndicator() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _localesFuture,
              builder: (context, snapshot) => Text(
                _getResultsText(snapshot),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ),
            if (_isSearching)
              TextButton(
                onPressed: _refrescarLocales,
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 16, color: primaryColor),
                    const SizedBox(width: 4),
                    Text('Ver todos', style: TextStyle(color: primaryColor)),
                  ],
                ),
              ),
          ],
        ),
      );

  String _getResultsText(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return 'Cargando locales...';
    }
    if (snapshot.hasError) return 'Error al cargar';
    if (_isSearching) return 'Resultados: ${_filteredLocales.length}';
    return 'Locales disponibles: ${_locales.length}';
  }

  Widget _buildLocalesList() => Expanded(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _localesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }
            return _buildLocalesListView();
          },
        ),
      );

  Widget _buildLocalesListView() => RefreshIndicator(
        onRefresh: _refrescarLocales,
        color: primaryColor,
        backgroundColor: Colors.white,
        child: _filteredLocales.isEmpty
            ? _buildNoResultsState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredLocales.length,
                itemBuilder: (context, index) => 
                    _buildLocalCard(_filteredLocales[index]),
              ),
      );

  Widget _buildLocalCard(Map<String, dynamic> local) => Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLocalImage(local),
            _buildLocalContent(local),
          ],
        ),
      );

  Widget _buildLocalImage(Map<String, dynamic> local) => ClipRRect(
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
          errorBuilder: (context, error, stackTrace) => 
              _buildPlaceholderImage(local['title']),
        ),
      );

  Widget _buildLocalContent(Map<String, dynamic> local) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              local['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              local['description'],
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            _buildLocalInfo(local),
            const SizedBox(height: 16),
            _buildActionButton(local),
          ],
        ),
      );

  Widget _buildLocalInfo(Map<String, dynamic> local) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(Icons.star, local['rating'], const Color(0xFFFDBF50)),
          _buildInfoItem(Icons.access_time, local['tiempo'], null),
          _buildInfoItem(Icons.schedule, local['horario'] ?? '08:00 - 22:00', null),
        ],
      );

  Widget _buildInfoItem(IconData icon, String text, Color? iconColor) => Row(
        children: [
          Icon(icon, size: 16, color: iconColor ?? textColor.withOpacity(0.6)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: icon == Icons.schedule ? 12 : 14,
              fontWeight: icon == Icons.star ? FontWeight.bold : FontWeight.normal,
              color: textColor.withOpacity(icon == Icons.star ? 1 : 0.6),
            ),
          ),
        ],
      );

Widget _buildActionButton(Map<String, dynamic> local) => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            // Pasa el local al LocalScreen
            builder: (_) => LocalScreen(),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 20),
            SizedBox(width: 8),
            Text(
              'Ver Menú',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

  Widget _buildPlaceholderImage(String nombre) {
    final hue = (nombre.hashCode % 360).toDouble();
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
              style: const TextStyle(
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

  Widget _buildLoadingState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cargando locales...',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
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

  Widget _buildErrorState(String error) => Center(
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
              const Text(
                'Error de conexión',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'No se pudo conectar con el servidor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Reintentar', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Usar datos de demostración',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_mall_directory_outlined,
              size: 80,
              color: textColor.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay locales disponibles',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Parece que no hay locales registrados en este momento.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _refrescarLocales,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Actualizar'),
            ),
          ],
        ),
      );

  Widget _buildNoResultsState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: textColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron locales',
              style: TextStyle(
                fontSize: 18,
                color: textColor,
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
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text('Ver todos los locales'),
            ),
          ],
        ),
      );
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(
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