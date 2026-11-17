import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void close() => _client.close();

  Future<List<Destination>> getDestinations() async {
    final response = await _client
        .get(Uri.parse('${ApiConfig.baseUrl}/destinations'))
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw ApiException(
        'GET /destinations a échoué (HTTP ${response.statusCode}).',
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! List) {
      throw const FormatException('La réponse des destinations est invalide.');
    }

    return json
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Une destination reçue est invalide.');
          }
          return Destination.fromJson(item);
        })
        .toList(growable: false);
  }

  Future<String> creerReservation(Reservation reservation) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}/reservations'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 201) {
      throw ApiException(
        'POST /reservations a échoué (HTTP ${response.statusCode}).',
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic> || json['id'] == null) {
      throw const FormatException(
        'Le serveur n’a pas renvoyé le numéro de réservation.',
      );
    }
    return json['id'].toString();
  }

  Future<List<Reservation>> getReservations() async {
    final response = await _client
        .get(
          Uri.parse('${ApiConfig.baseUrl}/reservations')
              .replace(queryParameters: {'_embed': 'destination'}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw ApiException(
        'GET /reservations a échoué (HTTP ${response.statusCode}).',
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! List) {
      throw const FormatException('La réponse des réservations est invalide.');
    }

    return json
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Une réservation reçue est invalide.');
          }
          return Reservation.fromJson(item);
        })
        .toList(growable: false);
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
