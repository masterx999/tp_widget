
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ApiService {

  static Uri _url(String chemin) =>
      Uri.parse('${ApiConfig.baseUrl}$chemin');

  // Récupérer les destinations depuis le serveur (GET)
  static Future<List<Destination>> getDestinations() async {

    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 200) {
      throw Exception(
        'Erreur HTTP : ${reponse.statusCode}',
      );
    }

    // Décoder le JSON en conservant les accents
    final List<dynamic> liste =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    // Transformer chaque élément en Destination
    return liste
        .map((element) => Destination.fromJson(element))
        .toList();
  }

  // Envoyer une réservation au serveur (POST)
  static Future<String> creerReservation(
      Reservation reservation) async {

    final reponse = await http
        .post(
          _url('/reservations'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    // Vérifier le code de réponse
    if (reponse.statusCode != 201) {
      throw Exception(
        'Erreur HTTP : ${reponse.statusCode}',
      );
    }

    // Décoder la réponse du serveur
    final Map<String, dynamic> creee =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    // Retourner l'identifiant créé par le serveur
    return creee['id'].toString();
  }
}
