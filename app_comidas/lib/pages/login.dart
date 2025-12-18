import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Colores como constantes estáticas
  static const Color primaryColor = Color(0xFFFF724C);
  static const Color backgroundColor = Color(0xFFF4F4F8);
  static const Color textColor = Color(0xFF2A2C41);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final String _demoUsername = 'superadmin';
  final String _demoPassword = 'superadmin';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildBackButton(context),
              const SizedBox(height: 20),
              _buildLogo(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildSubtitle(),
              const SizedBox(height: 40),
              _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos auxiliares

  Widget _buildBackButton(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: textColor, size: 24),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      );

  Widget _buildLogo() => Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.restaurant, size: 50, color: Colors.white),
      );

  Widget _buildTitle() => Text(
        'Bienvenido de nuevo',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      );

  Widget _buildSubtitle() => Text(
        'Ingresa a tu cuenta para continuar',
        style: TextStyle(
          fontSize: 16,
          color: textColor.withOpacity(0.7),
        ),
      );

  Widget _buildForm(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 5),
                _buildUsernameField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildForgotPasswordButton(context),
                const SizedBox(height: 24),
                _buildLoginButton(context),
                const SizedBox(height: 24),
                _buildDivider(),
                const SizedBox(height: 24),
                _buildRegisterButton(context),
                const SizedBox(height: 20),
                _buildFooterText(),
              ],
            ),
          ),
        ),
      );

  Widget _buildUsernameField() => TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: 'Nombre de usuario',
          prefixIcon: const Icon(Icons.person_outline, color: primaryColor),
          border: _inputBorder,
          focusedBorder: _focusedInputBorder,
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) => value == null || value.isEmpty
            ? 'Por favor ingresa tu nombre de usuario'
            : null,
      );

  Widget _buildPasswordField() => TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: textColor.withOpacity(0.5),
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          border: _inputBorder,
          focusedBorder: _focusedInputBorder,
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu contraseña';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
      );

  OutlineInputBorder get _inputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textColor.withOpacity(0.3)),
      );

  OutlineInputBorder get _focusedInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      );

  Widget _buildForgotPasswordButton(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => _showForgotPasswordDialog(context),
          child: const Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget _buildLoginButton(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _login(context),
          style: _primaryButtonStyle,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
        ),
      );

  ButtonStyle get _primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.3),
      );

  Widget _buildDivider() => Row(
        children: [
          Expanded(child: Divider(color: textColor.withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('o', style: TextStyle(color: textColor.withOpacity(0.5))),
          ),
          Expanded(child: Divider(color: textColor.withOpacity(0.3))),
        ],
      );

  Widget _buildRegisterButton(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: () => _navigateToRegister(context),
          style: _secondaryButtonStyle,
          child: const Text(
            'Crear una cuenta nueva',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );

  ButtonStyle get _secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
      );

  Widget _buildFooterText() => Text(
        'Al iniciar sesión aceptas nuestros Términos y Condiciones',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.5)),
      );

  // Métodos de lógica

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (_usernameController.text == _demoUsername &&
        _passwordController.text == _demoPassword) {
      _navigateToHome(context);
    } else {
      _showErrorDialog(context);
    }

    setState(() => _isLoading = false);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeContent()),
      (_) => false,
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
      (_) => false,
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error de autenticación'),
        content: const Text(
          'El nombre de usuario o contraseña son incorrectos. '
          'Por favor verifica tus credenciales e intenta nuevamente.',
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

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar Contraseña'),
        content: const Text(
          'Ingresa tu correo electrónico y te enviaremos un enlace '
          'para restablecer tu contraseña.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonSnackbar(context, 'Recuperación de contraseña');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Text('$feature - Próximamente'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}