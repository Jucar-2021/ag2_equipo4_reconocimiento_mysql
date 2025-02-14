import 'package:flutter/material.dart';
import 'rec_imag.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Reconocimiento de imagenes",
      debugShowCheckedModeBanner: false,
      home: SplashPantalla(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class SplashPantalla extends StatelessWidget {
  const SplashPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    // Navegar después de 4 segundos
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RecImag()),
      );
    });

    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset("assets/animacion.json"),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Iniciando Aplicación',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),
        ],
      ),
    ));
  }
}
