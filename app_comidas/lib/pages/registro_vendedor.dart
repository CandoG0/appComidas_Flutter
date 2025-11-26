import 'package:flutter/material.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  // Definición de colores de la paleta
  final Color primaryColor = const Color(0xFFFF724C); // Naranja principal
  final Color secondaryColor = const Color(0xFFFDBF50); // Amarillo
  final Color backgroundColor = const Color(0xFFF4F4F8); // Fondo gris claro
  final Color textColor = const Color(0xFF2A2C41); // Texto oscuro

  // Controladores para el formulario de información personal
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // Controladores para el formulario de información del negocio
  final TextEditingController _nombreLocalController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _telefonoLocalController =
      TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final TextEditingController _tiempoEntregaController =
      TextEditingController();
  final TextEditingController _titularController = TextEditingController();
  final TextEditingController _numeroTarjetaController =
      TextEditingController();
  final TextEditingController _bancoController = TextEditingController();

  // Variables de estado
  int _currentStep = 0;
  bool _obscurePassword = true;
  String? _selectedBanco;

  // Lista de bancos para el dropdown
  final List<String> _bancos = [
    'Bancomer',
    'Santander',
    'Banamex',
    'HSBC',
    'ScotiaBank',
    'Banorte',
    'Inbursa',
    'Otro',
  ];

  // Claves para los formularios
  final GlobalKey<FormState> _personalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _businessFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose de todos los controllers
    _nombresController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _nombreLocalController.dispose();
    _descripcionController.dispose();
    _telefonoLocalController.dispose();
    _horarioController.dispose();
    _tiempoEntregaController.dispose();
    _titularController.dispose();
    _numeroTarjetaController.dispose();
    _bancoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // AppBar de la pantalla de registro
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Text(
        _currentStep == 0 ? 'Información Personal' : 'Información del Negocio',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (_currentStep == 0) {
            Navigator.pop(context);
          } else {
            setState(() {
              _currentStep = 0;
            });
          }
        },
      ),
      centerTitle: true,
    );
  }

  // Cuerpo principal de la pantalla
  Widget _buildBody() {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: _continue,
      onStepCancel: _cancel,
      onStepTapped: (step) {
        if (step < _currentStep) {
          setState(() {
            _currentStep = step;
          });
        }
      },
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              if (_currentStep != 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: details.onStepCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Atrás'),
                  ),
                ),
              if (_currentStep != 0) const SizedBox(width: 1),
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _currentStep == 0 ? 'Continuar' : 'Registrar',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      steps: [
        // Paso 1: Información personal
        Step(
          title: const Text('Información Personal'),
          content: _buildPersonalInfoForm(),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),

        // Paso 2: Información del negocio
        Step(
          title: const Text('Información del Negocio'),
          content: _buildBusinessInfoForm(),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
      ],
    );
  }

  // Formulario de información personal
  Widget _buildPersonalInfoForm() {
    return Form(
      key: _personalFormKey,
      child: Column(
        children: [
          const SizedBox(height: 5),
          // Nombres
          TextFormField(
            controller: _nombresController,
            decoration: const InputDecoration(
              labelText: 'Nombres *',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tus nombres';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Apellidos
          TextFormField(
            controller: _apellidosController,
            decoration: const InputDecoration(
              labelText: 'Apellidos *',
              prefixIcon: Icon(Icons.person_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tus apellidos';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Teléfono
          TextFormField(
            controller: _telefonoController,
            decoration: const InputDecoration(
              labelText: 'Teléfono *',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu teléfono';
              }
              if (value.length < 10) {
                return 'El teléfono debe tener al menos 10 dígitos';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Correo
          TextFormField(
            controller: _correoController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico *',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo';
              }
              if (!value.contains('@')) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Contraseña
          TextFormField(
            controller: _contrasenaController,
            decoration: InputDecoration(
              labelText: 'Contraseña *',
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          // Información adicional
          Text(
            '* Campos obligatorios',
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  // Formulario de información del negocio
  Widget _buildBusinessInfoForm() {
    return Form(
      key: _businessFormKey,
      child: Column(
        children: [
          const SizedBox(height: 5),
          // Nombre del local
          TextFormField(
            controller: _nombreLocalController,
            decoration: const InputDecoration(
              labelText: 'Nombre del local *',
              prefixIcon: Icon(Icons.storefront_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el nombre del local';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Descripción
          TextFormField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              labelText: 'Descripción del negocio *',
              prefixIcon: Icon(Icons.description_outlined),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una descripción';
              }
              if (value.length < 20) {
                return 'La descripción debe tener al menos 20 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Teléfono del local
          TextFormField(
            controller: _telefonoLocalController,
            decoration: const InputDecoration(
              labelText: 'Teléfono del local *',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el teléfono del local';
              }
              if (value.length < 10) {
                return 'El teléfono debe tener al menos 10 dígitos';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Horario de servicio
          TextFormField(
            controller: _horarioController,
            decoration: const InputDecoration(
              labelText: 'Horario de servicio *',
              prefixIcon: Icon(Icons.access_time_outlined),
              border: OutlineInputBorder(),
              hintText: 'Ej: Lunes a Viernes 9:00 - 18:00',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el horario de servicio';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Tiempo de entrega aproximado
          TextFormField(
            controller: _tiempoEntregaController,
            decoration: const InputDecoration(
              labelText: 'Tiempo de entrega aproximado *',
              prefixIcon: Icon(Icons.delivery_dining_outlined),
              border: OutlineInputBorder(),
              hintText: 'Ej: 15-30 minutos',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el tiempo de entrega';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // Sección de datos bancarios
          Text(
            'Datos Bancarios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 16),

          // Titular de la cuenta
          TextFormField(
            controller: _titularController,
            decoration: const InputDecoration(
              labelText: 'Titular de la cuenta *',
              prefixIcon: Icon(Icons.person_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el titular de la cuenta';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Número de tarjeta/cuenta
          TextFormField(
            controller: _numeroTarjetaController,
            decoration: const InputDecoration(
              labelText: 'Número de cuenta/tarjeta *',
              prefixIcon: Icon(Icons.credit_card_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el número de cuenta';
              }
              if (value.length < 10) {
                return 'El número de cuenta debe tener al menos 10 dígitos';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Banco
          DropdownButtonFormField<String>(
            value: _selectedBanco,
            onChanged: (String? newValue) {
              setState(() {
                _selectedBanco = newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Banco *',
              prefixIcon: Icon(Icons.account_balance_outlined),
              border: OutlineInputBorder(),
            ),
            items: _bancos.map((String banco) {
              return DropdownMenuItem<String>(value: banco, child: Text(banco));
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona un banco';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          // Información adicional
          Text(
            '* Campos obligatorios\nLos datos bancarios se usarán para transferencias de pagos',
            style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  // Función para continuar al siguiente paso
  void _continue() {
    if (_currentStep == 0) {
      if (_personalFormKey.currentState!.validate()) {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      if (_businessFormKey.currentState!.validate()) {
        _registerVendor();
      }
    }
  }

  // Función para regresar al paso anterior
  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  // Función para registrar el vendedor
  void _registerVendor() {
    // Aquí iría la lógica para enviar los datos al servidor

    // Mostrar diálogo de éxito
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Registro Exitoso'),
          ],
        ),
        content: const Text(
          'Tu solicitud de registro como vendedor ha sido enviada. '
          'Te invitamos a acceder a nuestra pagina web para gestionar de mejor manera tu negocio',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Regresar al perfil
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
