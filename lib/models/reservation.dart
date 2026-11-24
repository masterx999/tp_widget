import 'destination.dart';

class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime dateDepart;
  final int voyageurs;
  final String formule;

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

  // Calcul du prix total
  int get total => prixParPersonne * voyageurs;

  // Transformer la réservation en JSON
  Map<String, dynamic> toJson() {
    return {
      'destinationId': destination.id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'dateDepart': dateDepart.toIso8601String(),
      'voyageurs': voyageurs,
      'formule': formule,
      'total': total,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final destinationJson = json['destination'] as Map<String, dynamic>;

    return Reservation(
      id: json['id']?.toString(),
      destination: Destination.fromJson(destinationJson),
      nom: json['nom'].toString(),
      email: json['email'].toString(),
      telephone: json['telephone'].toString(),
      dateDepart: DateTime.parse(json['dateDepart'].toString()),
      voyageurs: (json['voyageurs'] as num).toInt(),
      formule: json['formule'].toString(),
    );
  }
}
