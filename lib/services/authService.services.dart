import 'dart:convert';
import 'package:passengercontrol_chaskipass/helpers/constants.helpers.dart';
import 'package:http/http.dart' as http;
import 'package:passengercontrol_chaskipass/models/loginRequest.models.dart';

class AuthService {
  static Uri getUri(String path) =>
      Uri.http(AppConstants.API_URL, '/chaski/api/$path');
  static final http.Client _client = http.Client();

  //Para cerrar el cliente
  static void closeClient() {
    _client.close();
  }

  Future<String> logIn(LoginRequest loginData) async {
    try {
      var uri = getUri('auth/login');
      var response = await _client.post(
        uri,
        body: jsonEncode({
          "user_name": loginData.username,
          "email": loginData.email,
          "password": loginData.password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.body.isNotEmpty) {
        return response.body;
      } else {
        return 'Error al iniciar sesión: ${response.statusCode}';
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
