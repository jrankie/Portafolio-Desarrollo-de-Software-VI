import 'package:flutter/material.dart';

//  COLORES GLOBALES
const appBg = Color(0xFF0A0805);
const appSurface = Color(0xFF120E08);
const appGold = Color(0xFFC9A84C);
const appCream = Color(0xFFF5EDD6);
const appCreamDim = Color(0xFF8A7A5A);
const appBorder = Color(0xFF2A2010);

//  WIDGETS REUTILIZABLES GLOBALES
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?) validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: appCream),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: appCreamDim, fontSize: 13),
          filled: true,
          fillColor: appSurface,
          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: appBorder)),
          enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: appBorder)),
          focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: appGold)),
          errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.redAccent)),
          focusedErrorBorder: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.redAccent)),
        ),
      ),
    );
  }
}

class CustomLabel extends StatelessWidget {
  final String text;
  const CustomLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: appCreamDim, fontSize: 13));
}

class CustomCountBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CustomCountBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(border: Border.all(color: appBorder), color: appSurface),
          child: Icon(icon, color: appGold, size: 18)
      ),
    );
  }
}