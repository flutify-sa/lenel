import 'package:flutter/material.dart';

class MyProfileButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyProfileButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin:
              EdgeInsets.symmetric(horizontal: 10), // Adjust margin as needed
          decoration: BoxDecoration(
            color: Color(0xffe6cf8c),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
