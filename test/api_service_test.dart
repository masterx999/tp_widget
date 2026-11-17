import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rihla/models/destination.dart';
import 'package:rihla/models/reservation.dart';
import 'package:rihla/services/api_service.dart';

const destinationJson = {
  'id': 2,
  'nom': 'Djerba',
  'region': 'Médenine',
  'categorie': 'Plage',
  'image': 'assets/images/djerba.png',
  'note': 4.8,
  'prix': 420,
  'duree': '4 jours',
  'description': 'Plages de sable fin.',
};

void main() {
  test('loads destinations and preserves UTF-8 accents', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/destinations');
        return http.Response(
          jsonEncode([destinationJson]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
    addTearDown(service.close);

    final destinations = await service.getDestinations();

    expect(destinations.single.id, '2');
    expect(destinations.single.region, 'Médenine');
    expect(destinations.single.note, 4.8);
  });

  test('posts a reservation and returns its server-generated id', () async {
    late Map<String, dynamic> body;
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/reservations');
        expect(request.headers['content-type'], 'application/json');
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({...body, 'id': 'server-id'}), 201);
      }),
    );
    addTearDown(service.close);

    final reservation = Reservation(
      destination: Destination.fromJson(destinationJson),
      nom: 'Amira',
      email: 'amira@mail.tn',
      telephone: '22123456',
      dateDepart: DateTime(2026, 12, 15),
      voyageurs: 2,
      formule: 'Confort',
    );

    expect(await service.creerReservation(reservation), 'server-id');
    expect(body['destinationId'], '2');
    expect(body['total'], 1092);
    expect(body['dateDepart'], '2026-12-15T00:00:00.000');
  });

  test('loads reservations with their embedded destinations', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/reservations');
        expect(request.url.queryParameters['_embed'], 'destination');
        return http.Response(
          jsonEncode([
            {
              'id': 'reservation-id',
              'destinationId': '2',
              'nom': 'Amira',
              'email': 'amira@mail.tn',
              'telephone': '22123456',
              'dateDepart': '2026-12-15T00:00:00.000',
              'voyageurs': 2,
              'formule': 'Confort',
              'total': 1092,
              'destination': destinationJson,
            },
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
    addTearDown(service.close);

    final reservations = await service.getReservations();

    expect(reservations.single.id, 'reservation-id');
    expect(reservations.single.destination.nom, 'Djerba');
    expect(reservations.single.dateDepart, DateTime(2026, 12, 15));
    expect(reservations.single.total, 1092);
  });

  test(
    'reports unsuccessful API responses instead of returning empty data',
    () {
      final service = ApiService(
        client: MockClient((_) async => http.Response('Unavailable', 503)),
      );
      addTearDown(service.close);

      expect(
        service.getDestinations(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            contains('503'),
          ),
        ),
      );
    },
  );
}
