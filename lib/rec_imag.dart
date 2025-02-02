import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';
import 'detallesMedicamento.dart';
import 'message.dart';

class RecImag extends StatefulWidget {
  const RecImag({super.key});

  @override
  State<RecImag> createState() => _RecImagState();
}

class _RecImagState extends State<RecImag> {
  List? _outputs;
  File? img;
  bool _loading = false;
  late Alertas _alertas = Alertas();

  @override
  void initState() {
    super.initState();

    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento de imagenes'),
        centerTitle: true,
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  img == null
                      ? Container()
                      : Container(
                          width: 300,
                          height: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Image.file(img!)],
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  img == null
                      ? Container()
                      : _outputs != null
                          ? Text(
                              "${_outputs![0]["label"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                background: Paint()..color = Colors.black,
                              ),
                            )
                          : Container(child: const Text("")),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                              (stado) {
                                if (stado.contains(WidgetState.pressed)) {
                                  return Colors.orange;
                                }
                              },
                            ),
                          ),
                          onPressed: () {
                            if (_outputs != null) {
                              var resultado = _outputs![
                                  0]; // Obtener el primer resultado de la lista
                              int index =
                                  resultado["index"]; //Extraer el índice
                              double confidence =
                                  resultado["confidence"]; //Extraer confianza
                              String label =
                                  resultado["label"]; //Extraer etiqueta

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detalles(
                                      index: index, label: label, img: img),
                                ),
                              );
                            } else {
                              _alertas.message(context, 'Faltan Datos',
                                  'Agrega una imagen!!!!');
                              print('>>>>>>>>>>>>>>>>>>>>>>no hay nada');
                            }
                          },
                          child: Text(
                            "Ver especificaciones",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: pickImageCamera,
                        tooltip: 'Abrir Camara',
                        child: const Icon(Icons.camera),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: pickImage,
                        tooltip: 'Abrir Galeria',
                        child: const Icon(Icons.image),
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    //boton de limpiar
                    heroTag: null,
                    onPressed: () {
                      setState(() {
                        img = null;
                        _outputs = null;
                      });
                    },
                    tooltip: 'Limpiar',
                    child: const Icon(Icons.cleaning_services),
                  ),
                ],
              ),
            ),
    );
  }

  //cargar el modelo
  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  //cargar la imagen de la galeria
  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _loading = true;
      img = File(image.path);
    });
    classifyImage(image.path);
  }

  //cargar la imagen de la camara
  pickImageCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _loading = true;
      img = File(image.path);
    });
    classifyImage(image.path);
  }

  //metodo para clasificar la imagen
  classifyImage(image) async {
    var output = await Tflite.runModelOnImage(
      path: image,
      numResults: 5,
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
    );
    print('visulaicacion de resultados>>>>>>>>>>>>>>>>> : $output');
    setState(
      () {
        _loading = false;
        _outputs = output!;
      },
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
