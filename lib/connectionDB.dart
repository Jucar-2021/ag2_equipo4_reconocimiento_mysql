import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'dart:convert';

class BDcon {
  var settings = new ConnectionSettings(
      host: 'database-escuela.czokmqqi64z5.us-east-1.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: '01unideh',
      db: 'medicamentos');

  Future<MySqlConnection> conn() async {
    return await MySqlConnection.connect(settings);
  }

  Future<String> traerDatos() async {
    try {
      var conn = await MySqlConnection.connect(settings);
      var result = await conn.query(
        'SELECT medicamento, presentacion, dosis, contraindicaciones, paraquesirve, conservar, medicamentosimilar '
        'FROM Especificaciones',
      );
      await conn.close();

      print("🔍 Registros obtenidos: ${result.length}");

      // Convertimos el resultado a una lista de mapas
      List<Map<String, dynamic>> medicamentos = [];

      for (var row in result) {
        medicamentos.add({
          'medicamento': row[0],
          'presentacion': row[1],
          'dosis': row[2],
          'contraindicaciones': row[3],
          'paraquesirve': row[4],
          'conservar': row[5],
          'medicamentosimilar': row[6],
        });
      }

      // Verificar si hay datos antes de intentar acceder al índice 9
      if (medicamentos.isNotEmpty) {
        print(
            "-----------------------medicamento: ${medicamentos[9]['medicamento']}");

        if (medicamentos.length > 9) {
          print(
              " Medicamento en posición 5: ${medicamentos[5]['medicamento']}");
        } else {
          print(
              "No hay suficiente cantidad de medicamentos para acceder al índice seleccionado.");
        }
      } else {
        print("No se encontraron medicamentos.");
      }

      // Convertimos la lista de mapas a JSON
      String jsonString = jsonEncode(medicamentos);
      return jsonString;
    } catch (e) {
      print("Error de conexión: $e");
      return jsonEncode({"error": "No se pudieron obtener los datos"});
    }
  }
}
