import 'package:final_year_project/them/color.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onpressd;
  MyButton({required this.text, required this.color, required this.onpressd});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: color,
      borderRadius: BorderRadius.circular(15),
      child: MaterialButton(
        height: 40,
        minWidth: double.infinity,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onPressed: onpressd,
      ),
    );
  }
}
