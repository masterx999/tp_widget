import 'destination.dart';

class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime dateDepart;
  final int voyageurs;
  final String formule; // 'Essentiel' ou 'Confort'

  const Reservation({
    this.id,
    required this.destination,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.dateDepart,
    required this.voyageurs,
    required this.formule,
  });

  // Formule Confort : +30 % sur le prix par personne.
  int get prixParPersonne => formule == 'Confort'
      ? (destination.prix * 1.3).round()
      : destination.prix;

  int get total => prixParPersonne * voyageurs;

  Map<String, dynamic> toJson() => {
    'destinationId': destination.id,
    'nom': nom,
    'email': email,
    'telephone': telephone,
    'dateDepart': dateDepart.toIso8601String(),
    'voyageurs': voyageurs,
    'formule': formule,
    'total': total,
  };

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final reservationId = json['id'];
    final destinationJson = json['destination'];
    if (reservationId == null || destinationJson is! Map<String, dynamic>) {
      throw const FormatException(
        'La réservation reçue ne contient pas son identifiant ou sa destination.',
      );
    }

    return Reservation(
      id: reservationId.toString(),
      destination: Destination.fromJson(destinationJson),
      nom: json['nom'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String,
      dateDepart: DateTime.parse(json['dateDepart'] as String),
      voyageurs: (json['voyageurs'] as num).toInt(),
      formule: json['formule'] as String,
    );
  }
}
