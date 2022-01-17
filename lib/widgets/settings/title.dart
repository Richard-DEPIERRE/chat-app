import 'package:flutter/material.dart';

Card title(String title, double top) {
  return Card(
    elevation: 0,
    color: const Color.fromARGB(246, 246, 246, 255),
    margin: EdgeInsets.fromLTRB(0, top, 0, 0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 0, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}