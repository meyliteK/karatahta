import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? prefixIcon; // Başta gösterilecek ikon
  final IconData? suffixIcon; // Sonda gösterilecek ikon
  final VoidCallback? onSuffixTap; // Suffix ikonuna tıklama işlemi

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),

        // İkonlar
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey)
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: Colors.grey),
              )
            : null,
      ),
    );
  }
}


/*
    
    
    TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        
      ),
      obscureText: obscureText,
    );*/