import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int clickCount = 0;
  int _currentIndex = 0; // Para controlar la navegación inferior

  // Datos de ejemplo para las tarjetas
  final List<Map<String, dynamic>> _productCards = [
    {
      'image': 'https://via.placeholder.com/300x200/FF724C/FFFFFF?text=Tacos',
      'title': 'Tacos al Pastor',
      'description': 'Deliciosos tacos con piña y cebolla',
      'price': '\$15.00',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Quesadillas',
      'title': 'Quesadillas',
      'description': 'Quesadillas de queso manchego con tortilla recién hecha',
      'price': '\$12.00',
    },
    {
      'image':
          'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Gorditas',
      'title': 'Gorditas',
      'description': 'Gorditas rellenas de tu elección',
      'price': '\$18.00',
    },
    {
      'image': 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Tortas',
      'title': 'Tortas Mexicanas',
      'description': 'Tortas con jamón, queso y aguacate',
      'price': '\$25.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Toolbar personalizada con color #FF724C
  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF724C), // Tu color específico
      elevation: 0,
      // Padding para los textos
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        // Hijo que es el texto acomodados en columnas
        child: Column(
          //Alineado al comienzo
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha en letra pequeña
            Text(
              _getCurrentDate(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 4),
            // Nombre del usuario en letra grande
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
      toolbarHeight: 100, // Altura aumentada para el diseño
    );
  }

  // Cuerpo principal con tarjetas
  Widget _buildBody() {
    return Column(
      children: [
        // Título de la sección de productos
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                leading: const Icon(Icons.search),
                trailing: [
                  // Botón para limpiar búsqueda
                  if (controller.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        controller.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
                  // Botón de tema (opcional)
                ],
              );
            },

            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  // Sugerencias basadas en la búsqueda
                  final suggestions = _productCards.where((product) {
                    final title = product['title'].toString().toLowerCase();
                    final searchText = controller.text.toLowerCase();
                    return title.contains(searchText);
                  }).toList();

                  return suggestions.map((product) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: const Icon(
                          Icons.fastfood,
                          color: Color(0xFFFF724C),
                        ),
                      ),
                      title: Text(product['title']),
                      subtitle: Text(product['description']),
                      trailing: Text(
                        product['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF724C),
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
        // Lista de tarjetas con imágenes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _productCards.length,
            itemBuilder: (context, index) {
              return _buildProductCard(_productCards[index]);
            },
          ),
        ),
      ],
    );
  }

  // Tarjeta de producto individual
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      // Sombra
      elevation: 4,
      // Separacion entre tarjetas
      margin: const EdgeInsets.only(bottom: 16),
      // Rendondear bordes de tarjetas
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Contenido dentro de las tarjetas alineado en columnas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              product['image'],
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood, size: 50),
                );
              },
            ),
          ),

          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(16),
            // Acomodo en columnas
            child: Column(
              // Texto alineado al inicio
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y precio acomodo en filas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Descripción
                Text(
                  product['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // [600] opacidad
                  ),
                ),

                const SizedBox(height: 12),

                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF724C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Agregar al Pedido',
                      style: TextStyle(color: Colors.white),
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

  // Navegación inferior mejorada
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF724C),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  // Función para obtener la fecha actual
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
