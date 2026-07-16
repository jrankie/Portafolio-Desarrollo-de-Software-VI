import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_theme.dart';

class ReservaScreen extends StatefulWidget {
  final Map<String, dynamic>? reservaExistente;

  const ReservaScreen({super.key, this.reservaExistente});

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _telefono = TextEditingController();
  final _notas = TextEditingController();

  int _personas = 2;
  DateTime? _fechaHora;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.reservaExistente != null) {
      final r = widget.reservaExistente!;
      _nombre.text = r['nombre'] ?? '';
      _email.text = r['email'] ?? '';
      _telefono.text = r['telefono'] ?? '';
      _notas.text = r['notas'] ?? '';
      _personas = r['personas'] ?? 2;
      if (r['fecha_hora'] != null) {
        _fechaHora = DateTime.parse(r['fecha_hora']).toLocal();
      }
    }
  }

  Future<void> _guardarReserva() async {
    if (!_formKey.currentState!.validate() || _fechaHora == null) {
      if (_fechaHora == null) _showSnack('Selecciona fecha y hora');
      return;
    }

    setState(() => _loading = true);

    try {
      final data = {
        'nombre': _nombre.text.trim(),
        'email': _email.text.trim(),
        'telefono': _telefono.text.trim(),
        'personas': _personas,
        'fecha_hora': _fechaHora!.toIso8601String(),
        'notas': _notas.text.trim().isEmpty ? null : _notas.text.trim(),
      };

      if (widget.reservaExistente == null) {
        await _supabase.from('reservas').insert(data);
      } else {
        await _supabase.from('reservas').update(data).eq('id', widget.reservaExistente!['id']);
      }

      if (mounted) _showSuccess();
    } catch (e) {
      if (mounted) _showSnack('Error al guardar. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: const TextStyle(color: appCream)), backgroundColor: appSurface),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2), side: const BorderSide(color: appBorder)),
        title: const Text('Éxito', style: TextStyle(fontFamily: 'Georgia', color: appCream, fontSize: 20)),
        content: Text(
          widget.reservaExistente == null ? 'Tu mesa está reservada.\nNos vemos esta noche.' : 'La reserva se actualizó correctamente.',
          style: const TextStyle(color: appCreamDim, fontStyle: FontStyle.italic, height: 1.7),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.reservaExistente != null) {
                Navigator.pop(context);
              } else {
                _formKey.currentState!.reset();
                _nombre.clear(); _email.clear(); _telefono.clear(); _notas.clear();
                setState(() { _fechaHora = null; _personas = 2; });
              }
            },
            child: const Text('Cerrar', style: TextStyle(color: appGold, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFechaHora() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaHora ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: appGold, surface: appSurface), dialogBackgroundColor: appBg),
        child: child!,
      ),
    );
    if (fecha == null || !mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: _fechaHora != null ? TimeOfDay.fromDateTime(_fechaHora!) : const TimeOfDay(hour: 20, minute: 0),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: appGold, surface: appSurface), dialogBackgroundColor: appBg),
        child: child!,
      ),
    );
    if (hora == null) return;

    setState(() {
      _fechaHora = DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      appBar: AppBar(
        backgroundColor: appBg,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: appGold),
        title: Text(
          widget.reservaExistente == null ? 'NUEVA RESERVA' : 'EDITAR RESERVA',
          style: const TextStyle(fontFamily: 'Georgia', color: appGold, letterSpacing: 4, fontSize: 16),
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: appBorder)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.reservaExistente == null ? 'Tu mesa te espera' : 'Actualiza los datos',
                  style: const TextStyle(fontFamily: 'Georgia', color: appCream, fontSize: 28, letterSpacing: 1)),
              const SizedBox(height: 32),

              CustomTextField(controller: _nombre, label: 'Nombre completo', validator: (v) => v!.isEmpty ? 'Requerido' : null),
              CustomTextField(controller: _email, label: 'Email', keyboardType: TextInputType.emailAddress, validator: (v) => v!.contains('@') ? null : 'Email inválido'),
              CustomTextField(controller: _telefono, label: 'Teléfono / WhatsApp', keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Requerido' : null),

              const CustomLabel('Número de personas'),
              const SizedBox(height: 8),
              Row(
                children: [
                  CustomCountBtn(icon: Icons.remove, onTap: () { if (_personas > 1) setState(() => _personas--); }),
                  const SizedBox(width: 16),
                  Text('$_personas', style: const TextStyle(color: appCream, fontSize: 22, fontFamily: 'Georgia')),
                  const SizedBox(width: 16),
                  CustomCountBtn(icon: Icons.add, onTap: () { if (_personas < 20) setState(() => _personas++); }),
                ],
              ),
              const SizedBox(height: 24),

              const CustomLabel('Fecha y hora'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickFechaHora,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: appSurface, border: Border.all(color: appBorder)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: appGold, size: 16),
                      const SizedBox(width: 12),
                      Text(
                        _fechaHora == null
                            ? 'Seleccionar fecha y hora'
                            : '${_fechaHora!.day}/${_fechaHora!.month}/${_fechaHora!.year}  —  ${_fechaHora!.hour.toString().padLeft(2,'0')}:${_fechaHora!.minute.toString().padLeft(2,'0')}',
                        style: TextStyle(color: _fechaHora == null ? appCreamDim : appCream, fontStyle: _fechaHora == null ? FontStyle.italic : FontStyle.normal),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(controller: _notas, label: 'Notas especiales (opcional)', maxLines: 3, validator: (_) => null),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _loading ? null : _guardarReserva,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(border: Border.all(color: appGold), color: _loading ? appSurface : Colors.transparent),
                    child: Center(
                      child: _loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: appGold, strokeWidth: 1.5))
                          : Text(widget.reservaExistente == null ? 'RESERVAR AHORA' : 'GUARDAR CAMBIOS', style: const TextStyle(color: appGold, letterSpacing: 4, fontSize: 13)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombre.dispose(); _email.dispose();
    _telefono.dispose(); _notas.dispose();
    super.dispose();
  }
}