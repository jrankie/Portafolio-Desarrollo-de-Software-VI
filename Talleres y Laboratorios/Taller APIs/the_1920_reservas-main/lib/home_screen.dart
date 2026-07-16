import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'reserva_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'The 1920',
                  style: TextStyle(fontFamily: 'Georgia', color: appGold, fontSize: 40, letterSpacing: 6),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Speakeasy & Lounge',
                  style: TextStyle(color: appCream, fontSize: 14, letterSpacing: 4),
                ),
                const SizedBox(height: 80),

                _HomeBtn(
                  title: 'AGENDAR NUEVA CITA',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReservaScreen()),
                  ),
                ),
                const SizedBox(height: 24),

                _HomeBtn(
                  title: 'PANEL DE ADMINISTRACIÓN',
                  isOutline: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBtn extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isOutline;

  const _HomeBtn({required this.title, required this.onTap, this.isOutline = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isOutline ? Colors.transparent : appSurface,
            border: Border.all(color: isOutline ? appBorder : appGold),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isOutline ? appCream : appGold,
                letterSpacing: 3,
                fontSize: 13,
                fontWeight: isOutline ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}