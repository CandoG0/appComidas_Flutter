import 'package:app_comidas/pages/registro_vendedor.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  // Definición de colores de la paleta
  final Color primaryColor = const Color(0xFFFF724C); // Naranja principal
  final Color secondaryColor = const Color(0xFFFDBF50); // Amarillo
  final Color backgroundColor = const Color(0xFFF4F4F8); // Fondo gris claro
  final Color textColor = const Color(0xFF2A2C41); // Texto oscuro

  // Información del usuario (esto vendría de una base de datos o API)
  final Map<String, dynamic> _userInfo = {
    'name': 'Juan Pérez',
    'email': 'juan.perez@email.com',
    'phone': '+52 55 1234 5678',
    'image': 'https://via.placeholder.com/150/FF724C/FFFFFF?text=JP',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // AppBar de la pantalla de perfil
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: const Text(
        'Mi Perfil',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  // Cuerpo principal de la pantalla
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Información del usuario
          _buildUserInfo(),

          const SizedBox(height: 24),

          // Sección de cuenta
          _buildAccountSection(),

          const SizedBox(height: 24),

          // Sección de más información
          _buildMoreInfoSection(),

          const SizedBox(height: 24),

          // Botón de cerrar sesión
          _buildLogoutButton(),
        ],
      ),
    );
  }

  // Información del usuario
  Widget _buildUserInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Foto de perfil
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(_userInfo['image']),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: primaryColor, width: 3),
              ),
            ),

            const SizedBox(width: 16),

            // Información del usuario
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userInfo['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _userInfo['email'],
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _userInfo['phone'],
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Botón de editar
            IconButton(
              onPressed: () {
                _navigateToEditProfile();
              },
              icon: Icon(Icons.edit, color: primaryColor),
              tooltip: 'Editar perfil',
            ),
          ],
        ),
      ),
    );
  }

  // Sección de cuenta
  Widget _buildAccountSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Cuenta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          // Opción: Editar perfil
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Editar perfil',
            subtitle: 'Actualiza tu información personal',
            onTap: _navigateToEditProfile,
          ),

          // Divider
          const Divider(height: 1),

          // Opción: Métodos de pago
          _buildListTile(
            icon: Icons.credit_card_outlined,
            title: 'Métodos de pago',
            subtitle: 'Gestiona tus formas de pago',
            onTap: _navigateToPaymentMethods,
          ),

          // Divider
          const Divider(height: 1),

          // Opción: Preguntas frecuentes
          _buildListTile(
            icon: Icons.help_outline,
            title: 'Preguntas frecuentes',
            subtitle: 'Encuentra respuestas a tus dudas',
            onTap: _showFAQ,
          ),
        ],
      ),
    );
  }

  // Sección de más información
  Widget _buildMoreInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Más información',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          // Opción: Registrarse como vendedor
          _buildListTile(
            icon: Icons.storefront_outlined,
            title: 'Registrarse como vendedor',
            subtitle: 'Comienza a vender tus productos',
            onTap: _navigateToVendorRegistration,
          ),

          // Divider
          const Divider(height: 1),

          // Opción: Términos y condiciones
          _buildListTile(
            icon: Icons.description_outlined,
            title: 'Términos y condiciones',
            subtitle: 'Consulta nuestros términos de servicio',
            onTap: _showTermsAndConditions,
          ),

          // Divider
          const Divider(height: 1),

          // Opción: Política de privacidad
          _buildListTile(
            icon: Icons.security_outlined,
            title: 'Política de privacidad',
            subtitle: 'Conoce cómo manejamos tus datos',
            onTap: _showPrivacyPolicy,
          ),
        ],
      ),
    );
  }

  // Botón de cerrar sesión
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showLogoutConfirmation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Cerrar Sesión',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Widget reutilizable para los elementos de lista
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: textColor.withOpacity(0.4),
        size: 16,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  // Funciones de navegación (placeholder por ahora)
  void _navigateToEditProfile() {
    // TODO: Navegar a la pantalla de editar perfil
    _showComingSoonSnackbar('Editar perfil');
  }

  void _navigateToPaymentMethods() {
    // TODO: Navegar a la pantalla de métodos de pago
    _showComingSoonSnackbar('Métodos de pago');
  }

  void _navigateToVendorRegistration() {
    // TODO: Navegar a la pantalla de registro como vendedor
      Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const VendorRegistrationScreen(),
    ),
  );
  }

  // Funciones estáticas
  void _showFAQ() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preguntas Frecuentes'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFAQItem(
                question: '¿Cómo realizo un pedido?',
                answer:
                    'Selecciona un local, agrega productos al carrito y confirma tu pedido.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                question: '¿Qué métodos de pago aceptan?',
                answer: 'Aceptamos efectivo, transferencia y PayPal.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                question: '¿Cuánto tiempo tarda la entrega?',
                answer: 'El tiempo estimado es de 15-30 minutos.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                question: '¿Puedo modificar mi pedido?',
                answer: 'Sí, puedes modificar tu pedido antes de confirmarlo.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          answer,
          style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: SingleChildScrollView(
          child: Text(
            'Aquí irían los términos y condiciones del servicio. '
            'Este es un texto de ejemplo que sería reemplazado por los términos reales del servicio. '
            'Incluiría información sobre el uso de la aplicación, responsabilidades del usuario, '
            'políticas de cancelación, etc.\n\n'
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor '
            'incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud '
            'exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: SingleChildScrollView(
          child: Text(
            'Aquí iría la política de privacidad de la aplicación. '
            'Este es un texto de ejemplo que sería reemplazado por la política real. '
            'Incluiría información sobre cómo manejamos tus datos personales, '
            'cookies, derechos del usuario, etc.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum '
            'dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non '
            'proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              // TODO: Implementar lógica de cierre de sesión
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // TODO: Implementar lógica real de cierre de sesión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: const Text(
          'Sesión cerrada correctamente',
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // Aquí iría la navegación al login
    // Navigator.pushAndRemoveUntil(...)
  }

  void _showComingSoonSnackbar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          '$feature - Próximamente',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
