import 'package:flutter/material.dart';
import 'carrito.dart';

class Local extends StatefulWidget {
  const Local({super.key});

  @override
  State<Local> createState() => _LocalState();
}

class _LocalState extends State<Local> {
  final SearchController _searchController = SearchController();
  bool isDark = false;

  // Definición de colores de la paleta
  final Color primaryColor = const Color(0xFFFF724C); // Naranja principal
  final Color secondaryColor = const Color(0xFFFDBF50); // Amarillo
  final Color backgroundColor = const Color(0xFFF4F4F8); // Fondo gris claro
  final Color textColor = const Color(0xFF2A2C41); // Texto oscuro

  // Variables para el carrito
  List<Map<String, dynamic>> cartItems = [];
  double get totalPrice {
    return cartItems.fold(0, (sum, item) {
      final priceString = item['price']
          .replaceAll('\$', '')
          .replaceAll(',', '');
      final price = double.tryParse(priceString) ?? 0;
      return sum + price;
    });
  }

  // Categorías
  final List<String> categories = [
    'Todos',
    'Comida Rápida',
    'Postres',
    'Bebidas',
  ];
  int selectedCategoryIndex = 0;

  // Datos de ejemplo para las tarjetas organizados por categoría
  final List<Map<String, dynamic>> _productCards = [
    // Comida Rápida
    {
      'image': 'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Tacos',
      'title': 'Tacos al Pastor',
      'description': 'Deliciosos tacos con piña y cebolla',
      'price': '15.00',
      'id': '1',
      'category': 'Comida Rápida',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/FDBF50/2A2C41?text=Quesadillas',
      'title': 'Quesadillas',
      'description': 'Quesadillas de queso manchego con tortilla recién hecha',
      'price': '12.00',
      'id': '2',
      'category': 'Comida Rápida',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/2A2C41/F4F4F8?text=Gorditas',
      'title': 'Gorditas',
      'description': 'Gorditas rellenas de tu elección',
      'price': '18.00',
      'id': '3',
      'category': 'Comida Rápida',
    },
    {
      'image': 'https://via.placeholder.com/300x200/F4F4F8/2A2C41?text=Tortas',
      'title': 'Tortas Mexicanas',
      'description': 'Tortas con jamón, queso y aguacate',
      'price': '25.00',
      'id': '4',
      'category': 'Comida Rápida',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Hamburguesa',
      'title': 'Hamburguesa Especial',
      'description': 'Hamburguesa con carne, queso, lechuga y tomate',
      'price': '35.00',
      'id': '5',
      'category': 'Comida Rápida',
    },

    // Postres
    {
      'image': 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Flan',
      'title': 'Flan Napolitano',
      'description': 'Delicioso flan con caramelo',
      'price': '25.00',
      'id': '6',
      'category': 'Postres',
    },
    {
      'image': 'https://via.placeholder.com/300x200/E91E63/FFFFFF?text=Pastel',
      'title': 'Pastel de Chocolate',
      'description': 'Rebanada de pastel de chocolate belga',
      'price': '30.00',
      'id': '7',
      'category': 'Postres',
    },
    {
      'image': 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Churros',
      'title': 'Churros con Chocolate',
      'description': 'Churros recién hechos con chocolate caliente',
      'price': '20.00',
      'id': '8',
      'category': 'Postres',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/795548/FFFFFF?text=Gelatina',
      'title': 'Gelatina de Mosaico',
      'description': 'Gelatina con frutas y crema',
      'price': '15.00',
      'id': '9',
      'category': 'Postres',
    },

    // Bebidas
    {
      'image': 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Agua',
      'title': 'Agua Fresca de Horchata',
      'description': 'Refrescante agua de horchata natural',
      'price': '12.00',
      'id': '10',
      'category': 'Bebidas',
    },
    {
      'image': 'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Jugo',
      'title': 'Jugo de Naranja Natural',
      'description': 'Jugo de naranja recién exprimido',
      'price': '15.00',
      'id': '11',
      'category': 'Bebidas',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/607D8B/FFFFFF?text=Refresco',
      'title': 'Refresco en Lata',
      'description': 'Refresco de 355ml variedad de sabores',
      'price': '18.00',
      'id': '12',
      'category': 'Bebidas',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Limonada',
      'title': 'Limonada Mineral',
      'description': 'Limonada con agua mineral y menta',
      'price': '20.00',
      'id': '13',
      'category': 'Bebidas',
    },
  ];

  // Lista filtrada para la búsqueda y categoría
  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> filtered = _productCards;

    // Filtrar por categoría
    if (selectedCategoryIndex > 0) {
      final selectedCategory = categories[selectedCategoryIndex];
      filtered = filtered
          .where((product) => product['category'] == selectedCategory)
          .toList();
    }

    // Filtrar por búsqueda
    if (_searchController.text.isNotEmpty) {
      final searchText = _searchController.text.toLowerCase();
      filtered = filtered.where((product) {
        final title = product['title'].toString().toLowerCase();
        final description = product['description'].toString().toLowerCase();
        return title.contains(searchText) || description.contains(searchText);
      }).toList();
    }

    return filtered;
  }

  // Función para agregar al carrito
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });

    // Mostrar snackbar de confirmación
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

    // Función para navegar a la pantalla del carrito
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
      bottomNavigationBar: _buildCartFooter(),
    );
  }

  // AppBar con imagen de fondo del local
  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Esto te llevará de vuelta al Home
        },
      ),
      flexibleSpace: Stack(
        children: [
          // Imagen de fondo del local
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
          // Gradiente para mejorar legibilidad del texto
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
          // Contenido del AppBar
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 50.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Local de Doña Mari',
                  style: TextStyle(
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
      toolbarHeight: 150, // Aumentado para la imagen
    );
  }

  // Cuerpo principal con categorías, barra de búsqueda y tarjetas
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
                  final suggestions = _productCards.where((product) {
                    final title = product['title'].toString().toLowerCase();
                    final searchText = controller.text.toLowerCase();
                    return title.contains(searchText);
                  }).toList();

                  return suggestions.map((product) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getCategoryColor(
                          product['category'],
                        ).withOpacity(0.2),
                        child: _getCategoryIcon(product['category']),
                      ),
                      title: Text(
                        product['title'],
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['description'],
                            style: TextStyle(color: textColor.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(
                                product['category'],
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              product['category'],
                              style: TextStyle(
                                fontSize: 10,
                                color: _getCategoryColor(product['category']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${product['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          controller.closeView(product['title']);
                        });
                      },
                    );
                  });
                },
          ),
        ),

        // Selector de categorías
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            //Contenido dinamico, las categorias vendran de la bd
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: FilterChip(
                  //Saca el nombre de las categorias de un arreglo y lo coloca como texto
                  label: Text(categories[index]),
                  selected: selectedCategoryIndex == index,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategoryIndex = selected ? index : 0;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: primaryColor,
                  labelStyle: TextStyle(
                    color: selectedCategoryIndex == index
                        ? Colors.white
                        : textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selectedCategoryIndex == index
                          ? primaryColor
                          : Colors.grey.shade300,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Muestra cuantos productos hay en cada categoria
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

        // Lista de tarjetas filtradas
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
            'No se encontraron productos',
            style: TextStyle(
              fontSize: 18,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros términos de búsqueda o categoría',
            style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.4)),
          ),
          const SizedBox(height: 16),
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
            child: Text('Mostrar todos los productos'),
          ),
        ],
      ),
    );
  }

  // Tarjeta de producto individual
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
                  child: _getCategoryIcon(product['category']),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        //viene de la base de datos
                        product['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      //viene de la base de datos
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
                  //viene de la base de datos
                  product['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),

                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      //recibe un producto para añadir al carrito
                      _addToCart(product);
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
                        Icon(Icons.add_shopping_cart, size: 20),
                        const SizedBox(width: 8),
                        const Text(
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

  // Footer del carrito
  Widget _buildCartFooter() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        //Sombra de la caja
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
          // Icono del carrito con badge
          Stack(
            children: [
              IconButton(
                onPressed:_navigateToCart,
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

          // Información del total
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

          // Botón para ver carrito
          ElevatedButton(
            onPressed: cartItems.isEmpty ? null : _navigateToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: cartItems.isEmpty ? Colors.grey : primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Ver Carrito',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Funciones auxiliares para categorías
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Comida Rápida':
        return const Color(0xFFFF724C); // Naranja
      case 'Postres':
        return const Color(0xFF9C27B0); // Morado
      case 'Bebidas':
        return const Color(0xFF2196F3); // Azul
      default:
        return primaryColor;
    }
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Comida Rápida':
        return Icon(Icons.fastfood, color: _getCategoryColor(category));
      case 'Postres':
        return Icon(Icons.cake, color: _getCategoryColor(category));
      case 'Bebidas':
        return Icon(Icons.local_drink, color: _getCategoryColor(category));
      default:
        return Icon(Icons.fastfood, color: _getCategoryColor(category));
    }
  }

  String _getResultsText() {
    //Si hay algo en la barra de busqueda y una categoria selecciona busca en esa categoria
    if (_searchController.text.isNotEmpty && selectedCategoryIndex > 0) {
      return '${_filteredProducts.length} resultados en ${categories[selectedCategoryIndex]}';
    } else if (_searchController.text.isNotEmpty) {
      return '${_filteredProducts.length} resultados encontrados';
    } else if (selectedCategoryIndex > 0) {
      //Si solo buscamos en categorias muestra cuanto productos hay en dicha categoria
      return '${_filteredProducts.length} productos en ${categories[selectedCategoryIndex]}';
    } else {
      return 'Todos los productos (${_filteredProducts.length})';
    }
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
