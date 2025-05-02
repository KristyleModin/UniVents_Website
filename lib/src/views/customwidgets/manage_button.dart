import 'package:flutter/material.dart';

class ManageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ManageButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x44000088),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: const Color(0xFF1428A0), 
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(20), 
            child: Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}