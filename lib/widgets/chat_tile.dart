import 'package:flutter/material.dart';

Padding chatTile(String name, String message, String time, Function onTap,
    BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
    child: ListTile(
      onTap: () {
        onTap(name, context);
      },
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
            ],
          ),
        ),
        child: const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(
            'assets/group.png',
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(
        name + " - " + message,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
