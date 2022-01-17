import 'package:flutter/material.dart';

SwitchListTile switchTile(
    String name, IconData icon, bool value, Function funct) {
  return SwitchListTile(
    activeTrackColor: const Color(0xffff765b),
    activeColor: const Color(0xffff765b),
    inactiveTrackColor: Colors.grey,
    title: Text(
      name,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    value: value,
    onChanged: (bool value) {
      funct(value);
    },
    secondary: Icon(icon),
  );
}