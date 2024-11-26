import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isTapped = false; 

  void _handleTap() {
    setState(() {
      isTapped = true; 
    });

    
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isTapped = false; 
      });
    });

    if (widget.onTap != null) {
      widget.onTap!(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap, 
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), 
        decoration: BoxDecoration(
          color: isTapped 
              ? Colors.pink 
              : Theme.of(context).colorScheme.primary, 
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 173, 170, 170), // Yazı rengi
            ),
          ),
        ),
      ),
    );
  }
}
