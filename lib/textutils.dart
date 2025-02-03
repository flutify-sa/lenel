// text_utils.dart
import 'package:flutter/material.dart';

List<TextSpan> parseContractText(String text) {
  final List<TextSpan> textSpans = [];
  final regex = RegExp(r'\$(\w+)'); // Matches text after $

  int start = 0;
  for (var match in regex.allMatches(text)) {
    // Add text before the variable
    if (match.start > start) {
      textSpans.add(TextSpan(text: text.substring(start, match.start)));
    }

    // Add the variable with bold styling
    textSpans.add(
      TextSpan(
        text: match.group(1), // The variable name (e.g., name, surname)
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    start = match.end;
  }

  // Add remaining text after the last variable
  if (start < text.length) {
    textSpans.add(TextSpan(text: text.substring(start)));
  }

  return textSpans;
}
