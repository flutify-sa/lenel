import 'package:flutter/material.dart';

class ProfileMyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscuretext;

  const ProfileMyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscuretext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        style: TextStyle(color: Colors.grey.shade700), // Text color
        decoration: InputDecoration(
          filled: true, // Enables background color
          fillColor: Colors.grey.shade50, // Background color
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: BorderSide(
              color: Colors.white, // Border color when not focused
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: BorderSide(
              color: Colors.amber, // Border color when focused
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade800), // Hint text color
        ),
      ),
    );
  }
}
