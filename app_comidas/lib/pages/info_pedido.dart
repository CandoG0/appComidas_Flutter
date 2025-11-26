import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const ConfirmScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  // Definición de colores de la paleta
  final Color primaryColor = const Color(0xFFFF724C); // Naranja principal
  final Color secondaryColor = const Color(0xFFFDBF50); // Amarillo
  final Color backgroundColor = const Color(0xFFF4F4F8); // Fondo gris claro
  final Color textColor = const Color(0xFF2A2C41); // Texto oscuro

  // Variables para el formulario
  String _tipoEntrega = 'Recoge en tienda';
  String _metodoPago = 'Efectivo';
  final TextEditingController _notaController = TextEditingController();
  bool _showNotaField = false;

  // Opciones para los dropdowns
  final List<String> _tiposEntrega = [
    'Recoge en tienda',
    'Entrega a domicilio',
  ];
  final List<String> _metodosPago = ['Efectivo', 'Transferencia', 'PayPal'];

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }

  // Función para confirmar el pedido
  void _confirmarPedido() {
    // Aquí iría la lógica para procesar el pedido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          '¡Pedido confirmado por MX\$${widget.totalPrice.toStringAsFixed(2)}!',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // Regresar a la pantalla anterior después de un breve delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
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
        'Información del pedido',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información del local
          _buildLocalInfo(),

          const SizedBox(height: 20),

          // Tipo de entrega
          _buildTipoEntrega(),

          const SizedBox(height: 20),

          // Nota adicional
          _buildNotaAdicional(),

          const SizedBox(height: 20),

          // Tiempo de espera
          _buildTiempoEspera(),

          const SizedBox(height: 20),

          // Método de pago
          _buildMetodoPago(),

          const SizedBox(height: 20),

          // Resumen del pedido
          _buildResumenPedido(),
        ],
      ),
    );
  }

  // Información del local
  Widget _buildLocalInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://tse2.mm.bing.net/th/id/OIP.90sDWdblfZFiciIEpsGFwwHaEY?rs=1&pid=ImgDetMain&o=7&rm=3',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Local de Doña Mari',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Comida mexicana tradicional',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tipo de entrega
  Widget _buildTipoEntrega() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de entrega',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _tipoEntrega,
              onChanged: (String? newValue) {
                setState(() {
                  _tipoEntrega = newValue!;
                });
              },
              items: _tiposEntrega.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nota adicional
  Widget _buildNotaAdicional() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agregar nota',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showNotaField = !_showNotaField;
                    });
                  },
                  icon: Icon(
                    _showNotaField ? Icons.remove : Icons.add,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            if (_showNotaField) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _notaController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ej: Sin cebolla, extra picante, etc...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Tiempo de espera
  Widget _buildTiempoEspera() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.access_time, color: primaryColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tiempo estimado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '15-30 minutos',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método de pago
  Widget _buildMetodoPago() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Método de pago',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            ..._metodosPago.map((metodo) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio<String>(
                    value: metodo,
                    groupValue: _metodoPago,
                    onChanged: (String? value) {
                      setState(() {
                        _metodoPago = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  title: Text(metodo),
                  onTap: () {
                    setState(() {
                      _metodoPago = metodo;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Resumen del pedido
  Widget _buildResumenPedido() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen del pedido',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.cartItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item['price']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'MX\$${widget.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Barra inferior con botón de confirmación
  Widget _buildBottomBar() {
    return Container(
      height: 90,
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
                  'MX\$${widget.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Botón para confirmar pedido
          ElevatedButton(
            onPressed: _confirmarPedido,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text(
              'Confirmar Pedido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
