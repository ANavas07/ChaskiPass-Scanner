import 'dart:convert';
import 'package:passengercontrol_chaskipass/helpers/constants.helpers.dart';
import 'package:http/http.dart' as http;

class FrequenciesService {
  static final http.Client _client = http.Client();

  static Uri getUri(String path) =>
      Uri.http(AppConstants.API_URL, '/chaski/api/$path');

  static void closeClient() {
    _client.close();
  }

  Future<List<Map<String, dynamic>>> getFrequencies(String id) async {
    try {
      var uri = getUri('frequency/frequenciesPhone/$id');
      var response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var data = jsonDecode(response.body);

        // Asegurarte de que la estructura coincide con tu respuesta
        if (data['json'] != null &&
            data['json']['listFrequencies'] != null &&
            data['json']['listFrequencies'] is List) {
          return List<Map<String, dynamic>>.from(
            data['json']['listFrequencies'],
          );
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
