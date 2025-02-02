import 'package:flutter/material.dart';

class Alertas {
  void message(BuildContext context, String ti, String men) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ti),
          content: Text(
            men,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 50,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'))
          ],
        );
      },
    );
  }
}
