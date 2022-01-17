import 'package:flutter/material.dart';

ListTile tile(IconData leadingIcon, String name, bool isArrow) {
  return ListTile(
    leading: Icon(
      leadingIcon,
      color: Colors.grey,
    ),
    title: Text(
      name,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(
      isArrow ? Icons.arrow_forward_ios_sharp : null,
      size: 20,
    ),
  );
}