import 'dart:convert';
import 'dart:io';
import 'package:ag2_equipo4_reconocimiento_mysql/connectionDB.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Detalles extends StatefulWidget {
  int index;
  String label;
  File? img;
  Detalles(
      {super.key, required this.index, required this.label, required this.img});

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  late int _index;
  late String _label;
  late final File? _image = widget.img;
  late Future<String> _futureMedicamentos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _index = widget.index;
    _label = widget.label;
    print(_index);
    print(_label);
    BDcon conn = BDcon();
    _futureMedicamentos = conn.traerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(_label),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 280,
              height: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _image == null ? Container() : Image.file(_image!),
                ],
              )),
          Text(
            "Especicaciones del medicamento",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: FutureBuilder<String>(
              future: _futureMedicamentos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No se encontraron medicamentos"));
                }

                List<dynamic> medicamentos = jsonDecode(snapshot.data!);

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    rowInfo("Código:", _index.toString()),
                    rowInfo(
                        "Medicamento:", medicamentos[_index]['medicamento']),
                    rowInfo(
                        "Presentación:", medicamentos[_index]['presentacion']),
                    rowInfo("Dosis:", medicamentos[_index]['dosis']),
                    rowInfo("Contraindicaciones:",
                        medicamentos[_index]['contraindicaciones']),
                    rowInfo(
                        "Sirve Para:", medicamentos[_index]['paraquesirve']),
                    rowInfo("Conservación:", medicamentos[_index]['conservar']),
                    rowInfo("Medicamento Similar:",
                        medicamentos[_index]['medicamentosimilar']),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rowInfo(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? "N/A"),
          ),
        ],
      ),
    );
  }
}
