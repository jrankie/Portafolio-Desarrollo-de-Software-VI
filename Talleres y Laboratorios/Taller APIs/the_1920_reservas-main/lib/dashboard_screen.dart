import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_theme.dart';
import 'reserva_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _supabase = Supabase.instance.client;

  Future<void> _borrarReserva(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: appSurface,
        title: const Text('¿Cancelar reserva?', style: TextStyle(color: appCream)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No', style: TextStyle(color: appCreamDim))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sí, borrar', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );

    if (confirmar == true) {
      await _supabase.from('reservas').delete().eq('id', id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      appBar: AppBar(
        backgroundColor: appBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: appGold),
        title: const Text('Reservas', style: TextStyle(fontFamily: 'Georgia', color: appGold, fontSize: 18, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: appGold),
            tooltip: 'Agregar nueva reserva',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReservaScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: appBorder)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _supabase.from('reservas').stream(primaryKey: ['id']).order('fecha_hora'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: appGold));
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar datos', style: TextStyle(color: Colors.redAccent)));
          }

          final reservas = snapshot.data ?? [];

          if (reservas.isEmpty) {
            return const Center(child: Text('No hay reservas registradas.', style: TextStyle(color: appCreamDim)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reservas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = reservas[index];
              final fecha = DateTime.parse(r['fecha_hora']).toLocal();
              final fechaTxt = '${fecha.day}/${fecha.month}/${fecha.year} - ${fecha.hour.toString().padLeft(2,'0')}:${fecha.minute.toString().padLeft(2,'0')}';

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: appSurface, border: Border.all(color: appBorder)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['nombre'], style: const TextStyle(color: appCream, fontSize: 18, fontFamily: 'Georgia', fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(fechaTxt, style: const TextStyle(color: appGold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${r['personas']} personas • ${r['telefono']}', style: const TextStyle(color: appCreamDim, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: appCreamDim),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ReservaScreen(reservaExistente: r),
                        ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => _borrarReserva(r['id']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}