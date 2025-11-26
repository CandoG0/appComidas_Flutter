import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(List<Map<String, dynamic>>) onCartUpdated;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onCartUpdated,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Definición de colores de la paleta
  final Color primaryColor = const Color(0xFFFF724C); // Naranja principal
  final Color secondaryColor = const Color(0xFFFDBF50); // Amarillo
  final Color backgroundColor = const Color(0xFFF4F4F8); // Fondo gris claro
  final Color textColor = const Color(0xFF2A2C41); // Texto oscuro

  // Calcular el precio total
  double get totalPrice {
    return widget.cartItems.fold(0, (sum, item) {
      final priceString = item['price']
          .replaceAll('\$', '')
          .replaceAll(',', '');
      final price = double.tryParse(priceString) ?? 0;
      return sum + price;
    });
  }

  // Función para eliminar un producto del carrito
  void _removeFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
      widget.onCartUpdated(widget.cartItems);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: const Text(
          'Producto eliminado del carrito',
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Función para realizar el pedido
  void _realizarPedido() {
    if (widget.cartItems.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          '¡Pedido realizado por MX\$${totalPrice.toStringAsFixed(2)}!',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // Limpiar el carrito
    widget.cartItems.clear();
    widget.onCartUpdated(widget.cartItems);

    // Regresar a la pantalla anterior después de un breve delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // AppBar con color de fondo
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: const Text(
        'Mi Carrito',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  // Cuerpo principal de la pantalla
  Widget _buildBody() {
    if (widget.cartItems.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Contador de productos
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productos en el carrito',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.cartItems.length} ${widget.cartItems.length == 1 ? 'producto' : 'productos'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lista de productos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(widget.cartItems[index], index);
            },
          ),
        ),
      ],
    );
  }

  // Estado cuando el carrito está vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              color: textColor.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Agrega algunos productos para continuar',
            style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.4)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Seguir Comprando',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Item individual del carrito
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://www.akamai.com/site/im-demo/perceptual-standard.jpg?imbypass=true',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Botón para eliminar
            IconButton(
              onPressed: () => _removeFromCart(index),
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              tooltip: 'Eliminar producto',
            ),
          ],
        ),
      ),
    );
  }

  // Barra inferior con total y botón de pedido
  Widget _buildBottomBar() {
    if (widget.cartItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
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
          // Información del total
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total a pagar:',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  'MX\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Botón para realizar pedido
          ElevatedButton(
            onPressed: _realizarPedido,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text(
              'Realizar Pedido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

}
