import 'dart:convert';
import 'package:passengercontrol_chaskipass/helpers/constants.helpers.dart';
import 'package:http/http.dart' as http;


class ClientsFrequencyService {
  static final http.Client _client = http.Client();


  static Uri getUri(String path) =>
      Uri.http(AppConstants.API_URL, '/chaski/api/$path');

  static void closeClient() {
    _client.close();
  }

  Future<List<Map<String, dynamic>>> getClientsFrequency() async {
    try {
      var uri = getUri('tickets/Allclients/bbb95e83-1');
      var response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var data = jsonDecode(response.body);

        // Asegurarte de que la estructura coincide con tu respuesta
        if (data['clientList'] != null) {
          return List<Map<String, dynamic>>.from(data['clientList']);
        } else {
          throw Exception('La estructura de la respuesta no es válida.');
        }
      } else {
        throw Exception(
          'Error al obtener las frecuencias: Código de estado ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener las frecuencias: $e');
    }
  }
}