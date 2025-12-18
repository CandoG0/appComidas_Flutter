import 'package:app_comidas/services/api_service.dart';
import 'package:flutter/material.dart';
import 'carrito.dart';

class LocalScreen extends StatefulWidget {
  final int localId;
  final String localName; // Añadimos el nombre del local
  
  const LocalScreen({
    super.key,
    required this.localId,
    required this.localName,
  });

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final SearchController _searchController = SearchController();
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  final Color primaryColor = const Color(0xFFFF724C);
  final Color secondaryColor = const Color(0xFFFDBF50);
  final Color backgroundColor = const Color(0xFFF4F4F8);
  final Color textColor = const Color(0xFF2A2C41);

  // Variables para el carrito
  List<Map<String, dynamic>> cartItems = [];
  double get totalPrice {
    return cartItems.fold(0, (sum, item) {
      final priceString = item['price']?.toString() ?? '0';
      final price = double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      return sum + price;
    });
  }

  // Categorías
  List<Map<String, dynamic>> categories = [
    {'cat_id': 0, 'cat_nombre': 'Todos'},
  ];
  int selectedCategoryIndex = 0;

  // Productos
  List<Map<String, dynamic>> _productCards = [];
  List<Map<String, dynamic>> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      // Cargar categorías
      final categoriasData = await ApiService.getCategorias();
      if (categoriasData.isNotEmpty) {
        setState(() {
          categories = [
            {'cat_id': 0, 'cat_nombre': 'Todos'},
            ...categoriasData.map((cat) {
              if (cat is Map) {
                return {
                  'cat_id': cat['cat_id'] ?? 0,
                  'cat_nombre': cat['cat_nombre'] ?? 'Sin nombre',
                };
              }
              return {'cat_id': 0, 'cat_nombre': 'Error'};
            }).toList(),
          ];
        });
      }

      // Cargar platillos
      final platillosData = await ApiService.getPlatillosByLocal(widget.localId);
      
      List<Map<String, dynamic>> formattedProducts = [];
      
      if (platillosData.isNotEmpty) {
        formattedProducts = platillosData.map((platillo) {
          if (platillo is Map) {
            return {
              'pla_id': platillo['pla_id']?.toString() ?? '0',
              'title': platillo['title']?.toString() ?? 
                       platillo['pla_nombre']?.toString() ?? 'Sin nombre',
              'description': platillo['description']?.toString() ?? 
                           platillo['pla_descripcion']?.toString() ?? 'Sin descripción',
              'price': platillo['price']?.toString() ?? 
                      platillo['pla_precio']?.toString() ?? '0.00',
              'category': platillo['category']?.toString() ?? 
                         platillo['categoria_nombre']?.toString() ?? 'Sin categoría',
              'image': platillo['image']?.toString() ?? 
                      platillo['arc_ruta']?.toString() ?? 
                      'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=${Uri.encodeComponent(platillo['title']?.toString() ?? 'Producto')}',
              'stock': platillo['stock'] ?? platillo['pla_stock'] ?? 0,
            };
          }
          return {
            'pla_id': '0',
            'title': 'Error en formato',
            'description': 'Los datos no están en el formato esperado',
            'price': '0.00',
            'category': 'Error',
            'image': 'https://via.placeholder.com/300x200/FF0000/FFFFFF?text=Error',
            'stock': 0,
          };
        }).toList();
      }

      setState(() {
        _productCards = formattedProducts;
        _allProducts = List.from(formattedProducts);
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        hasError = true;
        errorMessage = 'Error al cargar los datos: $e';
        _productCards = _getExampleData();
        _allProducts = List.from(_productCards);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getExampleData() {
    return [
      {
        'pla_id': '1',
        'title': 'Tacos al Pastor',
        'description': 'Deliciosos tacos con piña y cebolla',
        'price': '12.00',
        'category': 'Comida Rápida',
        'image': 'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Tacos',
        'stock': 100,
      },
      {
        'pla_id': '2',
        'title': 'Hamburguesa Clásica',
        'description': 'Hamburguesa con papas',
        'price': '120.00',
        'category': 'Comida Rápida',
        'image': 'https://via.placeholder.com/300x200/FDBF50/2A2C41?text=Hamburguesa',
        'stock': 50,
      },
    ];
  }

  // Lista filtrada
  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> filtered = _productCards;

    // Filtrar por categoría
    if (selectedCategoryIndex > 0 && categories.length > selectedCategoryIndex) {
      final selectedCategory = categories[selectedCategoryIndex]['cat_nombre'];
      filtered = filtered
          .where((product) => product['category'] == selectedCategory)
          .toList();
    }

    // Filtrar por búsqueda
    if (_searchController.text.isNotEmpty) {
      final searchText = _searchController.text.toLowerCase();
      filtered = filtered.where((product) {
        final title = product['title']?.toString().toLowerCase() ?? '';
        final description = product['description']?.toString().toLowerCase() ?? '';
        return title.contains(searchText) || description.contains(searchText);
      }).toList();
    }

    return filtered;
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          '${product['title']} agregado al carrito',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartItems,
          onCartUpdated: (updatedCart) {
            setState(() {
              cartItems = updatedCart;
            });
          },
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await _loadData();
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
      bottomNavigationBar: cartItems.isNotEmpty ? _buildCartFooter() : null,
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://tse2.mm.bing.net/th/id/OIP.90sDWdblfZFiciIEpsGFwwHaEY?rs=1&pid=ImgDetMain&o=7&rm=3',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 50.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.localName,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCurrentDate(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      toolbarHeight: 150,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    }
    
    if (hasError) {
      return _buildErrorState();
    }
    
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: primaryColor,
      child: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: SearchBar(
              controller: _searchController,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) => setState(() {}),
              leading: Icon(Icons.search, color: primaryColor),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.close, color: primaryColor),
                  ),
              ],
              hintText: 'Buscar platillos...',
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              shadowColor: WidgetStatePropertyAll(textColor.withOpacity(0.1)),
            ),
          ),

          // Selector de categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: FilterChip(
                    label: Text(categories[index]['cat_nombre']),
                    selected: selectedCategoryIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategoryIndex = selected ? index : 0;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      color: selectedCategoryIndex == index ? Colors.white : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: selectedCategoryIndex == index ? primaryColor : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Indicador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  _getResultsText(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Lista de productos
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Cargando platillos...',
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error de conexión',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshData,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: textColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'No se encontraron resultados'
                : 'No hay platillos disponibles',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (_searchController.text.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  selectedCategoryIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mostrar todos'),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              product['image'],
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
                  child: Icon(Icons.fastfood, size: 50, color: primaryColor),
                );
              },
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${product['price']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(product['category']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product['category'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _getCategoryColor(product['category']),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if ((product['stock'] ?? 0) > 0)
                      Text(
                        'Stock: ${product['stock']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      )
                    else
                      Text(
                        'Agotado',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addToCart(product),
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
                        Icon(Icons.add_shopping_cart, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Agregar al carrito',
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

  Widget _buildCartFooter() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              IconButton(
                onPressed: _navigateToCart,
                icon: Icon(Icons.shopping_cart, size: 28, color: primaryColor),
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  'MX\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _navigateToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Ver Carrito',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'comida rápida':
      case 'comida rapida':
        return const Color(0xFFFF724C);
      case 'postres':
        return const Color(0xFF9C27B0);
      case 'bebidas':
        return const Color(0xFF2196F3);
      default:
        return primaryColor;
    }
  }

  String _getResultsText() {
    final count = _filteredProducts.length;
    
    if (_searchController.text.isNotEmpty && selectedCategoryIndex > 0) {
      return '$count resultados en ${categories[selectedCategoryIndex]['cat_nombre']}';
    } else if (_searchController.text.isNotEmpty) {
      return '$count resultados encontrados';
    } else if (selectedCategoryIndex > 0) {
      return '$count productos en ${categories[selectedCategoryIndex]['cat_nombre']}';
    } else {
      return 'Todos los productos ($count)';
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${days[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]} de ${now.year}';
  }
}