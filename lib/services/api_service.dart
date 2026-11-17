import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/destination.dart';

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
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
