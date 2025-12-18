import 'package:app_comidas/pages/login.dart';
import 'package:app_comidas/pages/register.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Colores como constantes estáticas
  static const Color primaryColor = Color(0xFFFF724C);
  static const Color secondaryColor = Color(0xFFFDBF50);
  static const Color backgroundColor = Color(0xFF2A2C41);
  static const Color textColor = Color(0xFFF4F4F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: _buildBackgroundDecoration(),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildMainContent(context),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos auxiliares para dividir la UI

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [backgroundColor, const Color(0xFF3A3C51)],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 40),
            _buildTitle(),
            const SizedBox(height: 16),
            _buildSubtitle(),
            const SizedBox(height: 50),
            _buildLoginButton(context),
            const SizedBox(height: 16),
            _buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
      ),
      child: Icon(Icons.restaurant, size: 60, color: primaryColor),
    );
  }

  Widget _buildTitle() {
    return const Text(
      '¿Antojo de\n algo casero?',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Descubre los mejores sabores locales cerca de ti',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: textColor.withOpacity(0.8),
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return _buildButton(
      text: 'Iniciar Sesión',
      isPrimary: true,
      onPressed: () => _navigateToLogin(context),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return _buildButton(
      text: 'Registrarse',
      isPrimary: false,
      onPressed: () => _navigateToRegister(context),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: _primaryButtonStyle,
              child: _buildButtonText(text),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: _secondaryButtonStyle,
              child: _buildButtonText(text),
            ),
    );
  }

  ButtonStyle get _primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: _buttonShape,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.3),
      );

  ButtonStyle get _secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: BorderSide(color: textColor.withOpacity(0.3), width: 2),
        shape: _buttonShape,
        backgroundColor: Colors.transparent,
      );

  RoundedRectangleBorder get _buttonShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      );

  Widget _buildButtonText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        'Del campo a tu mesa',
        style: TextStyle(
          fontSize: 14,
          color: textColor.withOpacity(0.6),
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  // Métodos de navegación

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }
}