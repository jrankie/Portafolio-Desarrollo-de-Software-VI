import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const TechEventsApp());
}

class TechEventsApp extends StatelessWidget {
  const TechEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2.0,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
        ),
      ),
      home: const PantallaInicio(),
    );
  }
}


// PANTALLA 1: INICIO

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 350,
                      width:350,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '¡Bienvenido al sistema de registro de eventos tecnológicos!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 36),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PantallaRegistro()),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Registrarme', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// PANTALLA 2: REGISTRO DE PARTICIPANTE

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _telefonoCtrl = TextEditingController();

  String? _tipoParticipante;
  Color? _colorTarjeta;
  bool _mostrarCaraFrontal = true;

  final Map<String, bool> _tecnologias = {
    'Flutter': false,
    'Inteligencia Artificial': false,
    'Ciberseguridad': false,
    'Desarrollo Web': false,
    'Bases de Datos': false,
  };

  List<String> get _techsSeleccionadas => _tecnologias.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  void _guardarRegistro(bool esTablet) {
    bool isFormValid = _formKey.currentState!.validate();
    bool isTipoSelected = _tipoParticipante != null;
    bool isTechSelected = _tecnologias.containsValue(true);

    if (!isFormValid || !isTipoSelected || !isTechSelected) {
      String errorMsg = '';
      if (!isTipoSelected) errorMsg += 'Debe seleccionar un tipo de participante.\n';
      if (!isTechSelected) errorMsg += 'Debe elegir al menos una tecnología.\n';

      if (errorMsg.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Faltan datos'),
            content: Text(errorMsg),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete los campos correctamente.')),
        );
      }
      return;
    }

    if (!esTablet) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaResumen(
            nombre: _nombreCtrl.text,
            correo: _correoCtrl.text,
            telefono: _telefonoCtrl.text,
            tipoParticipante: _tipoParticipante!,
            tecnologias: _techsSeleccionadas,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¡Registro Guardado!'),
          content: const Text('Los datos han sido procesados correctamente en el panel lateral.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Volver al Inicio')
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(flex: 1, child: _construirFormulario(esTablet: true)),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _construirTarjetaInteractiva(),
                          const SizedBox(height: 20),
                          _construirVistaResumen(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _construirFormulario(esTablet: false),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: _construirTarjetaInteractiva(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _construirFormulario({required bool esTablet}) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_rounded, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Datos Personales', style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                      ],
                      onChanged: (val) => setState(() {}),
                      validator: (value) => value == null || value.isEmpty ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _correoCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      onChanged: (val) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es obligatorio';
                        }
                        if (!value.contains('@') || !value.contains('.com')) {
                          return 'El correo es inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _telefonoCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono (Opcional)',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (val) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.badge_rounded, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Tipo de Participante', style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      title: const Text('Estudiante'),
                      value: 'Estudiante',
                      groupValue: _tipoParticipante,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _tipoParticipante = val),
                    ),
                    RadioListTile<String>(
                      title: const Text('Profesional'),
                      value: 'Profesional',
                      groupValue: _tipoParticipante,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _tipoParticipante = val),
                    ),
                    RadioListTile<String>(
                      title: const Text('Docente'),
                      value: 'Docente',
                      groupValue: _tipoParticipante,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _tipoParticipante = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code_rounded, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Tecnologías de Interés', style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._tecnologias.keys.map((String key) {
                      return CheckboxListTile(
                        title: Text(key),
                        value: _tecnologias[key],
                        contentPadding: EdgeInsets.zero,
                        onChanged: (bool? value) {
                          setState(() {
                            _tecnologias[key] = value ?? false;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _guardarRegistro(esTablet),
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Guardar Registro', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTarjetaInteractiva() {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceContainerHigh;
    final currentColor = _colorTarjeta ?? baseColor;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.qr_code_2_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Escanear Entrada'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Icon(
                  Icons.qr_code_2_rounded,
                  size: 160,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 16),
                Text(
                  _nombreCtrl.text.isEmpty ? 'Pase General' : 'Pase de: ${_nombreCtrl.text}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Muestra este código en la entrada del evento para validar tu asistencia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              )
            ],
          ),
        );
      },
      onDoubleTap: () {
        setState(() {
          _mostrarCaraFrontal = !_mostrarCaraFrontal;
        });
      },
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.download_done_rounded, color: Colors.purple),
                SizedBox(width: 8),
                Text('¡Pase guardado en el dispositivo!'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          color: currentColor,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _mostrarCaraFrontal
                ? Column(
                    key: const ValueKey('frontal'),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.local_activity_rounded, color: theme.colorScheme.primary, size: 24),
                          Text(
                            'TECH EVENTS 2026',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(width: 24),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PARTICIPANTE',
                                  style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _nombreCtrl.text.isEmpty ? 'Tu Nombre' : _nombreCtrl.text,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'TIPO DE ACCESO',
                                  style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _tipoParticipante ?? 'No seleccionado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              size: 56,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        'Toca: Ver QR | Doble Toque: Cronograma | Mantén: Guardar',
                        style: TextStyle(fontSize: 10, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('trasera'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.calendar_month_rounded, color: theme.colorScheme.secondary, size: 24),
                          const Text(
                            'CRONOGRAMA DEL EVENTO DE HOY',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.1,
                            ),
                          ),
                          Icon(Icons.flip_camera_android_rounded, color: theme.colorScheme.primary, size: 20),
                        ],
                      ),
                      const Divider(height: 20),
                      const Text(
                        '• 09:00 AM - Acreditaciones e Inicio',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• 10:00 AM - Conferencia: Futuro de la IA',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• 11:30 AM - Workshop Flutter 2026',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• 02:00 PM - Panel: Ciberseguridad',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const Divider(height: 24),
                      Center(
                        child: Text(
                          'Doble toque para volver a tu Credencial',
                          style: TextStyle(fontSize: 10, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _construirVistaResumen() {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Vista Previa del Resumen',
                  style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
            const Divider(height: 24),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: const Text('Nombre'),
              subtitle: Text(
                _nombreCtrl.text.isEmpty ? "Esperando datos..." : _nombreCtrl.text,
                style: const TextStyle(fontSize: 16),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Correo electrónico'),
              subtitle: Text(
                _correoCtrl.text.isEmpty ? "Esperando datos..." : _correoCtrl.text,
                style: const TextStyle(fontSize: 16),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Teléfono'),
              subtitle: Text(
                _telefonoCtrl.text.isEmpty ? "No especificado" : _telefonoCtrl.text,
                style: const TextStyle(fontSize: 16),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Tipo de Participante'),
              subtitle: Text(
                _tipoParticipante ?? 'No seleccionado',
                style: const TextStyle(fontSize: 16),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: 12),
            const Text('Tecnologías de Interés:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_techsSeleccionadas.isEmpty)
              Text(
                'Ninguna seleccionada',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _techsSeleccionadas.map((tech) {
                  return Chip(
                    label: Text(tech),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

// PANTALLA 3: RESUMEN MÓVIL

class PantallaResumen extends StatelessWidget {
  final String nombre;
  final String correo;
  final String telefono;
  final String tipoParticipante;
  final List<String> tecnologias;

  const PantallaResumen({
    super.key,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.tipoParticipante,
    required this.tecnologias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Registro'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 28),
                        const SizedBox(width: 8),
                        Text('¡Registro Completado!', style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const Divider(height: 24),
                    ListTile(
                      leading: const Icon(Icons.person_outline_rounded),
                      title: const Text('Nombre completo'),
                      subtitle: Text(nombre, style: const TextStyle(fontSize: 16)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Correo electrónico'),
                      subtitle: Text(correo, style: const TextStyle(fontSize: 16)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text('Teléfono'),
                      subtitle: Text(
                        telefono.isEmpty ? "No especificado" : telefono,
                        style: const TextStyle(fontSize: 16),
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: const Text('Tipo de Participante'),
                      subtitle: Text(tipoParticipante, style: const TextStyle(fontSize: 16)),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    const SizedBox(height: 16),
                    const Text('Tecnologías Seleccionadas:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (tecnologias.isEmpty)
                      Text(
                        'Ninguna seleccionada',
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                      )
                    else
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: tecnologias.map((tech) {
                          return Chip(
                            label: Text(tech),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Volver al Inicio', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}